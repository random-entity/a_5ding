import processing.video.*;
Capture video;
color trackColor;
float colorThreshold = 10;
ArrayList<Blob> blobs = new ArrayList<Blob>();

void setup() {
  size(320, 240);
  video = new Capture(this, width, height);
  video.start();
  trackColor = color(255);
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  video.loadPixels();
  image(video, 0, 0);

  blobs.clear();

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

      if (d < colorThreshold) {
        boolean found = false;
        for (Blob b : blobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            break;
          }
        }
        if (!found) {
          Blob b = new Blob(x, y);
          blobs.add(b);
        }
      }
    }
  }

  for (Blob b : blobs) {
    b.show();
  }
}
