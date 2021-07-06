class Vehicle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r; 
  float maxforce;
  float maxspeed;

  Vehicle(float x, float y) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, -2);
    position = new PVector(x, y);
    r = 6;
    maxspeed = 4;
    maxforce = 0.1;
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void seek(PVector target) {
    PVector desired = PVector.sub(target, position);
    desired.setMag(maxspeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }

  //void seek(PVector target, boolean b) {
  //  PVector desired = PVector.sub(target, position);
  //  desired.setMag(maxspeed);
  //  PVector steer = desired;
  //  steer.limit(maxforce);
  //  applyForce(steer);
  //}

  void arrive(PVector target) {
    PVector desired = PVector.sub(target, position);    
    float d = desired.mag();
    if (d > 100) {
      desired.setMag(maxspeed);
    } else {
      desired.setMag(map(d, 0, 100, 0, maxspeed));
    }
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }

  void display() {
    float theta = velocity.heading2D() + PI/2;
    fill(127);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
    popMatrix();
  }
}

Vehicle v;

void setup() {
  size(500, 500);
  v = new Vehicle(width/2, height/2);
}

void draw() {
  background(255);
  PVector mouse = new PVector(mouseX, mouseY);

  fill(200);
  stroke(0);
  strokeWeight(2);
  ellipse(mouse.x, mouse.y, 48, 48);

  //v.seek(mouse);
  //v.seek(mouse, true);
  v.arrive(mouse);
  v.update();
  v.display();
}
