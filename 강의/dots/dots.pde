int numDotsX = 10;
dot[] dotGrid = new dot[numDotsX * numDotsX];

void setup() {
  size(500, 500);

  for (int i = 0; i < dotGrid.length; i++) {
    float x = i % 10;
    float y = i / 10;
    dotGrid[i] = new dot(50 * x, 50 * y);
  }
}

void draw() {
  background(0);

  for (int i = 0; i < dotGrid.length; i++) {
    dotGrid[i].move();
    dotGrid[i].display();
  }
}
