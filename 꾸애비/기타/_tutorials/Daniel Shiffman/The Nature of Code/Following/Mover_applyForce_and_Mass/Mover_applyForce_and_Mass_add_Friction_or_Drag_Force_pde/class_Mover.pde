class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  float diameter;
  color c;

  Mover() {

    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = random(1, 5);
    diameter = 20 * mass;
    location = new PVector(random(width), diameter);
    c = color(random(0, 255), random(0, 255), random(0, 255));
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }

  void bounce() {
    if (location.x + diameter/2 > width)  velocity.x *= -1;
    if (location.x - diameter/2 < 0)      velocity.x *= -1;
    if (location.y + diameter/2 > height) velocity.y *= -1;
    if (location.y - diameter/2 < 0)      velocity.y *= -1;
  }

  void display() {
    fill(c);
    ellipse(location.x, location.y, diameter, diameter);
  }
}
