void highlight(Beverage b1, Beverage b2, Beverage b3, Beverage b4) {
  ellipseMode(CENTER);

  fill(255, 0, 0);
  ellipse(b1.destX, b1.destY, 50, 50);
  fill(0, 255, 0);
  ellipse(b2.destX, b2.destY, 50, 50);
  fill(0, 0, 255);
  ellipse(b3.destX, b3.destY, 50, 50);  
  fill(0, 0, 0);
  ellipse(b4.destX, b4.destY, 50, 50);
  //noLoop();
}

void displayMainWindow() {
  // draw the Beverages
  pushMatrix();
  scale(scale);
  translate((1/scale)*mainw/2 - camX, (1/scale)*mainh/2 - camY);
  for (int i = 0; i < chartSize; i++) {
    Beverage bi = bevArray[i];
    bi.setCurrLoc();

    // halo if focused
    if (isFocusState && focusBevIndex == i) {
      tint(100, 255, 255);
      imageMode(CENTER);      
      blendMode(ADD);
      float ss = constrain(scale, 1, 2);
      image(am, bi.dog.x, bi.dog.y, bi.w*3/ss, bi.h*3/ss);
      noTint();      
      blendMode(BLEND);      
      //highlight(bi.nearest[0], bi.nearest[1], bi.nearest[2], bi.nearest[3]);
    }
    // draw! 
    bi.displaySpring();
    bi.displayMaster();
    //bi.displayDog();    
    bi.display();

    // set selected Beverage
    bi.updateDispLoc();
    if (bi.mouseIsNear()) selectedBevIndex = i;
  }
  filterBev(compareMode.modeIX, compareMode.modeIY);

  rectMode(CORNER);

  // for Camera and Selection debugging
  //stroke(255, 0, 0); 
  //strokeWeight(10);
  //line(camX, camY, 0, 0);
  //stroke(0, 255, 0); 
  //noFill();
  //rect(0, 0, mainw, mainh);
  //noStroke();
  //fill(255, 0, 255);
  //ellipse(camX, camY, 20, 20);

  //displayAxes();

  popMatrix();  // end drawing main window

  imageMode(CORNER);
  //image(xy, 0, mainh - xy.height);
}
