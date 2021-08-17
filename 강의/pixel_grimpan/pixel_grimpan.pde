int pixelSize = 10;
int lengthX;
int lengthY;  
pixel[][] grid;

color[] palette;
color currentColor;

void setup() {
  size(600, 400);

  noStroke();

  lengthX = width / pixelSize;
  lengthY = height / pixelSize;

  palette = new color[3];
  palette[0] = color(255, 0, 0);
  palette[1] = color(0, 255, 0);
  palette[2] = color(0, 0, 255);

  currentColor = palette[0];

  grid = new pixel[lengthX][lengthY];

  for (int i = 0; i < lengthX; i++) {
    for (int j = 0; j < lengthY; j++) {
      grid[i][j] = new pixel(i * pixelSize, j * pixelSize, color(255));
    }
  }
}

color getRandomColor() {
  return color(random(255), random(255), random(255));
}

void draw() {
  for (int i = 0; i < lengthX; i++) {
    for (int j = 0; j < lengthY; j++) {
      grid[i][j].display();
    }
  }
}

void mouseDragged() {
  int i = mouseX / pixelSize;
  int j = mouseY / pixelSize;

  i = constrain(i, 0, lengthX - 1);
  j = constrain(j, 0, lengthY - 1);

  pixel house = grid[i][j];

  house.col = currentColor;
}

void keyPressed() {
  switch(key) {
  case 'q': 
    currentColor = palette[0];
    break;
  case 'w': 
    currentColor = palette[1];
    break;
  case 'e':
    currentColor = palette[2];
  default:
    break;
  }
}
