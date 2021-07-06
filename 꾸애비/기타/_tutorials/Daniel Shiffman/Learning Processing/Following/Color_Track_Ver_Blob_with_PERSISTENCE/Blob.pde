class Blob {
  float minx, miny, maxx, maxy;
  ArrayList<PVector> points;
  int id = 0;
  boolean taken = false;
  
  Blob(float x, float y) {
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
    points = new ArrayList<PVector>();
    points.add(new PVector(x, y));
  }

  void add(float x, float y) {
    points.add(new PVector(x, y));
    minx = min(minx, x);
    miny = min(miny, y);
    maxx = max(maxx, x);
    maxy = max(maxy, y);
  }

  PVector getCenter() {
    float cx = (minx + maxx)/2; 
    float cy = (miny + maxy)/2;
    return new PVector(cx, cy);
  }

  boolean isNear(float x, float y) {
    float d = 10000000;
    for (PVector v : points) {
      float tempD = dist(x, y, v.x, v.y);
      if (tempD < d) {
        d = tempD;
      }
    }
    if (d < distThreshold) {
      return true;
    } else {
      return false;
    }
  }

  void become(Blob other) {
    minx = other.minx;
    maxx = other.maxx;
    miny = other.miny;
    maxy = other.maxy;
  }

  void show() {
    stroke(0, 255, 0);
    noFill();
    strokeWeight(2);
    rectMode(CORNERS);
    rect(minx, miny, maxx, maxy);
    fill(255, 0, 0);
    textSize(10);
    text("WHITE!", minx, maxy + 5);

    for (PVector v : points) {
      stroke(0, 0, 255);
      point(v.x, v.y);
    }

    textAlign(CENTER);
    textSize(64);
    fill(0);
    text(id, (minx + maxx)/2, maxy - 10);
  }
}
