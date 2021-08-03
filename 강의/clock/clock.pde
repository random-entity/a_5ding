float time = 0;

void setup() {
  size(500, 500);
  rectMode(CENTER);
}

void draw() {
  background(255);

  pushMatrix();

  stroke(255, 0, 0);
  noFill();
  rect(50, 0, 100, 20);

  translate(width/2, height/2);
  stroke(0);
  noFill();
  ellipse(0, 0, 300, 300);
  
  stroke(0, 0, 255);
  noFill();
  rect(50, 0, 100, 20);

  pushMatrix();
  rotate(radians(time));
  noStroke();
  fill(0, 255, 0);
  rect(50, 0, 100, 20);
  popMatrix();
  
  rotate(radians(time) * 4);
  fill(24, 69, 190);
  rect(70, 0, 140, 10);
  
  popMatrix();
  
  time++;
}