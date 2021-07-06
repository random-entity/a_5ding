class Enemy {
  float xpos, ypos, d, row = -1, column = -1;
  boolean isHit;

  Enemy(float x, float y, int i, int j) {
    xpos = x;
    ypos = y;
    d = globd;
    row = i;
    column = j;
  }

  Enemy(float x, float y) {
    xpos = x;
    ypos = y;
    d = globd;
  }

  void move(float x, float y) {
    xpos += x;
    ypos += y;
    //if(truthIsFound == false && ypos > height + 20) {
    //  ypos = height - 10;
    //}
  }

  boolean isHit() {
    boolean t = false;
    for (Bullet b : bullets) {
      if (dist(xpos, ypos, b.xpos, b.ypos) < d) {
        t = true;
        isHit = true;
      }
    }
    return t;
  }
  void display() {
    imageMode(CENTER);
    //image(img, xpos, ypos);
    rectMode(CENTER);
    fill(255);
    stroke(255, 0, 0);
    rect(xpos, ypos, d, d);
    //if (row == 0 && column == 0) {
    //  fill(255, 0, 0);
    //  rect(xpos, ypos, 50, 50);
    //}

    noStroke();
  }

  int getMinDistEnemInd(int n) {
    float r = 1000;
    int t = 0;
    for (int i = 0; i < n; i++) {
      float s = dist(xpos, ypos, enemies.get(i).xpos, enemies.get(i).ypos);
      if (s < r && s > 0) {
        r = s;
        t = i;
      }
    }
    return t;
  }
}
