class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  float diameter;
  color c;

  Mover() {
    velocity = new PVector(random(0, 1), random(0, 1));
    acceleration = new PVector(0, 0);
    mass = random(1, 5);
    diameter = 10 * mass;
    location = new PVector(random(width*0.25, width*0.75), random(height*0.25, height*0.75));
    c = color(random(0, 255), random(0, 255), random(0, 255));
  }

  void applyForce(PVector force) {
    PVector a = PVector.div(force, mass);
    acceleration.add(a);
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
