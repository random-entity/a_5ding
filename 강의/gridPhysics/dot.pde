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

  void addGravity(float G, float minRange) {
    float dirX = mouseX - x;
    float dirY = mouseY - y;
    float dist = sqrt(dirX * dirX + dirY * dirY);

    if (dist > minRange) {
      float gravMag = G / max(epsilon, pow(dist, pow));

      ax += gravMag * dirX / dist;
      ay += gravMag * dirY / dist;
    }
  }

  void addElastic() {
    float dirX = initX - x;
    float dirY = initY - y;
    float dist = sqrt(dirX * dirX + dirY * dirY);

    ax += k * dirX;
    ay += k * dirY;
  }

  void addDrag() {
    ax -= d * vx;
    ay -= d * vy;
  }

  void runPhysics() {
    ax = 0;
    ay = 0;

    addDrag();

    addGravity(G, 16);

    addElastic();

    vx += ax;
    vy += ay;

    x += vx;
    y += vy;
  }

  void display() {
    fill(col);
    noStroke();
    rectMode(CENTER);
    ellipse(x, y, r, r);
  }
}
