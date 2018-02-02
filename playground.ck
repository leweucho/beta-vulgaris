/*
  --- MIT License --------------------------------------------------------------

  Copyright (c) 2018 Lewe Ucho

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

  ------------------------------------------------------------------------------

  PLAYGROUND

  A sandbox for easy prototyping. Use it via flags passed as command-line
  arguments:

   * shaker:<path_to_some_wav_file>
   * bezier

  with a collection of dependencies, i.e.:

  $ chuck Curves/Point Curves/Bezier2D Utils Betas/Shaker \
    playground.ck:shaker:<path_to_some_wav_file>

  $ chuck Curves/Point Curves/Bezier2D Utils Betas/Shaker \
    playground.ck:bezier

*/

if (me.arg(0) == "shaker") {
  Shaker s => dac;

  me.dir() + me.arg(1) =>
    s.read;

  2::second => now;

  for (0 => int i; i < 5; i++) {
    s.shake();
    2::second => now;
  }
}

if (me.arg(0) == "bezier") {
  Point a, b, c, d;
    0 => a.x; 500 => a.y;
    0 => b.x;   0 => b.y;
  150 => c.x;  50 => c.y;
  200 => d.x;   0 => d.y;

  [a, b, c, d]
    @=> Point points[];

  Bezier2D.theCurve(points, 100)
    @=> Point result[];

  SinOsc s => Gain g => dac;
  0.5 => g.gain;

  for (0 => int i; i < result.cap(); ++i) {
    result[i].y() + 300 => s.freq;

    100::ms => now;
  }
}
