void keyPressed() {
  if (keyCode == LEFT) {
    player.move(-3, 0);
  }  
  if (keyCode == RIGHT) {
    player.move(3, 0);
  }  
  if (keyCode == UP) {
    player.move(0, -3);
  }  
  if (keyCode == DOWN) {
    player.move(0, 3);
  }
  if (key == ' ') {
    player.shoot();
  }
  if (key == 'r' || key == 'R') {
    reset();
  }
}
