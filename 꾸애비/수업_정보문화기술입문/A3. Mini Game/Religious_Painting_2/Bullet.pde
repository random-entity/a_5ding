class Bullet {

  float xpos, ypos; 
  int counter = 0;
  boolean done = false;

  Bullet() {
    xpos = player.xpos;
    ypos = player.ypos;
  }

  void move(float x, float y) {
    xpos += x;
    ypos += y;
  }

  void display() {
    ellipse(xpos, ypos, 2, 2);
  }
}
