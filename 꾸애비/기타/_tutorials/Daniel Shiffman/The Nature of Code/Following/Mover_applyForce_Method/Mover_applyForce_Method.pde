Mover m;


void setup() {
  size(600, 400);
  noStroke();
  fill(0, 0, 255);
  m = new Mover();
}

void draw() {
  background(255);

  PVector gravity = new PVector(0, 0.2);
  PVector windForce = new PVector(0.2, 0);

  if (mousePressed) {
    m.applyForce(windForce);
  }

  m.applyForce(gravity);
  m.update();
  m.bounce();
  m.display();
}


class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;

  Mover() {
    location = new PVector(width/2, height/2);
    velocity = new PVector(0, 1);
    acceleration = new PVector(0, 0);
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }

  void bounce() {
    if (location.x > width)  velocity.x *= -1;
    if (location.x < 0)      velocity.x *= -1;
    if (location.y > height) velocity.y *= -1;
    if (location.y < 0)      velocity.y *= -1;
  }

  void display() {
    ellipse(location.x, location.y, 30, 30);
  }
}
