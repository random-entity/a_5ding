int N = 100;
Bubble[] bubbles = new Bubble[N];
int total = 1; 

void setup() { 
  size(640, 360); 
  fill(0, 255, 0);
  stroke(0);
  for (int n = 0; n < N; n++) {
    bubbles[n] = new Bubble(random(10, 30));
  }
}

void mousePressed() {
  total++;
  if (total > 100) {
    total = 1;
  }
}

void draw() {
  background(255);

  for (int n = 0; n < total; n++) {
    bubbles[n].ascend();
    bubbles[n].display();
    bubbles[n].top();
  }
}

class Bubble {

  float x, y;
  float d;

  Bubble(float d_) {
    x = random(width);
    y = random(height);
    d = d_;
  }

  void ascend() {
    y -= random(3);
    x += random(-2, 2);
  }

  void display() {
    ellipse(x, y, d, d);
  }

  void top() {
    if (y + d/2 < 0) {
      y = height + d/2;
    }
  }
}
