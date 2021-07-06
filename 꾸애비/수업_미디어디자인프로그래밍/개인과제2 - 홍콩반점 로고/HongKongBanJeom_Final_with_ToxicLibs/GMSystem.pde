class GMControlSystem extends FireControlSystem { //GM = GukMul
  //float threshold;

  GMControlSystem(PVector loc) {
    super(loc);
    fps = new GMParticleSystem(loc);
    maxGravity = 5;
    maxWind = 0.01;
    //threshold = 0.5;
  }

  void addParticleByProgRate() {
    float r = random(1);
    if (r < 2*progRate-1+0.5/*map(progRate, 0, 1, 0, 1)*/) { // probability of adding particle proportionate to progRate
      fps.addFireParticle();
      fps.addFireParticle();
      fps.addFireParticle();
      fps.addFireParticle();
      fps.addFireParticle();
    }
  }
}


class GMParticleSystem extends FireParticleSystem {
  ArrayList<GMParticle> GMParticles;

  GMParticleSystem(PVector loc) {
    super(loc);
    GMParticles = new ArrayList<GMParticle>();
  }

  void addFireParticle() {
    PVector locOffset = new PVector(0, 0);//(random(0), 0); // Spread fire particle origin horizontally
    PVector modLoc = PVector.add(origin, locOffset);
    GMParticles.add(new GMParticle(modLoc));
  }

  void applyForce(PVector f) {
    for (GMParticle p : GMParticles) {
      p.applyForce(f);
    }
  }

  void run() {
    for (int i = GMParticles.size() - 1; i >= 0; i--) {
      GMParticle p = GMParticles.get(i);
      p.run();
      if (p.isDead()) {
        GMParticles.remove(i);
      }
    }
  }
}

class GMParticle extends FireParticle {
  float nowX = 0; 
  float nowX_ = 0;

  GMParticle(PVector l) {
    super(l);
    c = color(255, 255, 255);
  }

  void render() {
    imageMode(CENTER); 
    //float alpha = 255*(1 - sq(lifespan/255 - 1));

    // for LERP Calc
    float p = progRate;
    float destX = logoRadius*p*1.3;

    if (p < 0.5) {
      nowX = 0; 
      nowX_ = 0;
    } else if (p != 1) {
      nowX = lerp(nowX, destX, 0.1);
      nowX_ = nowX;
    } else {
      nowX = lerp(nowX, destX, 0.1);
      nowX_ = lerp(nowX_, 0, 0.1);
    }   


    //blendMode(MULTIPLY);
    //fill(0);
    //ellipse(gmcsLoc.x, gmcsLoc.y + nowX/2, nowX * 1.1, nowX * 1.1);

    blendMode(ADD);
    tint(128, 0, 0, 50);
    image(img, location.x, location.y + nowX/2, nowX_, nowX_);

    blendMode(BLEND);
    tint(255);
    image(Logo, gmcsLoc.x, gmcsLoc.y + nowX/2, nowX * 1.1, nowX * 1.1);

    blendMode(BLEND);
  }
}
