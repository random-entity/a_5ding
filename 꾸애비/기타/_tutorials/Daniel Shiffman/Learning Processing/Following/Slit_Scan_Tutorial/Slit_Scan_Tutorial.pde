//import processing.video.*;
//  Capture myCap;
//  int X=0;
//  void setup() {
//    myCap = new Capture(this, 320, 240);
//    myCap.start();  
//    size(600, 240);
//  }
//  void draw() {
//    if (myCap.available()) {
//      myCap.read();
//      myCap.loadPixels();
//      copy(myCap, (myCap.width/2), 0, 1, myCap.height, (X++%width), 0, 1, height);
//    }
//  }

import processing.video.*;

Capture video;

void setup() {
  size(1280, 480);
  video = new Capture(this, 640, 480);
  video.start();
}

void captureEvent (Capture video) {
  video.read();
}

int i = 0;

void draw() {
  //image(video, 0, 0);
  int w =  video.width;
  int h =  video.height;
  copy(video, w/2, 0, 1, h, i, 0, 1, h);
  i++;
  if (i > width) {
    i = 0;
  }
}
