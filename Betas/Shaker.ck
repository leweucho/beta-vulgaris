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

  SHAKER

  Shaker is a simple sound buffer player with additional shake feature.
  When triggered the playhead jumps 1-6 times within [-1, +3] seconds
  window around the current playhead position. After that the playhead
  returns to the position where it would be if no interuptions ever
  happened, i.e. trigger time position + total time of interuptions.
  This way the overall pulse of the file is not distructed. Every playhead
  jump is enveloped.

  EXAMPLE USE

  Shaker s => dac;

  "Beethoven_Piano_Sonata_No1_III_Menuetto.wav" =>
    s.read;

  2::second => now;

  for (0 => int i; i < 5; i++) {
    s.shake();
    2::second => now;
  }
*/

public class Shaker extends Chubgraph {
  SndBuf buf;
  Envelope env;

  // shake envelope parameters
  float totalSec;
  dur totalDur;
  dur attackDur;
  dur decayDur;
  dur cachedEnvDur;

  int numOfRepetitions;

  int currentPosition;
  int resumePosition;

  {
      0.1 =>
        totalSec;

      totalSec::second =>
        totalDur;

      totalDur * 0.8 =>
        attackDur;

      totalDur * 0.2 =>
        decayDur;

      10::ms =>
        env.duration;

      buf => env => outlet;

      spork ~ play();
  }

  fun void read (string path) {
      path =>
        buf.read;
  }

  fun void play () {
    env.keyOn();

    while (true) {
      1::samp => now;
    }
  }

  fun void shake () {
    Math.random2(1, 6) =>
      numOfRepetitions;

    // cache current settings
    buf.pos() =>
      currentPosition;

    currentPosition + Utils.stos(numOfRepetitions * totalSec) =>
      resumePosition;

    env.duration() =>
      cachedEnvDur;

    // run the shaker
    decayDur =>
      env.duration;

    for (0 => int i; i < numOfRepetitions; i++) {
      Math.random2(
        currentPosition - Utils.stos(1),
        currentPosition + Utils.stos(3)
      ) => buf.pos;

      env.keyOn();
      attackDur => now;

      env.keyOff();
      decayDur => now;
    }

    // resume to normal mode
    resumePosition => buf.pos;
    cachedEnvDur => env.duration;

    env.keyOn();
  }
}

