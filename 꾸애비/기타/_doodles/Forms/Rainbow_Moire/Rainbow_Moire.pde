void setup() { //<>//
  size(800, 800);
  background(0);
}

void draw() {
  loadPixels(); 
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      float d = dist(i, j, mouseX, mouseY);
      int index = i + j*width;
      pixels[index] = color(255*(1+sin(d/8))/2, i/2+random(-10, 10), j/2+random(-10, 10));
    }
  }
  updatePixels();
}
