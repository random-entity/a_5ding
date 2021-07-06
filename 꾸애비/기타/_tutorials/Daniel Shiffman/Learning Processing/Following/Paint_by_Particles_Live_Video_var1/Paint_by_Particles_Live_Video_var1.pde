import processing.video.*;
Capture video;
Particle[] particles;
int N = 1000;

void setup() {
  size(640, 480, P2D);
  video = new Capture(this, 640, 480);
  video.start();
  particles = new Particle[N];
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle(i);
  }
  background(0);
  noStroke();
  rectMode(CENTER);
}

void draw() {
  for (int i = 0; i < particles.length; i++) {
    particles[i].display();
    particles[i].move();
  }
}

int counter = 0;
void mousePressed() {
  if (counter % 2 == 0) {
    noLoop();
  } else {
    loop();
  }
  counter++;
}

void captureEvent(Capture video) {
  video.read();
}

class Particle {

  float x, y, vx, vy;
  float r = 1;

  Particle(int i) {
    x = width/2;
    y = height/2;
    float a = map(i, 0, N, 0, TWO_PI);
    float speed = 1;
    vx = cos(a) * speed;
    vy = sin(a) * speed;
  }

  void display() {
    color c = video.get(int(x), int(y));
    fill(c);
    ellipse(x, y, 2*r, 2*r);
  }

  void move() {
    x += vx;
    y += vy;
    if (dist(x, y, width/2, height/2) > dist(0, 0, width/2, height/2)) {
      x = width/2;
      y = height/2;
    }
  }
}
