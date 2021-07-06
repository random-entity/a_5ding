Mover m;

void setup() {
  size(600, 400);
  noStroke();
  fill(0, 0, 255);
  m = new Mover();
}

void draw() {
  background(255);
  m.update();
  m.edges();
  m.display();
}

class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;

  Mover() {
    location = new PVector(width/2, height/2);
    velocity = new PVector(2, 5);
    acceleration = new PVector(0, 0);
  }

  void update() {
    acceleration = PVector.random2D().mult(1);
    velocity.add(acceleration);
    location.add(velocity);
    velocity.limit(10);
  }

  void edges() {
    if (location.x > width)  location.x = 0;
    if (location.x < 0)      location.x = width;
    if (location.y > height) location.y = 0;
    if (location.y < 0)      location.y = height;
  }

  void display() {
    ellipse(location.x, location.y, 30, 30);
  }
}
