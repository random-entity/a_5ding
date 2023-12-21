class dot {
  float initX, initY;
  float x, y;
  float ax, ay;
  float vx, vy;
  float r = resolution;
  color col;

  dot(float x, float y, color col) {
    this.x = initX = x;
    this.y = initY = y;
    this.col = col;
  }

  void runPhysics() {
    //ax = 0;
    //ay = 0;

    vx += ax;
    vy += ay;

    x += vx;
    y += vy;
  }

  void display() {
    fill(col);
    noStroke();
    ellipse(x, y, r, r);
  }
}
