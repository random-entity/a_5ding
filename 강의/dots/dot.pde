class dot {
  float x, y, r, vel;

  dot(float initX, float initY) {
    x = initX;
    y = initY;
    r = 5;
    vel = 1;
  }

  void move() {
    float dirX = x - mouseX;
    float dirY = y - mouseY;

    float distance = sqrt(dirX * dirX + dirY * dirY);

    dirX *= vel / distance;
    dirY *= vel / distance;

//    if (distance > 150) {
//      dirX *= -0.05;
//      dirY *= -0.05;
//    }

    x += dirX;
    y += dirY;
  }

  void display() {
    noStroke();
    fill(255);
    ellipse(x, y, 2 * r, 2 * r);
  }
}
