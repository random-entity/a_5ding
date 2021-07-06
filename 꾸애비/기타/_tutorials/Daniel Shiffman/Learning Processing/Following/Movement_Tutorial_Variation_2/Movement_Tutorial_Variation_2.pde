import processing.video.*;
Capture video;
PImage prevFrame;
float threshold = 50;
float motionX = 0, motionY = 0; 
float lerpX = 0, lerpY = 0;

void setup() {
  size(320, 240);
  video = new Capture(this, width, height, 30);
  video.start();
  prevFrame = createImage(video.width, video.height, RGB);
}

void captureEvent(Capture video) {
  prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
  prevFrame.updatePixels();
  video.read();
}

void draw() {
  loadPixels();
  video.loadPixels();
  prevFrame.loadPixels();
  float avgX = 0, avgY = 0;
  int count = 0;

  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {

      int loc = x + y * video.width;
      color current = video.pixels[loc];
      color previous = prevFrame.pixels[loc];

      float r1 = red(current); 
      float g1 = green(current); 
      float b1 = blue(current);
      float r2 = red(previous); 
      float g2 = green(previous); 
      float b2 = blue(previous);
      float diff = dist(r1, g1, b1, r2, g2, b2);

      if (diff > threshold) {
        avgX += x;
        avgY += y;
        count++;
        pixels[loc] = color(0);
      } else {
        pixels[loc] = color(255);
      }
    }
  }
  updatePixels();

  if (count > 200) {
    motionX = avgX / count; 
    motionY = avgY / count;
  }
  
  lerpX = lerp(lerpX, motionX, 0.1);  
  lerpY = lerp(lerpY, motionY, 0.1);
  fill(0, 255, 0); 
  strokeWeight(2); 
  stroke(0); 
  ellipse(lerpX, lerpY, 20, 20);
}
