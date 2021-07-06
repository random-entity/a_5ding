Mover[] movers;

void setup() {
  size(600, 400);
  noStroke();
  fill(0, 0, 255);
  movers = new Mover[5];
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover();
  }
}

void draw() {
  background(255);
  // PVector windForce = new PVector(0.2, 0);

  for (Mover m : movers) {
    if (mousePressed) {
      // m.applyForce(windForce);

      //PVector friction = m.velocity.get();
      //friction.normalize();
      //float mu = -0.1;
      //friction.mult(mu);
      //m.applyForce(friction);

      PVector dragForce = m.velocity.copy();
      dragForce.normalize();
      float Cd = -0.03;
      float speed = m.velocity.mag();
      dragForce.mult(Cd * speed * speed);
      m.applyForce(dragForce);
    }
    PVector gravity = new PVector(0, 0.2);
    gravity.mult(m.mass);
    m.applyForce(gravity);
    m.update();
    m.bounce();
    m.display();
  }
}
