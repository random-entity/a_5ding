class Player {
  float xpos, ypos, d;
  boolean isArrested = false, hasSurrendered = false;

  Player() {
    xpos = width/2;
    ypos = height - 20;
    d = globd;
  }

  void move(float x, float y) {
    xpos += x;
    ypos += y;
    if (xpos < 0) xpos = 0;
    if (xpos > width) xpos = width;
  }

  void checkArrested() {
    isArrested = false;
    for (Enemy e : enemies) {
      if ((hasSurrendered && dist(xpos, ypos, e.xpos, e.ypos) < e.d * 5) || (!hasSurrendered && dist(xpos, ypos, e.xpos, e.ypos) < e.d * 2)) {
        isArrested = true;
        d = globd/2;
        break;
      }
    }
  }

  void checkSurrendered() {
    if (dist(xpos, ypos, width/2, swordY) < 10) {
      hasSurrendered = true;
    }
  }

  boolean reachedTop() {
    boolean t = false;
    if (player.ypos < 30) t = true;
    return t;
  }

  void display() {
    fill(255);
    if (hasSurrendered) {      
      fill(255, 0, 0);      
      rect(xpos, ypos, 2, 10);
    } else if (!isArrested) {
      ellipse(xpos, ypos, 10, 10);
    } else {
      rect(xpos, ypos, 10, 10);
    }
  }

  void shoot() {
    bullets.add(new Bullet());
  }
}
