PImage img;
PVector criterionPoint;
PImage selectionImg;
PImage fluxImg;

int dimension;

color[][] imgColors;
color criterionColor;
ArrayList<PVector> selectedPixels;

int timer = 0;
int fluxInterval = 1;
float fluxX = 0.0;
float fluxY = 0.0;

void setup() {
  size(1200, 400);
  //frameRate(24);
  img = loadImage("rupi.jpg");
  selectionImg = loadImage("rupi.jpg");
  fluxImg = loadImage("rupi.jpg");

  img.loadPixels();
  selectionImg.loadPixels();
  fluxImg.loadPixels();

  dimension  = img.width * img.height;
  criterionPoint = new PVector(0, 0);
  imgColors = new color[img.width][img.height];
  selectedPixels = new ArrayList<PVector>();
  criterionColor = img.pixels[0];

  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      int loc = x + y * img.width;
      imgColors[x][y] = img.pixels[loc];
    }
  }
}

boolean colorDistanceLessThan(color c1, color c2, float threshold) {
  return dist(red(c1), blue(c1), green(c1), red(c2), blue(c2), green(c2)) < threshold;
}

void updateSelection(color criterionColor) {
  selectedPixels.clear();

  selectionImg = loadImage("rupi.jpg");

  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      if (colorDistanceLessThan(imgColors[x][y], criterionColor, 50)) {
        selectedPixels.add(new PVector(x, y));
        selectionImg.pixels[x + y * selectionImg.width] = color(0, 0, 255);
      }
    }
  }
  selectionImg.updatePixels();
}

void mouseClicked() {
  if (mouseX < img.width) {
    fluxX = 0;
    fluxY = 0;
    criterionPoint = new PVector(mouseX, mouseY);
    color criterionColor = img.pixels[mouseX + mouseY * img.width];
    updateSelection(criterionColor);
  }
}

void flux(int dx, int dy) {
  for (int i = selectedPixels.size() - 1; i >= 0; i--) {
    PVector v = selectedPixels.get(i);
    int x = (int) v.x;
    int y = (int) v.y;
    int newX = x + dx;
    int newY = y - dy;
    int loc = x + y * img.width;
    int newLoc = newX + newY * img.width;
    newLoc %= dimension;
    if (newLoc < 0) newLoc += dimension;
    fluxImg.pixels[newLoc] = img.pixels[loc];
  }
  fluxImg.updatePixels();
}

void draw()
{

  image(img, 0, 0);

  noFill();
  stroke(255, 0, 0);
  ellipse(criterionPoint.x, criterionPoint.y, 5, 5);

  image(selectionImg, img.width, 0);

  image(img, img.width * 2, 0);
  image(fluxImg, img.width * 2, 0);

  timer++;
  if (timer > fluxInterval) {
    timer = 0;
    fluxX += random(-1, 1.5);
    fluxY += random(-1.5, 1);
    flux((int)fluxX, (int)fluxY);
  }
}
