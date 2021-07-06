import processing.video.*;

Movie video; 

void setup() {
  size(600, 400, P2D); 
  video = new Movie(this, "Rotation.mov");
  video.loop();
}

void movieEvent(Movie video) {
  video.read();
}

void draw() {
  float r = map(mouseX, 0, width, 0, 10);
  video.speed(r);

  image(video, 0, 0, width, height);
}

void mousePressed() {
  video.jump(0);
}
