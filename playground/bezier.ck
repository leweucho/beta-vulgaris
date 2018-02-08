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

  BEZIER2D PLAYGROUND

  A sandbox for easy prototyping with Bezier2D class.

  $ node runner.js playground/bezier

*/


fun float[] normalize (float curve[]) {
  float inMax;
  float result[curve.cap()];

  for (0 => int i; i < curve.cap(); ++i) {
    if (curve[i] > inMax) {
      curve[i]
        => inMax;
    }
  }

  for (0 => int i; i < curve.cap(); ++i) {
    (curve[i] / inMax) * 0.8 + 0.2
      => result[i];
  }

  return result;
}

fun void playSnd (string path, float gain, float master) {
    SndBuf s => Envelope e => Gain g => dac;
    5::ms => e.duration;
    master => g.gain;
    1 => s.loop;

    path => s.read;
    gain => s.gain;

    e.keyOn();
    s.length() => now;
    e.keyOff();
}

fun void ballDrop (string path, float master) {
  Point a, b, c, d;
    0 => a.x; Math.random2(100, 600) => a.y;
    0 => b.x;   0 => b.y;
  150 => c.x; Math.random2(50, 100) => c.y;
  200 => d.x;   0 => d.y;

  [a, b, c, d]
    @=> Point points[];

  Bezier2D.theCurve(points, Math.random2(20, 30))
    @=> float result[];

  normalize(result)
    @=> float gains[];

  for (0 => int i; i < result.cap(); ++i) {
    spork ~ playSnd(path, gains[i], master);
    result[result.cap() - 1 - i]::ms => now;
  }
  100::ms => now;
}

[ "audio/Cabassa1.wav",
  "audio/SeedShellShaker3.wav",
  "audio/Cabassa4.wav",
  "audio/SeedShellShaker5.wav",
  "audio/SeedShellShaker2.wav",
  "audio/SeedShellShaker4.wav",
  "audio/Cabassa3.wav",
  "audio/SeedShellShaker6.wav",
  "audio/Cabassa2.wav",
  "audio/SeedShellShaker7.wav" ]
  @=> string paths[];

6 => int numOfBalls;

for (0 => int times; times < 1; times++ ) {
  for (0 => int i; i < numOfBalls; ++i) {
    spork ~ ballDrop(paths[i], 1.0 / numOfBalls);
  }
  Math.random2(50, 200)::ms => now;
}
4::second => now;
