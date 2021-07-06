int droptimerX, droptimerY;

void runButtons() {
  imageMode(CENTER);
  image(buttondef, defYb.centerX, defYb.centerY);
  image(buttondef, defXb.centerX, defXb.centerY);
  defXb.mouseCheck();
  defYb.mouseCheck();
  dropXb.mouseCheck();
  dropYb.mouseCheck();
  if (defXb.mouseIsNear) {
    dropX = true;
    droptimerX = 24;
  }  
  if (defYb.mouseIsNear) {
    dropY = true;
    droptimerY = 24;
  }

  float tx;
  if (droptimerX < 6) tx = map(droptimerX, 6, 0, 255, 0);
  else tx = 255;

  float ty;
  if (droptimerY < 6) ty = map(droptimerY, 6, 0, 255, 0);
  else ty = 255;
 
  noTint();
  if (dropX) {
    tint(255, tx); 
    if (dropXb.mouseIsNear) droptimerX = 24;
    else droptimerX--;
    if (droptimerX == 0) dropX = false;
    image(buttondrop, dropXb.centerX, dropXb.centerY);  
    noTint();
  }  
  if (dropY) {  
    tint(255, ty); 
    if (dropYb.mouseIsNear) droptimerY = 24;
    else droptimerY--;
    if (droptimerY == 0) dropY = false;
    image(buttondrop, dropYb.centerX, dropYb.centerY);
    noTint();
  }
  // draw and run selection buttons
  for (int i = 0; i < 2; i++) {
    for (int j = 0; j < 6; j++) {
      axisSelection[i][j].mouseCheck();
      // change mode as clicked
      if (mousePressed && axisSelection[i][j].mouseIsNear) {
        if (dropX && i == 0) {
          mode.changeModeX(axisSelection[i][j].modeIndex);
        } else if (dropY) {
          mode.changeModeY(axisSelection[i][j].modeIndex);
        }
      }
    }
  }
  //for (int i = 0; i < 2; i++) {
  //  for (int j = 0; j < 4; j++) {
  //    compareModeSelection[i][j].display();
  //  }
  //}
  mode.update();
  if (mode.xi >= 0) image(whiteText[mode.xi], defXb.centerX, defXb.centerY);
  else image(whiteText[0], defXb.centerX, defXb.centerY);
  if (mode.yi >= 0) image(whiteText[mode.yi], defYb.centerX, defYb.centerY);
  else image(whiteText[0], defYb.centerX, defYb.centerY);

  // for each frame, update the newest selection, keep if no new one clicked
  for (int i = 0; i < 2; i++) {
    for (int j = 0; j < 5; j++) {
      if ((i == 0 && j+1 == mode.xi) || (i == 1 && j+1 == mode.yi)) {
        axisSelection[i][j].selected = true;
      } else axisSelection[i][j].selected = false;
      // draw buttons with color according to selected/mouseNear state
      //axisSelection[i][j].display();
      if ((dropX && i == 0) || (dropY && i == 1)) {
        if (axisSelection[i][j].selected) image(blueText[j+1], axisSelection[i][j].centerX, axisSelection[i][j].centerY);
        else if (axisSelection[i][j].mouseIsNear) image(whiteText[j+1], axisSelection[i][j].centerX, axisSelection[i][j].centerY, whiteText[j+1].width*1.1, whiteText[j+1].height*1.1);
        else image(whiteText[j+1], axisSelection[i][j].centerX, axisSelection[i][j].centerY);
      }
    }
    if ((i == 0 && -1 == mode.xi) || (i == 1 && -1 == mode.yi)) {
      axisSelection[i][5].selected = true;
    } else axisSelection[i][5].selected = false;
    axisSelection[i][5].display();
  }
  // mode selection complete!!!
}
