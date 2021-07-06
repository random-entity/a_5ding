class Blob {
  float minx, miny, maxx, maxy;
  float distThreshold = 50;

  Blob(float x, float y) {
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
  }

  void add(float x, float y) {
    minx = min(minx, x);
    miny = min(miny, y);
    maxx = max(maxx, x);
    maxy = max(maxy, y);
  }

  boolean isNear(float x, float y) {
    if ((x - maxx > distThreshold) || (minx - x > distThreshold) || (y - maxy > distThreshold) || (miny - y > distThreshold)) {
      return false;
    } else {
      return true;
    }
  }

  void show() {
    stroke(0,255,0);
    noFill();
    strokeWeight(2);
    rectMode(CORNERS);
    rect(minx, miny, maxx, maxy);
    fill(255, 0, 0);
    textSize(10);
    text("WHITE!", minx, maxy + 5);
  }
}
