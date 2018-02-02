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
