PImage[] ludas = new PImage[8];
int N = 100;
Bubble[] bubbles = new Bubble[N];
int total = 1; 

void setup() { 
  size(800, 800);   

  for (int i = 0; i < ludas.length; i++) {
    ludas[i] = loadImage("luda" + (i+1) + ".png");
  }

  for (int n = 0; n < N; n++) {
    bubbles[n] = new Bubble(ludas[n % 8], random(40, 90));
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

  imageMode(CENTER); 
  image(ludas[0], width/2, height/2, ludas[0].width*1.5, ludas[0].height*1.5);

  for (int n = 0; n < total; n++) {
    bubbles[n].ascend();
    bubbles[n].display();
    bubbles[n].top();
  }
}

class Bubble {

  float x, y;
  float d;
  PImage my_luda;

  Bubble(PImage img_, float d_) {
    x = random(width);
    y = random(height);
    d = d_;
    my_luda = img_;
  }

  void ascend() {
    y -= random(-1, 5);
    x += random(-2, 2);
  }

  void display() {
    image(my_luda, x, y, 2*d, 2*d*my_luda.height/my_luda.width);
  }

  void top() {
    if (y + d/2 < 0) {
      y = height + d/2;
    }
  }
}
