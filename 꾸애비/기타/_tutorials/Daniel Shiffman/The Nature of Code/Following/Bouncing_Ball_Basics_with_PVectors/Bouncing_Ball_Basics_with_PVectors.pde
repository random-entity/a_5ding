ArrayList<Ball> BallsList = new ArrayList<Ball>();

void setup() {
  size(600, 400);
  noStroke();
  fill(0, 0, 255, 80);
}

void mousePressed() {
  Ball b = new Ball();
  BallsList.add(b);
}


void draw() {
  background(255);
  for (int i = 0; i < BallsList.size(); i++) { 
    BallsList.get(i).moveBall();
    BallsList.get(i).bounce();
    BallsList.get(i).displayBall();
  }
}

class Ball {
  PVector location;
  PVector velocity;
  float radius;
  color ballColor;

  Ball() {
    location = new PVector(width/2, height/2);
    radius = random(30, 50)/2;
    float randTheta = random(2*PI);
    float red = random(0, 255);
    float green = random(0, 255);
    float blue = random(0, 255);
    ballColor = color(red, green, blue);
    velocity = new PVector(10*cos(randTheta), 10*sin(randTheta));
  }

  void moveBall() {
    location.add(velocity);
  }

  void displayBall() {
    fill(ballColor);
    ellipse(location.x, location.y, 2*radius, 2*radius);
  }

  void bounce() {
    if ((location.x + radius > width) || (location.x - radius < 0)) {
      velocity.x *= -1;
    }
    if ((location.y + radius > height) || (location.y - radius < 0)) {
      velocity.y *= -1;
    }
  }
}
