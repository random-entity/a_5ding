Mover[] movers = new Mover[5]; 
Attractor a = new Attractor();

void setup() {
  size(600, 600); 
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new Mover();
  }
}

void draw() {
  background(255);
  a.display();

  for (Mover m : movers) {
    PVector gravForce = a.attract(m);
    m.applyForce(gravForce);
    m.update();
    m.bounce();
    m.display();
  }
}
