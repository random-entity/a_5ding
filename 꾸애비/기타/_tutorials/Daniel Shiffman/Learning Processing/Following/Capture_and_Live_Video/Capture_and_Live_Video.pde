import processing.video.*;

PImage luda;

Capture video;

void setup() {
  size(564, 800);
  luda = loadImage("Luda1.jpg");
  video = new Capture(this, 640, 480, 6);
  video.start();
}

void mousePressed() {
  video.read();
}

void captureEvent(Capture video) {
}

void draw() {
  //if (video.available()) {
  //  video.read();
  //}
  background(0);
  tint(255, mouseX, mouseY);
  image(video, 0, 0, mouseX, mouseY);
}
