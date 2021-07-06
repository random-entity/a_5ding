
import processing.sound.*;

FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];
SinOsc[] output = new SinOsc[bands];

void setup() {
  size(512, 750);
  background(255);

  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);

  // start the Audio Input
  in.start();

  // patch the AudioIn
  fft.input(in);

  for (int i = 0; i < bands; i++) {
    output[i] = new SinOsc(this);
    output[i].freq(44100*i/bands);
    output[i].amp(0);
    output[i].play();
  }
}      

void draw() { 
  background(255);
  fill(127, 127, 0); 
  rect(0, 0, width, height/3);  
  fill(0, 127, 127); 
  rect(0, height/3, width, height/3);  
  fill(127, 0, 127); 
  rect(0, height*2/3, width, height/3);

  fft.analyze(spectrum);

  for (int i = 0; i < bands; i++) {
    // The result of the FFT is normalized
    // draw the line for frequency band i scaling it up by 5 to get more amplitude.
    line( i, height, i, height - spectrum[i]*height*5 );
    output[i].amp(spectrum[i]);
  }
}
