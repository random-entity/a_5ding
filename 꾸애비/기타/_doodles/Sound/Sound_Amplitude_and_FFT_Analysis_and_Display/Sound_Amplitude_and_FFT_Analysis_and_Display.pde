import processing.sound.*;

AudioIn in;
Amplitude amp;

FFT fft; 
int bands = 512;
float[] spectrum = new float[bands];

void setup() {
  size(512, 512);

  in = new AudioIn(this, 0);
  amp = new Amplitude(this);

  in.start();
  amp.input(in);

  Sound s = new Sound(this);
  s.inputDevice(1);

  fft = new FFT(this, bands);
  fft.input(in);
}

void draw() {
  float v = amp.analyze();

  background(0, 255, 0);
  noStroke();
  fill(255, 0, 0);
  ellipse(width/2, 0, 1000*v, 1000*v);

  println(v);
  stroke(0, 0, 255);
  fft.analyze(spectrum);
  for (int i = 0; i < bands; i++) {
    line(i, height, i, height - spectrum[i]*height*5);
  }
}
