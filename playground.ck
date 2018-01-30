Shaker s => dac;

me.dir() + me.arg(0) =>
  s.read;

2::second => now;

for (0 => int i; i < 5; i++) {
  s.shake();
  2::second => now;
}

