class Attractor {
  int number;
  float xf, yf, t;
  PVector loc;
  Vec2D locv;
  Node node;
  float springLength;
  Cluster cn;
  float seed, speed;
  int or;

  Attractor(int n) {
    number = n;
    float x = int(random(width));
    float y = int(random(height));
    loc = new PVector(x, y);
    locv = new Vec2D(x, y);
    node = new Node(locv);
    seed = random(1, 20);
    t = seed;
    speed = seed/10000;
    or = int(random(2));

    // Connect this Attractor to all nodes in cluster No.[number]
    cn = (Cluster) clusters.get(number);
    springLength = cn.diameter;
    for (int i = 0; i < cn.nodes.size(); i++) {
      VerletParticle2D pa = (VerletParticle2D) cn.nodes.get(i);
      VerletParticle2D pb = node;
      // A Spring needs two particles, a resting length, and a strength
      physics.addSpring(new VerletSpring2D(pa, pb, springLength, 0.01));
    }
  }

  void update() {
    t += speed;
    xf = noise(t);
    yf = noise(t+seed/5);
    loc.x = map(xf, 0, 1, -0.2*width, 1.2*width);
    loc.y = map(yf, 0, 1, -0.2*height, 1.2*height);
    locv.x = map(xf, 0, 1, -0.2*width, 1.2*width);
    locv.y = map(yf, 0, 1, -0.2*height, 1.2*height);
    node.x = locv.x;
    node.y = locv.y;
  }

  void display() {
    //fill(128, 0, 0);
    //rect(locv.x, locv.y, 5, 5);
    
    imageMode(CENTER);
    if (/*or == 0 || */number == 19) {
      pushMatrix(); 
      translate(locv.x, locv.y);
      image(soccerball, 0, 0, 20, 20);
      popMatrix();
    } 
    if (number == 0) {
      image(puppy, locv.x, locv.y, 50, 50*640/960);
    }

    // DEBUG start 
    //fill(0);
    //text(number, loc.x, loc.y);
    // DEBUG end
  }
}
