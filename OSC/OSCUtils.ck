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

  OSC UTILS

  A collection of commonly used OSC helpers bundled as a static class.

  EXAMPLE USE

  OSCUtils.atofa(csv) @=> float dataPoints[];

*/

public class OSCUtils {
  /*
   * CSV string into float array
   *
   * Expamples:
   *   "1,2.0,3.14"  »  [ 1.000000, 2.000000, 3.140000 ]
   *   "1"           »  [ 1.000000 ]
   */
  fun static float[] atofa(string csv) {
    csv @=> string tmp;
    0 => int i;

    while (tmp.find(",") != -1) {
      1 +=> i;
      tmp.substring(tmp.find(",") + 1) @=> tmp;
    }

    float dataPoints[i+1];
    for (0 => i; i < dataPoints.cap(); ++i) {
      csv.find(",") => int comma;

      if (comma != -1) {
        Std.atof(csv.substring(0, comma)) => dataPoints[i];
        csv.substring(comma + 1) @=> csv;
      } else if (csv.length() != 0) {
        Std.atof(csv) => dataPoints[i];
      } else {
        0.0 => dataPoints[i];
      }
    }

    return dataPoints;
  }
}

