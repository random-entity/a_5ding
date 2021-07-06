class Attractor {
  float mass;
  PVector location;
  float G;

  Attractor() {
    location = new PVector(300, 300);
    mass = 50;
    G = 0.4;
  }

  PVector attract(Mover m) {
    PVector force = PVector.sub(location, m.location);
    float distance = force.mag();
    distance = constrain(distance, 5., 25.);

    force.normalize();
    float strength = (G * mass * m.mass) / (distance * distance);
    force.mult(strength);
    return force;
  }

  void display() {
    noStroke();
    fill(255, 15, 15);
    ellipse(location.x, location.y, mass*2, mass*2);
  }
}
