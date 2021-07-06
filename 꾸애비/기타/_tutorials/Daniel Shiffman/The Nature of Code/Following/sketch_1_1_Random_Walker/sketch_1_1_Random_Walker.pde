Walker w;

void setup() {
  size (600, 600);
  w = new Walker();
  background(255);
  stroke(0);
}

void draw() {
  w.step();
  w.render();
}

class Walker {
  int x = 0, y = 0;

  Walker() {
    x = width / 2;
    y = height / 2;
  }

  void step() {
    int choice = int(random(4));
    if (choice == 0) {
      x++;
    } else if (choice == 1) {
      x--;
    } else if (choice == 2) {
      y++;
    } else if (choice == 3) {
      y--;
    } else {
    }

    x = constrain(x, 0, width - 1);
    y = constrain(y, 0, height - 1);
  }

  void render() {
    point(x, y);
  }
}
