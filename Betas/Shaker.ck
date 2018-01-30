public class Shaker extends Chubgraph {
  SndBuf buf;
  Envelope env;

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
      path => buf.read;
  }

  fun void play () {
    env.keyOn();

    while (true) {
      1::samp => now;
    }
  }

  // mess up with the sound
  fun void shake () {
    // cache current settings
    Math.random2(1, 6) =>
      numOfRepetitions;

    buf.pos() =>
      currentPosition;

    currentPosition + Utils.stos(numOfRepetitions * totalSec) =>
      resumePosition;

    env.duration() =>
      cachedEnvDur;

    // run the shaker
    decayDur => env.duration;

    for (0 => int i; i < numOfRepetitions; i++) {
      Math.random2(
        currentPosition - Utils.stos(),
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

