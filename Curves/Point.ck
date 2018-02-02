/*
  --- MIT License --------------------------------------------------------------
  Copyright (c) 2018 Lewe Ucho

  ------------------------------------------------------------------------------

  POINT
  A simple abstraction of a geometrical 2D point to be used by curve generators.
*/

public class Point {
  float _x;
  float _y;

  {
    0.0 => _x;
    0.0 => _y;
  }

  fun float x() {
    return _x;
  }

  fun float x(float newX) {
    newX => _x;
    return _x;
  }

  fun float y() {
    return _y;
  }

  fun float y(float newY) {
    newY => _y;
    return _y;
  }

  fun string toString() {
    return Std.ftoa(_x, 2) + " :: " + Std.ftoa(_y, 2);
  }
}

