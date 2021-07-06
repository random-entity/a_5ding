
void setup() {
  size(800, 800);
  background(255, 0, 0);
}

int i = 0;

void draw() {

  println(frameCount);
  int F = frameCount % 70;
  stroke(F, 0, 4*F);
  line(i, 0, width, i);
  line(width-i, height, 0, height-i);
  i++;
}
