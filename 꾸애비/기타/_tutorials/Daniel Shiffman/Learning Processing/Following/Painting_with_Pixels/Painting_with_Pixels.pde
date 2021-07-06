
PImage luda;

void setup() {
  luda = loadImage("Luda.jpg");
  size(601, 720);
  background(0);
  noStroke();
}

void draw() {
  // image(luda, 0, 0);
  for (int i = 0; i < 2000; i++) {
    int x = int(random(width));
    int y = int(random(height));
    int index = x + y * width;
    color c = luda.pixels[index];
    fill(c, 25);
    ellipse(x, y, 10, 10);
  }
}
