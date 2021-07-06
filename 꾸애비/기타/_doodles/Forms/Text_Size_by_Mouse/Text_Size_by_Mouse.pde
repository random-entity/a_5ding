int mx, my;
PFont f;
void setup() {
  size(500, 500);
  f = createFont("Georgia", 40);
}

void draw() {
  background(255);
  mx = mouseX; 
  my = mouseY;
  textAlign(CENTER);
  fill(0);
  textSize(my);
  text("A", width/2, height/3);
  textSize(height - my);
  text("B", width/2, height*2/3);
}
