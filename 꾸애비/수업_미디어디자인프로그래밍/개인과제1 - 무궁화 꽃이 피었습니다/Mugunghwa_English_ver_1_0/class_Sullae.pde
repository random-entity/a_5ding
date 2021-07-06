class Sullae {

  int x, y;

  Sullae() {
    x = width; 
    y = height/2;
  }

  void update() {
    x = mouseX;
    y = mouseY;
  }

  boolean isLookingBack() {
    if ((x < endingX) && (x > startingX)) return true;
    else return false;
  }

  void display() {
    fill(255, 0, 0);
    ellipse(x, y, 3, 3);
  }
}
