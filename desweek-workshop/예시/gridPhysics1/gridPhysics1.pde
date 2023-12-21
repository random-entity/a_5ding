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

float gravity = 1;

void draw() {
  background(0);

  for (int i = 0; i < grid.length; i++) {
    for (int j = 0; j < grid[0].length; j++) {
      dot dij = grid[i][j];

      float dirX = mouseX - dij.x;
      float dirY = mouseY - dij.y;

      PVector dir = new PVector(dirX, dirY);

      float dist = dir.mag();

      if (dist > 50) {
        dir.normalize();

        PVector force = PVector.mult(dir, gravity / sqrt(sqrt(dist)));

        dij.ax = force.x;
        dij.ay = force.y;

        dij.runPhysics();
      }

      dij.display();
    }
  }
}

void mouseWheel(MouseEvent event) {
}

void mousePressed() {
}
