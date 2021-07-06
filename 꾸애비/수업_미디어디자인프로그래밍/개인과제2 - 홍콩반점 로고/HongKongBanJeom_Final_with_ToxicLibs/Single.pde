class Single {
  // Bridge properties
  float totalLength;  // How long
  int numPoints;      // How many points
  float initX;        // Where it hangs
  color colIndiv;

  ArrayList<Particle> particles;
  Particle[] particles_;
  ArrayList<Connection> springs;
  Connection[] springs_;
  Vec2D[] midpoints;
  int[] honghapSize; 

  Single(float l, int n, float x) {
    totalLength = l;
    numPoints = n;
    initX = x;
    particles = new ArrayList();
    particles_ = new Particle[numPoints];
    midpoints = new Vec2D[numPoints - 1];
    springs = new ArrayList();
    springs_ = new Connection[numPoints];
    honghapSize = new int[numPoints];

    float interval = totalLength/numPoints;
    float randBright = random(30);
    colIndiv = color(230-randBright, 230-randBright, 0);

    for (int i = 0; i <= numPoints - 1; i++) {
      //particles.add(new Particle(new Vec2D(initX, i * interval)));
      particles_[i] = new Particle(new Vec2D(initX, i * interval));

      honghapSize[i] = int(random(60, 90));
    }
    for (int i = 0; i <= numPoints - 2; i++) {
      //springs.add(new Connection(particles.get(i), particles.get(i+1), interval, springStrength));
      springs_[i] = new Connection(particles_[i], particles_[i+1], interval, springStrength);
    }
    //particles.get(0).lock();
    particles_[0].lock();
  }

  boolean ithParticleIsolated(int i) {
    if (i == 0) {
      return false;
    } else {
      boolean tempB = false;
      if (springs_[i-1].isDestroyed && springs_[i].isDestroyed) {
        tempB = true;
      }
      return tempB;
    }
  }

  void displayImage(PImage h, int x, int i) {
    int picker = i;
    Particle pickedParticleI = hongkong.matrix.get(picker).particles_[numPoints-1];
    Particle pickedParticleJ = hongkong.matrix.get(picker).particles_[numPoints-2];
    PVector diff = new PVector(pickedParticleI.x - pickedParticleJ.x, pickedParticleI.y - pickedParticleJ.y);
    float arg = diff.heading() + x; // adding x just for randomness!
    pushMatrix();
    translate(particles_[i].x, particles_[i].y);
    rotate(arg);    
    //rect(0, 0, diff.mag(), particleD);
    image(h, 0, 0, x, x*31/77);
    popMatrix();
  }

  void display() {
    //for (Particle p : particles) {
    //  p.display(colIndiv);
    //}
    for (int i = 0; i <= numPoints - 1; i++) {
      if (ithParticleIsolated(i)) {
        displayImage(honghap, honghapSize[i], i);
        //particles_[i].display(color(132, 33, 14), 15, 15); // isolated geondeogi color
      } else {
        particles_[i].display(colIndiv);
      }
    }
    //for (Connection c : springs) {
    //  c.display(colIndiv);
    //}
    for (int i = 0; i <= numPoints - 2; i++) {
      springs_[i].display(colIndiv);
    }
  }

  //void displayBezier() {
  //  for (int i = 0; i <= numPoints - 2; i++) {
  //    midpoints[i] = new Vec2D(particles_[i].getPreviousPosition().add(particles_[i+1].getPreviousPosition()).scale(0.5));
  //  }
  //  for (int i = 0; i <= numPoints - 3; i++) {
  //    stroke(colIndiv);
  //    strokeWeight(9);
  //    bezier(midpoints[i].x, midpoints[i].y, particles_[i+1].x, particles_[i+1].y, midpoints[i+1].x, midpoints[i+1].y, particles_[i+1].x, particles_[i+1].y);
  //  }
  //}

  boolean isCut() {
    boolean tempB = false;
    //for (Connection c : springs) {
    //  if (c.isDestroyed) tempB = true;
    //}
    //return tempB;

    for (int i = 0; i <= numPoints - 2; i++) {
      if (springs_[i].isDestroyed) tempB = true;
    }
    return tempB;
  }
}
