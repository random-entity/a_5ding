import processing.video.*;

Capture video;

color trackColor;
float threshold = 25;

void setup() {
  size(320, 240);
  video = new Capture(this, width, height);
  video.start();
  trackColor = color(0, 0, 0);
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  video.loadPixels();
  image(video, 0, 0);
  threshold = map(mouseX, 0, width, 0, 50);
  float avgX = 0;
  float avgY = 0;
  int count = 0;

  for (int x = 0; x < video.width; x++) {
    for (int y = 0; y < video.height; y++) {

      int loc = x + y * video.width;
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float b1 = blue(currentColor);
      float g1 = green(currentColor);
      float r2 = red(trackColor);
      float b2 = blue(trackColor);
      float g2 = green(trackColor);
      float d = dist(r1, g1, b1, r2, g2, b2);

      if (d < threshold) {
        stroke(255, 0, 0);
        strokeWeight(1);
        point(x, y);
        avgX += x;
        avgY += y;
        count++;
      }
    }
  }

  if (count > 0) {
    avgX /= count;   
    avgY /= count;
    fill(trackColor);
    strokeWeight(2); 
    stroke(0, 255, 0); 
    ellipse(avgX, avgY, 8, 8);
  }
}
