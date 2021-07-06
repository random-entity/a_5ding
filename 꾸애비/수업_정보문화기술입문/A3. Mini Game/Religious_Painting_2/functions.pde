void reset() {
  player = new Player();
  enemies = new ArrayList<Enemy>();
  for (int i = -3; i <= 3; i++) {
    for (int j = -2; j <= 2; j++) {
      enemies.add(new Enemy(i*xint + xoff, -j*yint + yoff, i, j));
    }
  }
  bullets = new ArrayList<Bullet>();
  truthIsFound = false;
  reachedWall = false;
}

void showIntro() {
  background(0);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(30);
  text("religious\npainting#2", width/2, height*0.33);
  rectMode(CENTER);
  rect(width/2, height*0.66, width/3, 30);
  textSize(7.5);
  fill(0);
  text("click to start", width/2, height*0.66);
  if (mousePressed && abs(mouseX - width/2) < width/6 && abs(mouseY - height*0.66) < 15 ) {
    isIntro = false;
  }
}

float getMaxY(int n) { //0~n-1까지 중에 
  float r = -1000;
  for (int i = 0; i < n; i++) {
    if (enemies.get(i).ypos > r) r = enemies.get(i).ypos;
  }
  return r;
}
float getMinY(int n) { //0~n-1까지 중에 
  float r = 1000;
  for (int i = 0; i < n; i++) {
    if (enemies.get(i).ypos < r) r = enemies.get(i).ypos;
  }
  return r;
}

void moveNewBulletEnemies() {
  for (int i = 35; i < enemies.size(); i++) {
    int m = enemies.get(i).getMinDistEnemInd(35);
    float dx = (enemies.get(m).xpos - enemies.get(i).xpos)/5;
    float dy = (enemies.get(m).ypos - enemies.get(i).ypos)/5;
    if (abs(dx) > 5 || abs(dy) > 5) {
      enemies.get(i).move(dx, dy);
    }
  }
}
