// franction of a second turns to number of samples in current sample rate
fun int stos (float fraction) {
  float sampleRate;

  second / samp =>
    sampleRate;

  return (fraction * sampleRate) $ int;
}

// overloaded stos for a single second, i.e. a sample rate
fun int stos () {
  return stos(1);
}

// mess up with the sound
fun void shake (SndBuf s, Envelope env) {
  float totalSec;
  dur totalDur;
  dur attackDur;
  dur decayDur;
  dur cachedEnvDur;

  int numOfRepetitions;

  int currentPosition;
  int resumePosition;

  0.1 =>
    totalSec;

  totalSec::second =>
    totalDur;

  totalDur * 0.8 =>
    attackDur;

  totalDur * 0.2 =>
    decayDur;

  env.duration() =>
    cachedEnvDur;

  Math.random2(1, 6) =>
    numOfRepetitions;

  s.pos() =>
    currentPosition;

  currentPosition + stos(numOfRepetitions * totalSec) =>
    resumePosition;

  // run the shaker
  decayDur => env.duration;

  for (0 => int i; i < numOfRepetitions; i++) {
    Math.random2(
      currentPosition - stos(),
      currentPosition + stos(3)
    ) => s.pos;

    env.keyOn();
    attackDur => now;

    env.keyOff();
    decayDur => now;
  }

  // resume to normal mode
  resumePosition => s.pos;
  cachedEnvDur => env.duration;
}

// --- PLAYGROUND STARTS HERE
SndBuf s => Envelope env => dac;

me.dir() + me.arg(0) =>
  s.read;

stos(30) =>
  s.pos;

0.1::second =>
  dur envDur;

envDur =>
  env.duration;

for (0 => int i; i < 4; i++) {
  env.keyOn();
  2::second => now;

  env.keyOff();
  envDur => now;

  shake(s, env);
}

env.keyOn();
2::second => now;

env.keyOff();
envDur => now;
