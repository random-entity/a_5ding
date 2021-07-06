noStroke();
size(510, 510);
for (int i = 0; i < width; i++) {
  for (int j = 0; j < height; j++) {
    int k = (i * j) % 255;
    stroke(k, 0, k*2/3+44);
    point(i, j);
  }
}
