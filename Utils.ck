public class Utils {
  // franction of a second turns to number of samples in current sample rate
  fun static int stos (float fraction) {
    float sampleRate;

    second / samp =>
      sampleRate;

    return (fraction * sampleRate) $ int;
  }

  // overloaded stos for a single second, i.e. a sample rate
  fun static int stos () {
    return stos(1);
  }
}


