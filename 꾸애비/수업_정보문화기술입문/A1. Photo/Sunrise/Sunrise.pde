
void setup() {
  size(800, 800);
  background(255, 75, 0);
  for (int d = 1; d < width * sqrt(2); d += 1) {
    float r = d/(width * sqrt(2));
    stroke(255-r*100, 25+r*125, random(0, 100));
    noFill();
    ellipse(width/2, height/2, d*random(.8, 1.2), d*random(.8, 1.2));
  }

  for (int i = 0; i < 800; i++) {
    int r = i % 70;
    stroke(r, 0, 4*r);
    line(i, 0, width, i);
    line(width-i, height, 0, height-i);
  }

  noLoop();
}

void draw() {
}
