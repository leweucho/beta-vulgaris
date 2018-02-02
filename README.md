# Beta Vulgaris
Audio engine for live performance written in [ChucK Language](http://chuck.cs.princeton.edu/).

Playground supports simple feature flags letting you run separate features each at time. To run them you provide argument to `playground` shred. Available options are:

 * shaker:<path_to_some_wav_file>
 * bezier

Use them as follows:

```bash
$ chuck Curves/Point Curves/Bezier2D Utils Betas/Shaker playground.ck:shaker:<path_to_some_wav_file>
```

```bash
$ chuck Curves/Point Curves/Bezier2D Utils Betas/Shaker playground.ck:bezier
```

In future better sample code loader and runner will be provided.
