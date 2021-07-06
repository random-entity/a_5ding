int rightPanelCounter = 0;

void displayRightPanels() {

  pushMatrix();
  // make left top corner of info panel the origin
  translate(960, 40);
  // info panel color
  //fill(255, 249, 227);    
  //rect(0, 0, rightPanelWidth, infoBoxH);
  // draw selected Beverage info
  Beverage currB = bevArray[selectedBevIndex];
  Beverage focB = bevArray[focusBevIndex];
  if (isFocusState || currB.mouseIsNear()) rightPanelCounter = 24;
  else rightPanelCounter--;
  float t;
  if (rightPanelCounter < 6) t = map(rightPanelCounter, 6, 0, 255, 0);
  else t = 255;
  tint(255, t);

  if (rightPanelCounter > 0) {
    if (!isFocusState || (isFocusState && currB.mouseIsNear())) {
      imageMode(CORNER);
      image(rightPanel, 0, 0);
      imageMode(CENTER);
      image(currB.photo, 170, 200, photoH*currB.photo.width/currB.photo.height, photoH);

      // display text info 
      textAlign(CENTER, CENTER);
      fill(0, t);
      textSize(20);
      for (int i = 1; i < 6; i++) {
        String s = headerRow.getString(i);
        String h = hangulRow.getString(i);
        String u = unitRow.getString(i);
        textAlign(RIGHT);
        text(bevChart.getRow(selectedBevIndex).getInt(s) + u, 1240-960, 475-50+41*i);
      }
    } else {
      imageMode(CORNER);
      image(rightPanel, 0, 0);
      imageMode(CENTER);
      image(focB.photo, 170, 200, photoH*focB.photo.width/focB.photo.height, photoH);

      // display text info 
      textAlign(CENTER, CENTER);
      fill(0);
      textSize(20);
      for (int i = 1; i < 6; i++) {
        String s = headerRow.getString(i);
        String h = hangulRow.getString(i);
        String u = unitRow.getString(i);
        textAlign(RIGHT);
        text(bevChart.getRow(focusBevIndex).getInt(s) + u, 1240-960, 475-50+41*i);
      }
    }
  }
  noTint();


  //// to draw axis selection panel
  //// make left top corner of axis selection panel the origin
  //translate(0, infoBoxH);
  //// axis selection panel color
  //fill(255, 202, 192);
  //rectMode(CORNER);
  //rect(0, 0, rightPanelWidth, height);


  //// draw needed texts: "x" "y" "lower" "higher"
  //textAlign(CENTER, CENTER);
  //fill(0);
  //float x = margin4 + (rightPanelWidth - 2*margin4)*(2*-1+3)/12;
  //float y = margin3 + (axisBoxH - 2*margin3)*(4*0+1)/8;
  //text("x : ", x, y);
  //y = margin3 + (axisBoxH - 2*margin3)*(4*1+1)/8;
  //text("y : ", x, y);  
  ////x = margin4 + (rightPanelWidth - 2*margin4)*(2*0.5+3)/12;
  ////y = margin3 + (axisBoxH - 2*margin3)*(4*0.5+1)/8;
  ////text("선택보다 낮은", x, y);
  ////x = margin4 + (rightPanelWidth - 2*margin4)*(2*3.5+3)/12;
  ////text("선택보다 높은", x, y);
  ////x = margin4 + (rightPanelWidth - 2*margin4)*(2*0.5+3)/12;
  ////y = margin3 + (axisBoxH - 2*margin3)*(4*1.5+1)/8;
  ////text("선택보다 낮은", x, y);
  ////x = margin4 + (rightPanelWidth - 2*margin4)*(2*3.5+3)/12;
  ////text("선택보다 높은", x, y);  

  popMatrix();

  //fill(255);
  //textAlign(RIGHT, BOTTOM);
  //text(mode.hangulX, mainw, mainh);  
  //textAlign(LEFT, TOP);
  //text(mode.hangulY, 0, 0);
}
