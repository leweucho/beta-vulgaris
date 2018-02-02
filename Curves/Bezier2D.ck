/*
  --- MIT License --------------------------------------------------------------
  Copyright (c) 2018 Lewe Ucho

  ------------------------------------------------------------------------------

  BEZIER2D
  // documentation goes here

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

