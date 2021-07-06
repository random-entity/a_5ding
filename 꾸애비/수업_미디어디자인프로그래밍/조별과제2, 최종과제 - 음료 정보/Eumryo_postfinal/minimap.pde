void displayMinimapCam() {
  pushMatrix();
  translate(mainw, mainh);
  scale(width/mainw - 1);
  fill(255);
  rect(0, 0, mainw, mainh);
  translate(0.1*mainw, 0.1*mainh);
  scale(0.8);
  stroke(0);
  stroke(255, 35, 102);
  strokeWeight(5);
  rectMode(CENTER);
  noFill();
  rect(camX, camY, (1/scale)*mainw, (1/scale)*mainh);  
  rectMode(CORNER);
  noStroke();
  popMatrix();
} 

void displayMinimap() {
  if (minimapCounter > 0)
  {
    minimapCounter--;

    //minimap location: upper-left corner(46, 617); center(178.5, 718); width 265; height 202;
    minimapB.mouseCheck();
    if (mousePressed && minimapB.mouseIsNear) {
      float x = map(mouseX, 46, 46+265, 0, width);
      float y = map(mouseY, 617, 617+202, 0, height);
      camX = x;
      camY = y;
    }

    pushMatrix();
    translate(46, 617);//mouseX + 15, mouseY + 15);
    float t = map(minimapCounter, 12, 0, 255, 0);
    if(minimapCounter < 12) tint(255, t);
    imageMode(CORNER);
    image(minimapbg, 0, 0);
    float l = 0.5*(202-265*height/width);
    translate(0, l);
    translate(265/10, (265*height/width)/10);
    scale(0.194*0.8);
    stroke(191, 183, 211);
    strokeWeight(10);
    noFill();  
    blendMode(BLEND);  
    rectMode(CENTER);
    rect(camX, camY, (1/scale)*width, (1/scale)*height);  
    rectMode(CORNER);
    noStroke();
    for (int i = 0; i < chartSize; i++) {
      Beverage bi = bevArray[i];
      bi.setCurrLoc();
      bi.displayDot();
    }
    noTint();
    popMatrix();
  }
}
