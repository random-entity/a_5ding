class FireControlSystem {
  FireParticleSystem fps;
  PVector gravity;
  PVector wind;
  float maxGravity;
  float maxWind;

  FireControlSystem(PVector loc) {
    fps = new FireParticleSystem(loc);
    maxGravity = -0.75;
    maxWind = 1;
  }

  void runFire() {
    this.setGravity();
    this.setWind();
    this.addParticleByProgRate();
    fps.applyForce(gravity);
    fps.applyForce(wind);
    fps.run();
  }

  void setGravity() {
    float pr = map(sq(progRate), 0, 1, 0, maxGravity);
    gravity = new PVector(0, pr);
  }

  void setWind() {
    float r = random(1);
    if (r < 0.5) {  // change wind direction probability
      float w = progRate * maxWind;
      wind = new PVector(random(-w, w), 0);
    }
  }

  void addParticleByProgRate() {
    float r = random(1);
    if (r < progRate/*map(progRate, 0, 1, 0, 1)*/) { // probability of adding particle proportionate to progRate
      fps.addFireParticle();
    }
  }
}

class FireParticleSystem {

  ArrayList<FireParticle> FireParticles; 
  PVector origin;

  FireParticleSystem(PVector location) {
    origin = location; 
    FireParticles = new ArrayList<FireParticle>();
  }

  void addFireParticle() {
    PVector locOffset = new PVector(random(-80, 80), 0); // Spread fire particle origin horizontally
    PVector modLoc = PVector.add(origin, locOffset);
    FireParticles.add(new FireParticle(modLoc));
  }

  void applyForce(PVector f) {
    for (FireParticle p : FireParticles) {
      p.applyForce(f);
    }
  }

  void run() {
    for (int i = FireParticles.size() - 1; i >= 0; i--) {
      FireParticle p = FireParticles.get(i);
      p.run();
      if (p.isDead()) {
        FireParticles.remove(i);
      }
    }
  }
}

class FireParticle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan = 255;
  float mass = random(1, 5);
  color c = color(200, random(15), random(15));

  FireParticle(PVector l) {
    acceleration = new PVector(0, 0.05);
    //float vx = (float) generator.nextGaussian() * .3;
    float vx = randomGaussian() * .3;
    float vy = randomGaussian() * .3 - 1;
    velocity = new PVector(vx, vy);

    location = l.get();
  }

  void run() {
    update();
    //display();
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
    lifespan -= 5;
  }

  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }

  //void display() {
  //  fill(lifespan);
  //  ellipse(location.x, location.y, 128, 128);
  //}

  void render() {
    blendMode(ADD);
    imageMode(CENTER); 
    float alpha = 255*(1 - sq(lifespan/255 - 1));
    tint(c, alpha/2);
    image(img, location.x, location.y + bowlImg.height*1.1 - bowl.bowlAlt, 128, 128);
    blendMode(BLEND);
  }
}
