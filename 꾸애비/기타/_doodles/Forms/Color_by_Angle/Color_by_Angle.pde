int d = 200;
PVector mouseV;
PVector i = new PVector(1, 0);

void setup() {
  size(500, 500); 
  background(255);
}

void draw() {
  translate(width/2, height/2);
  mouseV = new PVector(mouseX - width/2, mouseY - height/2);

  float arg = PVector.angleBetween(mouseV, i);
  //map(mouseX, 0, width, 0, 2*PI);
  //atan((mouseX - width/2)/(mouseY - height/2));
  if (mouseY < height/2) {
    arg = 2*PI - arg;
  }

  for (int i = 0; i < 1000; i++) {
    float theta;
    color c;
    theta = map(i, 0, 1000, 0, 2*PI);
    c = color(map(theta, 0, 2*PI, 0, 255), 0, map(theta, 0, 2*PI, 255, 0));
    noStroke();
    fill(c);
    ellipse(d*cos(theta + arg), d*sin(theta + arg), 10, 10);
  }
}
