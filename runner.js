const fs = require('fs')
const { spawn } = require('child_process');

const extractDependencies = (fileContent, depTree) =>
  // take all classNames from depTree and check if they appear
  // in the file to be run
  Object.keys(depTree)
        .filter(className => {
            const rx = new RegExp(className, 'g')
            return rx.test(fileContent)
        })

const collectDependencies = (className, level = 0, depTree) =>
  // traverse the depTree to collect all dependencies down the tree
  // marking the depth level for each dependency
  [ { className, level } ].concat(
    depTree[ className ].reduce(
      (acc, dep) => acc.concat(collectDependencies(dep, level + 1, depTree)),
      []
    ))

const buildCmdDeps = (fileContent, depTree, paths) =>
  // collect all classNames used in the file to be run
  extractDependencies(fileContent, depTree)
    // collect all dependencies for each of them
    .reduce((acc, className) =>
      acc.concat(collectDependencies(className, 0, depTree)), [])
    // sort them by their depth level
    .sort((a, b) => a.level >= b.level ? -1 : 1)
    // for the duplicates leave only the deepest one
    .reduce((acc, dep) =>
      acc.findIndex(e => e === dep.className) === -1
        ? [ dep.className ].concat(acc)
        : acc
    , [])
    // collect corresponding class file paths
    .map(className => paths[className])
    // reverse to keep the leafs first and go up the dep tree
    .reverse()

// automate depTree extraction from the file system
const depTree = {
  Bezier2D: [ 'Point' ],
  Point: [],
  Shaker: [ 'Utils' ],
  Utils: []
}

// automate paths extraction from the file system
const paths = {
  Bezier2D: 'Curves/Bezier2D',
  Point: 'Curves/Point',
  Shaker: 'Betas/Shaker',
  Utils: 'Utils'
}

const [ _, __, file, ...ops ] = process.argv
fs.readFile(
  file.endsWith('.ck') ? file : `${file}.ck`,
  'utf-8',
  (err, fileContent) => {
    const deps = buildCmdDeps(fileContent, depTree, paths)
    const params = deps.concat(`${file}:${ops.join(':')}`)

    const child = spawn('chuck', params)
    child.stdout.pipe(process.stdout);
    child.stderr.pipe(process.stderr);
  }
)
