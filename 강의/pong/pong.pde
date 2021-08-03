float player1X, player2X;
float player1Y, player2Y;
float ballX, ballY;
int step = 4;

void setup() {
  size(400, 200);
  player1X = 20;
  player2X = width - 20;
  player1Y = height/2;
  player2Y = height/2;
  rectMode(CENTER);
}

void draw() {
  background(0);
  rect(player1X, player1Y, 10, 40);
  rect(player2X, player2Y, 10, 40);
}

void keyPressed() {
  //if(key == 
  if (key == CODED) {
    if (keyCode == UP) {
      player1Y -= step;
    } else if (keyCode == DOWN) {
      player1Y += step;
    }
  }
}