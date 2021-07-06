void setup() {
  size(500, 500);
}

void draw() {
}

class Mover {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;

  float angle = 0;
  float aVelocity = 0;
  float aAcceleration = 0;

  void update() {
    //[full] Regular old-fashioned motion
    velocity.add(acceleration);
    location.add(velocity);
    //[end]

    //[full] Newfangled angular motion
    aVelocity += aAcceleration;
    angle += aVelocity;
    //[end]

    acceleration.mult(0);
  }

  void display() {
    stroke(0);
    fill(175, 200);
    rectMode(CENTER);
    // pushMatrix() and popMatrix() are necessary
    // so that the rotation of this shape doesn’t
    // affect the rest of our world.
    pushMatrix();

    // Set the origin at the shape’s location.
    translate(location.x, location.y);
    // Rotate by the angle.
    rotate(angle);
    rect(0, 0, mass*16, mass*16);
    popMatrix();
  }
}
