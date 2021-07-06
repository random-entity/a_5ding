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
    PVector mouseVector = new PVector(mouseX, mouseY);
    float D = PVector.dist(mouseVector, location);
    acceleration = mouseVector.sub(location).setMag(.7/D*D).add(PVector.random2D().mult(1));
    acceleration.limit(1.5);
    velocity.add(acceleration);
    location.add(velocity);
    velocity.limit(10);
  }

  void edges() {
    if (location.x > width)  velocity.x *= -1;
    if (location.x < 0)      velocity.x *= -1;
    if (location.y > height) velocity.y *= -1;
    if (location.y < 0)      velocity.y *= -1;
  }

  void display() {
    ellipse(location.x, location.y, 30, 30);
  }
}
