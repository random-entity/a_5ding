int resolution = 25;
int Nx, Ny;
dot[][] grid;
float G = -40;
float k = 0.045;
float d = 0.035;
float epsilon = 1;
float pow = 0.4;

void setup() {
  size(1200, 800);

  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      stroke(color(map(i, 0, width - 1, 0, 255), map(j, 0, height - 1, 0, 255), 255));
      point(i, j);
    }
  }

  Nx = width / resolution;
  Ny = height / resolution;
  grid = new dot[Nx][Ny];

  for (int i = 0; i < grid.length; i++) {
    for (int j = 0; j < grid[0].length; j++) {
      color c = color(map(i, -0.5, grid.length - 0.5, 0, 255), map(j, -0.5, grid.length - 0.5, 0, 255), 255);
      grid[i][j] = new dot((i + 0.5) * width / Nx, (j + 0.5) * height / Ny, c);
    }
  }
  
  //blendMode(REPLACE);
}

void draw() {
  background(255);

  for (int i = 0; i < grid.length; i++) {
    for (int j = 0; j < grid[0].length; j++) {
      grid[i][j].runPhysics();
      grid[i][j].display();
    }
  }
}

void mouseWheel(MouseEvent event) {
  G += event.getCount() * 5;
  println("G = " + G);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    pow -= 0.1;
  } else {
    pow += 0.1;
  }

  pow = constrain(pow, 0.1, 2);
  println("pow = " + pow);
}
