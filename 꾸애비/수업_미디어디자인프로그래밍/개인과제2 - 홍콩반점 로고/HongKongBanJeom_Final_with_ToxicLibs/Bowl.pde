class Bowl {

  BowlBorderParticle[] particlesBorderLeft;
  BowlBorderParticle[] particlesBorderRight;
  float topY, bottomY, topWidth;
  float topYA, topWidthA; // where the noodles settle
  int bowlRes;
  float bowlAlt;

  BowlCore[] cores;

  Bowl(float ty, float by, float tw, int br, float tya, float twa) {
    topY = ty;
    bottomY = by; 
    topWidth = tw;
    bowlRes = br;
    topYA = tya;
    topWidthA = twa;

    bowlAlt = 0;

    particlesBorderLeft = new BowlBorderParticle[bowlRes];
    particlesBorderRight = new BowlBorderParticle[bowlRes];
    cores = new BowlCore[5];

    Vec2D[] u = new Vec2D[bowlRes];
    Vec2D[] v = new Vec2D[bowlRes];
    Vec2D[] w = new Vec2D[5];

    for (int i = 0; i < bowlRes; i++) {
      float c = float(i)/(bowlRes-1);
      u[i] = new Vec2D(lerp(width/2-topWidth/2, width/2, c), lerp(topY, bottomY, c));
      v[i] = new Vec2D(lerp(width/2+topWidth/2, width/2, c), lerp(topY, bottomY, c));
      particlesBorderLeft[i] = new BowlBorderParticle(u[i]);
      particlesBorderRight[i] = new BowlBorderParticle(v[i]);

      particlesBorderLeft[i].lock();
      particlesBorderRight[i].lock();
      //println(i); 
      //println(c);
      //println(lerp(width/2-topWidth/2, width/2, c));
    }

    for (int i = 0; i < 5; i++) {
      float x = lerp(width/2-topWidthA/2.5, width/2+topWidthA/2.5, float(i)/4.0);
      float y = topYA - 45*(1-0.5*abs(i-2)) + 30; // mountain form
      w[i] = new Vec2D(x, y);
      cores[i] = new BowlCore(w[i], topWidthA/2, coreAttrStr);
      cores[i].lock();
      //println(i);
      //println(w[i]);
    }
  }

  void updateAlt() {
    float destAlt = progRate * bowlImg.height;
    bowlAlt = lerp(bowlAlt, destAlt, 0.1);
  }

  void display() {

    fill(backgrCol);
    rect(width/2, height + bowlImg.height/2 - bowlAlt, width, bowlImg.height);

    imageMode(CENTER);
    blendMode(BLEND);

    image(bowlImg, width/2, height + bowlImg.height/2 - bowlAlt, 1.1 * bowlImg.width, bowlImg.height);

    // For monitoring the Core Attractors and Border Repellers
    //for (int i = 0; i < bowlRes; i++) {
    //  particlesBorderLeft[i].display();
    //  particlesBorderRight[i].display();
    //}    
    //for (int i = 0; i < 5; i++) {
    //  cores[i].display();
    //}
  }
}
