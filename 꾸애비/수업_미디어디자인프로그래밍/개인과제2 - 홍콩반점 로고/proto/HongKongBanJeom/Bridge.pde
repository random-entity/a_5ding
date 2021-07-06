class Bridge {

  // Bridge properties
  float totalLength;  // How long
  int numPoints;      // How many points
  float initX;

  // Our chain is a list of particles
  ArrayList<Particle> particles;

  // Chain constructor
  Bridge(float l, int n, float x) {

    totalLength = l;
    numPoints = n;
    initX = x;

    particles = new ArrayList();

    float len = totalLength / numPoints;

    // Here is the real work, go through and add particles to the chain itself
    for (int i = 0; i < numPoints + 1; i++) {
      // Make a new particle
      Particle p = null;

      // First and last particles are made with density of zero
      if (i == 0) p = new Particle(initX, i * len, 4, true);
      else p = new Particle(initX, i * len, 4, false);
      particles.add(p);

      // Connect the particles with a distance joint
      if (i > 0) {
        DistanceJointDef djd = new DistanceJointDef();
        Particle previous = particles.get(i-1);
        // Connection between previous particle and this one
        djd.bodyA = previous.body;
        djd.bodyB = p.body;
        // Equilibrium length
        djd.length = box2d.scalarPixelsToWorld(len);
        // These properties affect how springy the joint is 
        djd.frequencyHz = 0;
        djd.dampingRatio = 0.2;

        // Make the joint.  Note we aren't storing a reference to the joint ourselves anywhere!
        // We might need to someday, but for now it's ok
        DistanceJoint dj = (DistanceJoint) box2d.world.createJoint(djd);
      }
    }
  }

  // Draw the bridge
  void display() {
    for (Particle p : particles) {
      p.display();
    }
  }
}
