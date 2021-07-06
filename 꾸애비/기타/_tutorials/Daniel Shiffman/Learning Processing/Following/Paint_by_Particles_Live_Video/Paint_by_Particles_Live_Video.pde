import processing.video.*;
Capture video;
Particle[] particles;

void setup() {
  size(600, 400, P2D);
  video = new Capture(this, 640, 480);
  video.start();
  particles = new Particle[2500];
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle();
  }
  background(0);
  noStroke();
}

void draw() {
  for (int i = 0; i < particles.length; i++) {
    particles[i].display();
    particles[i].move();
  }
}

void captureEvent(Capture video) {
  video.read();
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
    color c = video.get(int(x), int(y));
    fill(c);
    ellipse(x, y, 5, 5);
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
