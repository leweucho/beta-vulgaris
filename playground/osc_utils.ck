"1,2,3.14" => string csv;
OSCUtils.atofa(csv) @=> float dataPoints[];

for(0 => int i; i < dataPoints.cap(); ++i) {
  <<< "[", i, "]", dataPoints[i] >>>;
}
