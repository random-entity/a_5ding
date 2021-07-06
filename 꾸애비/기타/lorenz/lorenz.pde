float x = 0.01, y = 0.05, z = 0;
float a = 8, b = 28, c = 2.667;
ArrayList<PVector> points = new ArrayList<PVector>();

void setup() {
  size(800, 600, P3D);
  background(0);
}

void draw() {
  float dt = 0.01;
  float dx = (a * (y - x)) * dt;
  float dy = (x * (b - z) - y) * dt;
  float dz = (x * y - c * z) * dt;
  x += dx;
  y += dy;
  z += dz;

  points.add(new PVector(x, y, z));

  noFill();
  colorMode(HSB);
  translate(width/2, height/2);
  scale(5);
  
  float hue = 0;

  beginShape();
  for (PVector v : points) {
    stroke(hue, 255, 255);
    vertex(v.x, v.y, v.z);
    hue += 0.1;
    if(hue > 255) hue = 0;
  }
  endShape();
}
