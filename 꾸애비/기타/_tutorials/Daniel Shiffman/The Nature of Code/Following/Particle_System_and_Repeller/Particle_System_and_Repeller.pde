ParticleSystem ps = new ParticleSystem(new PVector(250, 480));
Repeller repeller;
PImage img; 
//Random generator;

void setup() {
  size(500, 500, P2D);
  noStroke();
  repeller = new Repeller(width/2, height/2);
  img = loadImage("aaa.png");
  //generator = new Random();
}

void draw() {
  blendMode(ADD); 
  background(0);

  PVector gravity = new PVector(0, -0.1);

  float dx = map(mouseX, 0, width, -0.2, 0.2);
  PVector wind = new PVector(dx, 0);

  ps.addParticle();
  ps.applyForce(gravity);
  ps.applyRepeller(repeller);
  ps.applyForce(wind);
  ps.run();
  repeller.display();
}

class Repeller {
  PVector location; 
  float r = 10; 

  Repeller(float x, float y) {
    location = new PVector(x, y);
  }

  PVector repel(Particle p) {
    PVector dir = PVector.sub(location, p.location);
    float d = dir.mag();
    dir.normalize();
    float force = -1 * 500 / (d * d);
    dir.mult(force);
    return dir;
  }

  void display() {
    fill(255, 0, 0); 
    ellipse(location.x, location.y, r*2, r*2);
  }
}


class ParticleSystem {

  ArrayList<Particle> particles; 
  PVector origin;

  ParticleSystem(PVector location) {
    origin = location; 
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    float r = random(1);
    if (r < .5) {
      particles.add(new Particle(origin));
    } else {
      particles.add(new Confetti(origin));
    }
  }

  void applyForce(PVector f) {
    for (Particle p : particles) {
      p.applyForce(f);
    }
  }

  void applyRepeller(Repeller r) {
    for (Particle p : particles) {
      PVector force = r.repel(p);
      p.applyForce(force);
    }
  }

  void run() {
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}


class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan = 255;
  float mass = random(1, 5);
  color c = color(random(255), random(100), random(100));

  Particle(PVector l) {
    acceleration = new PVector(0, 0.05);
    //float vx = (float) generator.nextGaussian() * .3;
    float vx = randomGaussian() * .3;
    float vy = randomGaussian() * .3 - 1;
    velocity = new PVector(vx, vy);

    location = l.get();
  }

  void run() {
    update();
    render();
  }

  void applyForce(PVector force) {
    PVector f = force.get(); 
    f.div(mass);
    acceleration.add(f);
  }


  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
    lifespan -= 2;
  }

  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    fill(lifespan);
    ellipse(location.x, location.y, 8, 8);
  }

  void render() {
    imageMode(CENTER); 
    tint(c, lifespan);
    image(img, location.x, location.y);
  }
}

class Confetti extends Particle {

  // We could add variables for only Confetti here.

  Confetti(PVector l) {
    super(l);
  }

  // There is no code here because we inherit update() from parent.


  //[full] Override the display method.
  void display() {
    float theta = map(location.x, 0, width, 0, TWO_PI*2);

    rectMode(CENTER);
    fill(0, lifespan);
    stroke(0, lifespan);
    //[full] If we rotate() a shape in Processing, we need to familiarize ourselves with transformations. For more, visit: http://processing.org/learning/transform2d/
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    rect(0, 0, 8, 8);
    popMatrix();
    //[end]
  }
  //[end]
}

class ShitConfetti extends Confetti {

  ShitConfetti(PVector l) {
    super(l);
  }
}
