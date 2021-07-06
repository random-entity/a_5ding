Particle[] particles;
PImage luda;

void setup() {
  size(549, 800, P2D);
  luda = loadImage("Luda9.png");
  particles = new Particle[2000];
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle();
  }
  noStroke();
}

void draw() {
  background(0);
  for (int i = 0; i < particles.length; i++) {
    particles[i].display();
    particles[i].move();
  }
}

class Particle {

  float x, y, vx, vy;

  Particle() {
    x= width/2;
    y= height/2;
    float a = random(TWO_PI);
    float speed = random(1, 2);
    vx = cos(a) * speed;
    vy = sin(a) * speed;
  }

  void display() {
    color c = luda.get(int(x), int(y));
    fill(c);
    ellipse(x, y, 20, 20);
  }

  void move() {
    x += vx;
    y += vy;
    if ((x < 0) || (x > width)) {
      vx *= -1;
    }
    if ((y < 0) || (y > height)) {
      vy *= -1;
    }
  }
}
