class frog {
  // fields
  float weight;
  float x, y;
  color col;

  // constructor method
  frog(float _weight, float _x, float _y, color _col) {
    weight = _weight;
    x = _x;
    y = _y;
    col = _col;
  }

  // methods
  void eat() {
    weight += 1;
  }

  void display() {
    fill(col);
    ellipse(x, y, weight * 10, weight * 10);
  }
}

frog[] manyPepes;
int time = 0;
int[] blendModes = {BLEND, ADD, LIGHTEST, DIFFERENCE, EXCLUSION, SCREEN};
int currentBlendModeIndex = 0;

void setup() {
  size(512, 512);
  frameRate(60);
  
  manyPepes = new frog[128];
  for (int i = 0; i < manyPepes.length; i++) {
    manyPepes[i] = new frog(5, i * 4, map(sin(map(i, 0, manyPepes.length, 0, TWO_PI)), -1, 1, 0, height), color(i * 2, 255 - i * 2, random(64)));
  }
}

void draw() {
  background(0);

  for (int i = 0; i < manyPepes.length; i++) {
    frog pepeI = manyPepes[i]; // reference caching (good practice)
    color originalColor = pepeI.col;
    float originalRed = red(originalColor);
    float originalBlue = blue(originalColor);
    float newRed = (originalRed + random(6)) % 256;
    float newBlue = originalBlue - random(3);
    if (newBlue < 0) newBlue += 256;
    pepeI.col = color(newRed, 255, newBlue);
    pepeI.y = map(sin(map(i + time, 0, manyPepes.length, 0, TWO_PI)), -1, 1, 0, height);

    pepeI.display();
  }

  time++;
}

void mousePressed() {
  if (mouseButton == LEFT)
  {
    for (int i = 0; i < manyPepes.length; i++) {
      manyPepes[i].eat();
    }
  } else if (mouseButton == RIGHT) {
    currentBlendModeIndex = (currentBlendModeIndex + 1) % blendModes.length;
    blendMode(blendModes[currentBlendModeIndex]);
  }
}