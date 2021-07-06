class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  float diameter;

  Mover() {
    location = new PVector(random(width), height/2);
    velocity = new PVector(0, 1);
    acceleration = new PVector(0, 0);
    mass = random(1, 5);
    diameter = 20 * mass;
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
    if (location.x + diameter/2 > width) { 
      velocity.x *= -1; 
      location.x = width - int(diameter/2);
    }
    if (location.x - diameter/2 < 0) { 
      velocity.x *= -1; 
      location.x = int(diameter/2);
    }
    if (location.y + diameter/2 > height) 
    {
      velocity.y *= -1;
      location.y = height - int(diameter/2);
    }
    if (location.y - diameter/2 < 0) { 
      velocity.y *= -1;
      location.y = int(diameter/2);
    }
  }

  void display() {
    ellipse(location.x, location.y, diameter, diameter);
  }
}
