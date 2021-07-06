class Particle extends VerletParticle2D {

  Particle(Vec2D loc) {
    // Calling super() so that the object is initialized properly
    super(loc);
    physics.addParticle(this);
    physics.addBehavior(new AttractionBehavior2D(this, repulseR, repulseStrength));
  }


  // We want this to be just like a VerletParticle, only with a display() method.
  void display(color colIndiv) {
    noStroke();
    fill(colIndiv); // change to col after develop complete
    // We’ve inherited x and y from VerletParticle!
    ellipse(x, y, particleD, particleD);
  }
  
  void display(color colIndiv, float dx, float dy) {
    noStroke();
    fill(colIndiv); // change to col after develop complete
    // We’ve inherited x and y from VerletParticle!
    ellipse(x, y, dx, dy);
  }
  
}

class BowlBorderParticle extends VerletParticle2D {

  BowlBorderParticle(Vec2D loc) {
    // Calling super() so that the object is initialized properly
    super(loc);
    physics.addParticle(this);
    physics.addBehavior(new AttractionBehavior2D(this, repulseRangeBowl, repulseStrengthBowl));
  }

  // We want this to be just like a VerletParticle, only with a display() method.
  void display() {
    noStroke();
    fill(0, 0, 255); 
    // We’ve inherited x and y from VerletParticle!
    ellipse(x, y, 3, 3);
  }
  
} 

class BowlCore extends VerletParticle2D {

  BowlCore(Vec2D loc, float coreAttrRange, float coreAttrStrength) {
    // Calling super() so that the object is initialized properly
    super(loc);
    physics.addParticle(this);
    physics.addBehavior(new AttractionBehavior2D(this, coreAttrRange, coreAttrStrength));
  }

  // We want this to be just like a VerletParticle, only with a display() method.
  void display() {


    noStroke();
    fill(255, 0, 0); 
    // We’ve inherited x and y from VerletParticle!
    ellipse(x, y, 3, 3);
  }
}
