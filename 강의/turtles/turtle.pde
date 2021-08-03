class turtle {
  // fields
  float x, y;
  float weight;

  // constructor
  turtle(float initialWeight, float initX, float initY) {
    weight = initialWeight;
    x = initX;
    y = initY;
  }

  // methods
  void eat(float foodWeight) {
    weight += foodWeight;
  }

  void display() {
    ellipse(x, y, weight * 3, 20);
  }
}
