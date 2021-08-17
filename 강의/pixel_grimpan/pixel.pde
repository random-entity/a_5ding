class pixel {
  int x, y;
  color col;

  pixel(int _x, int _y, int _col) {
    x = _x;
    y = _y;
    col = _col;
  }

  void display() {
    fill(col);
    rect(x, y, pixelSize, pixelSize);
  }
}
