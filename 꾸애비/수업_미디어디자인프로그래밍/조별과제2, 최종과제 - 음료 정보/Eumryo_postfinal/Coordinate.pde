void displayGuide() {
  //if (!mode.isDefaultX) {
  //  for (int i = 0; i < chartSize; i++) {
  //    Beverage bi = bevArray[i];    
  //    TableRow ri = bevChart.getRow(i);
  //    stroke(192);
  //    strokeWeight(1);
  //    line(bi.dispX, bi.dispY+bi.dispH/2, bi.dispX, mainh-76);
  //    textAlign(LEFT, BOTTOM);
  //    fill(0);
  //    pushMatrix();
  //    translate(bi.dispX - 2, mainh-76 - 5);
  //    rotate(-PI/2);
  //    text(ri.getInt(headerRow.getString(mode.xi)), 0, 0);
  //    popMatrix();
  //  }
  //}
  //if (!mode.isDefaultY) {
  //  for (int i = 0; i < chartSize; i++) {
  //    Beverage bi = bevArray[i];    
  //    TableRow ri = bevChart.getRow(i);
  //    stroke(192);
  //    strokeWeight(1);
  //    line(bi.dispX-bi.dispW/2, bi.dispY, 87, bi.dispY);
  //    textAlign(LEFT, BOTTOM);
  //    fill(0);
  //    text(ri.getInt(headerRow.getString(mode.yi)), 87+2, bi.dispY + 2);
  //  }
  //}
}

void drawGridX(int big) {
  for (int i = min[mode.xi]/big; (i-1)*big <= max[mode.xi]; i++) {
    float dgx = map(big*i, min[mode.xi], max[mode.xi], 0, mainw);
    dgx = dgx*scale + mainw/2 - scale*camX;

    line(dgx, 0, dgx, 834.8);
    pushMatrix();    
    textAlign(LEFT, BOTTOM);
    float z;
    if (scale>=1) {
      z = map(abs(mouseX-dgx), 0, width/5/scale, 25, 5);
    } else {      
      z = map(abs(mouseX-dgx), 0, width/5*scale, 25, 5);
    }
    z = max(z, 10);
    textSize(z);
    translate(dgx - 2, 834.8 - 5);
    rotate(-PI/2);
    text(big*i, 0, 0);
    popMatrix();
  }
}
void drawGridY(int big) {
  for (int i = min[mode.yi]/big; (i-1)*big <= max[mode.yi]; i++) {
    float dgx = map(big*i, min[mode.yi], max[mode.yi], mainh, 0);
    dgx = dgx*scale + mainh/2 - scale*camY;
    line(24.7, dgx, mainw, dgx);
    textAlign(LEFT, BOTTOM);
    float z;
    if (scale>=1) {
      z = map(abs(mouseY-dgx), 0, height/4/scale, 25, 5);
    } else {      
      z = map(abs(mouseY-dgx), 0, height/4*scale, 25, 5);
    }
    z = max(z, 10);
    textSize(z);
    text(big*i, 24.7+2, 2+dgx);
  }
}
void displayGrid() {
  if (mode.xi >= 1) {
    int big = bigInterval[mode.xi];
    int small = smallInterval[mode.xi];
    stroke(100);
    strokeWeight(.0625);
    fill(100);
    drawGridX(small);
    stroke(200);
    strokeWeight(.125);
    fill(50);
    drawGridX(big);
  }  
  if (mode.yi >= 1) {
    int big = bigInterval[mode.yi];
    int small = smallInterval[mode.yi];
    stroke(100);
    strokeWeight(.0625);    
    fill(100);
    drawGridY(small);
    stroke(50);
    strokeWeight(.125);    
    fill(50);
    drawGridY(big);
  }
}

void displayAxes() { // this should be in the displayWindow pushMatrix
  if (!mode.isDefaultX) {
    float dgx = map(0, min[mode.xi], max[mode.xi], 0, mainw);
    dgx = dgx*scale + mainw/2 - scale*camX;
    stroke(0);
    strokeWeight(.25);
    line(dgx, 0, dgx, 834.8);
  }  
  if (!mode.isDefaultY) {
    float dgx = map(0, min[mode.yi], max[mode.yi], mainh, 0);
    dgx = dgx*scale + mainh/2 - scale*camY;
    stroke(0);
    strokeWeight(.25);
    line(24.7, dgx, mainw, dgx);
  }
}


//class Coordinate {
//  Axis xax, yax;
//  Coordinate() {
//  }
//}

//class Axis {
//}
