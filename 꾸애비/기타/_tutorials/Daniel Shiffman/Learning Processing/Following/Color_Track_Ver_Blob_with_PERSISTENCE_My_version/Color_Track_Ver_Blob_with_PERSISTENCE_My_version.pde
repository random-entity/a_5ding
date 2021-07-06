
//asdjkfnakwejanskjnjkjjnjnjnn@$#@#$@#$@#$@#$@#$@#$#@$

import processing.video.*;
Capture video;
color trackColor;
float colorThreshold = 10;
float distThreshold = 50;
ArrayList<Blob> tillNowBlobs = new ArrayList<Blob>();
int blobCounter = 0;

void setup() {
  size(640, 480);
  video = new Capture(this, width, height);
  video.start();
  trackColor = color(255);
}

void captureEvent(Capture video) {
  video.read();
}

void keyPressed() {
  if (keyPressed) {
    if (key == 'a') {
      distThreshold++;
    } else if (key == 'z') {
      distThreshold--;
    } else if (key == 's') {
      colorThreshold++;
    } else if (key == 'x') {
      colorThreshold--;
    }
  }
}

void draw() {
  image(video, 0, 0);
  video.loadPixels();
  ArrayList<Blob> currentBlobs = new ArrayList<Blob>();

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
        for (Blob b : currentBlobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            break;
          }
        }
        if (!found) {
          Blob b = new Blob(x, y);
          currentBlobs.add(b);
        }
      }
    }
  }

  // MATCH currentBlobs with tillNowBlobs!!!
  if (tillNowBlobs.isEmpty() && currentBlobs.isEmpty()) {
  } else if (tillNowBlobs.isEmpty() && (currentBlobs.size() > 0)) {
    for (Blob cb : currentBlobs) {
      cb.id = blobCounter;
      tillNowBlobs.add(cb);
      blobCounter++;
    }
  } else if (tillNowBlobs.size() <= currentBlobs.size()) {
    for (Blob cb : currentBlobs) {
      cb.taken = false;
    }

    for (Blob tb : tillNowBlobs) {
      float recordD = 10000;
      Blob matched = null;
      for (Blob cb : currentBlobs) {
        PVector centerTB = tb.getCenter();
        PVector centerCB = cb.getCenter();
        float d = PVector.dist(centerTB, centerCB);
        if (d < recordD) {
          recordD = d;
          matched = cb;
        }
      }
      if (matched != null) {
        matched.taken = true;
        tb.become(matched);
      }
    }

    for (Blob cb : currentBlobs) {
      if (!cb.taken) {
        cb.id = blobCounter;
        tillNowBlobs.add(cb);
        blobCounter++;
      }
    }
  } else if (tillNowBlobs.size() > currentBlobs.size()) {
    for (Blob tb : tillNowBlobs) {
      tb.taken = false;
    }

    for (Blob cb : currentBlobs) {
      float recordD = 10000;
      Blob matched = null;
      for (Blob tb : tillNowBlobs) {
        PVector centerTB = tb.getCenter();
        PVector centerCB = cb.getCenter();
        float d = PVector.dist(centerTB, centerCB);
        if (d < recordD && !tb.taken) {
          recordD = d;
          matched = tb;
        }
      }
      if (matched != null) {
        matched.taken = true;
        matched.become(cb);
      }
    }
    for (int i = tillNowBlobs.size() - 1; i >= 0; i--) {
      Blob b = tillNowBlobs.get(i);
      if (!b.taken) {
        tillNowBlobs.remove(i);
      }
    }
  }

  for (Blob b : currentBlobs) {
    b.show();
  }

  textAlign(RIGHT); 
  textSize(10); 
  fill(255); 
  text("distance Threshold = " + distThreshold, width - 5, 10); 
  text("color Threshold = " + colorThreshold, width - 5, 20);
}
