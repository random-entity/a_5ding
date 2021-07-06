int num = 20;
int N = 10;
int[] dx = new int[num];
int[] dy = new int[num];

void setup() {
  size(100, 100);
  for (int i = 0; i < num; i++) {
    dx[i] = i*5;
    dy[i] = 12+(i*6);
  }
}

void draw() {
  background(204);
  for (int i = 0; i < num; i++) {
    dx[i] = dx[i] + 1;
    if (dx[i]>100) {
      dx[i] = -100;
    }
    diagonals(dx[i], dy[i]);
  }
}

void diagonals(int x, int y) {
  for (int i = 0; i < N; i++) {
    stroke(map(i, 0, N-1, 0, 255));
    line(x+10*i, y, x+10*i+20, y-40);
  }
}
