turtle[] yangsikjang = new turtle[10];

void setup() {
  size(500, 500);

  for (int i = 0; i < yangsikjang.length; i++) {
    yangsikjang[i] = new turtle(i, width / 2, i * 50);
  }
}

void draw() {
  background(0);

  for (int i = 0; i < yangsikjang.length; i++) {
    yangsikjang[i].display();
  }
}

void mousePressed() {
  for (int i = 0; i < yangsikjang.length; i++) {
    yangsikjang[i].eat(3);
  }
}
