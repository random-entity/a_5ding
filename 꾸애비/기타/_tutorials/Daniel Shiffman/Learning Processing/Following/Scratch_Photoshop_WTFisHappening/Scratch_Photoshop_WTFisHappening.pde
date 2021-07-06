
PImage luda;

void setup() {
  luda = loadImage("luda2.png");
  size(278, 276);
}

void draw() {
  //image(luda, 0, 0);
  loadPixels();
  for (int x = 0; x < width-1; x++) {
    for (int y = 0; y < height; y++) {
      int loc = x + y * width;
      int loc_R = (x+1) + y * width;

      float br = brightness(luda.pixels[loc]);
      float br_R = brightness(luda.pixels[loc_R]);
      float diff = abs(br - br_R);
      if (diff > 20) {
        pixels[loc] = color(0);
      } else {
        pixels[loc] = color(255);
      }
      //BW-izer, Threshold = mouseX
      //if (br > mouseX) {
      //  pixels[loc] = color(255);
      //} else {
      //  pixels[loc] = color(0);
      //}

      //Color Distortion
      //float r = red(luda.pixels[loc]);      
      //float g = green(luda.pixels[loc]);      
      //float b = blue(luda.pixels[loc]);
      //float d = dist(x, y, mouseX, mouseY);
      //float f = map(d, 0, width, 2, 0);
      ////pixels[loc] = color(r*f+g-b, g*f+b-r, b*f+r-g);

      //WTF This is weird.
      //pixels[loc] = color(luda.pixels[loc])*int(100*f);
    }
  }
  updatePixels();
}
