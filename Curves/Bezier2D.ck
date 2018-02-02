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

  BEZIER2D
  A simple generator of 2D Bezier curves represented as an Array of Points.

  EXAMPLE USE
  Point a, b, c, d;
    0 => a.x;   0 => a.y;
   50 => b.x; 100 => b.y;
  150 => c.x; 100 => c.y;
  200 => d.x;   0 => d.y;

  [a, b, c, d] @=> Point points[];
  Bezier2D.theCurve(points, 10) @=> Point result[];

  for (0 => int i; i < result.cap(); i++) {
    <<< result[i].x(), result[i].y() >>>;
  }

*/

public class Bezier2D {
  fun static float newton(int n, int k) {
    float a;
    float b;
    int i;

    1.0 => a;
    for (n - k + 1 => i; i < n + 1; ++i) {
      i *=> a;
    }

    1.0 => b;
    for (1 => i; i < k + 1; ++i) {
      i *=> b;
    }

    return a / b;
  }

  fun static float B(int n, int i, float t) {
    return newton(n, i) * Math.pow(t, i) * Math.pow(1.0 - t, n - i);
  }

  fun static Point singlePoint(Point points[], float t) {
    Point p;
    int n;

    points.cap() - 1
      => n;

    for (0 => int i; i < points.cap(); ++i) {
      points[i].x() * B(n, i, t) + p.x()
        => p.x;

      points[i].y() * B(n, i, t) + p.y()
        => p.y;
    }

    return p;
  }

  fun static Point[] theCurve(Point points[], int resolution) {
    // resolution + 1 so the curve end at the last constrol point
    Point curve[resolution + 1];
    float dt;

    1.0 / resolution
      => dt;

    for (0 => int i; i <= resolution; ++i) {
      singlePoint(points, i * dt)
         @=> curve[i];
    }

    return curve;
  }
}

