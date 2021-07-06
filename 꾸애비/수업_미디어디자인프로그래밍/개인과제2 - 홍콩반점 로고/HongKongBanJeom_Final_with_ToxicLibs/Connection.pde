class Connection extends VerletSpring2D {

  boolean isDestroyed = false;

  Connection(Particle p1, Particle p2, float len, float strength) {
    super(p1, p2, len, strength);
    physics.addSpring(this);
  }


  boolean mouseTouchedConnection() {
    boolean shit = false;
    //for (int i = 0; i <= res; i++) {
    if (dist(mouseX, mouseY, lerp(a.x, b.x, .5), lerp(a.y, b.y, .5)) < 10) {
      shit = true;
      isDestroyed = true;
    }
    //}
    return shit;
  }

  void display(color colDesig) {

    if (!isDestroyed) {
      noStroke();
      fill(colDesig);

      PVector diff = new PVector(a.x-b.x, a.y-b.y);
      float arg = diff.heading();
      pushMatrix();
      translate((a.x+b.x)/2, (a.y+b.y)/2);
      rotate(arg);    
      rect(0, 0, diff.mag(), particleD);
      popMatrix();
    }
  }
}
