int resolution = 25;
int Nx, Ny;
dot[][] grid;

void setup() {
  size(1200, 800);

  Nx = width / resolution;
  Ny = height / resolution;
  grid = new dot[Nx][Ny];

  for (int i = 0; i < grid.length; i++) {
    for (int j = 0; j < grid[0].length; j++) {
      grid[i][j] = new dot((i + 0.5) * width / Nx, (j + 0.5) * height / Ny, color(255));
    }
  }
}

void draw() {
  background(0);

  for (int i = 0; i < grid.length; i++) {
    for (int j = 0; j < grid[0].length; j++) {
      grid[i][j].runPhysics();
      grid[i][j].display();
    }
  }
}

void mouseWheel(MouseEvent event) {
}

void mousePressed() {
}
