PImage girl3;

void setup() {
  size(1000, 800);
  girl3 = loadImage("miss3.jpg");
}

void draw() {
  background(0);
  tint(mouseX,mouseY,0);
  imageMode(CENTER);
  image(girl3, mouseX, mouseY, mouseY, mouseX);
}
