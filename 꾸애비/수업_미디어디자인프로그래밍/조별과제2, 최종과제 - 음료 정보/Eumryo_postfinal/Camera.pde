void mouseDragged() {
  minimapCounter = 48;
  if (mouseX < mainw && mouseY < mainh) {
    float dx = mouseX - pmouseX;
    float dy = mouseY - pmouseY;
    if (mouseButton == LEFT) {
      camX -= dx/scale;
      camY -= dy/scale;
    }
    if (mouseButton == RIGHT) {
      for (int i = 0; i < chartSize; i++) {        
        bevArray[i].w = constrain(bevArray[i].w - dy/16, 1, 50);
        bevArray[i].updateH();
      }
    }
    if (mouseButton == CENTER) {
      scale -= dy/128;
    }
  }
}

void mouseWheel(MouseEvent event) {
  minimapCounter = 48;
  if (mouseX < mainw && mouseY < mainh) {
    // save past values
    float tx = (1/scale)*mainw/2 - camX;
    float ty = (1/scale)*mainh/2 - camY;
    float s = scale;

    float e = event.getCount();
    scale = constrain(scale - e/16, 0.5, 8);

    float ntx = tx + (1/scale - 1/s)*mouseX;
    float nty = ty + (1/scale - 1/s)*mouseY;

    camX = (1/scale)*mainw/2 - ntx;
    camY = (1/scale)*mainh/2 - nty;
  } else if (mouseX > mainw && mouseY > height - minimapH) {
    float e = event.getCount();
    scale = constrain(scale - e/16, 0.5, 8);
  }
}

void mousePressed() {
  //println(mouseX, mouseY);

  boolean t = false;

  for (int i = 0; i < chartSize; i++) {
    t = t || bevArray[i].mouseIsNear();

    Beverage bi = bevArray[i];
    //float scaleX, scaleY;
    bi.searchNearest();

    if (bi.mouseIsNear()) {
      isFocusState = true;
      focusBevIndex = bi.index;
      camXsave = camX;
      camYsave = camY;
      scaleSave = scale;

      //if (compareMode.modeIX == 1) {
      //  camX = (bi.currX + bevArray[minI[mode.xi]].destX)/2;
      //  scaleX = mainw/(bi.currX - bevArray[minI[mode.xi]].destX + 1);
      //} else if (compareMode.modeIX == 2) {        
      //  camX = (bi.currX + bevArray[maxI[mode.xi]].destX)/2;
      //  scaleX = mainw/(bevArray[maxI[mode.xi]].destX - bi.currX + 1);
      //} else {        
      //  camX = bi.currX;
      //  scaleX = bi.fsx;
      //}      
      //if (compareMode.modeIY == 1) {
      //  camY = (bi.currY + bevArray[minI[mode.yi]].destY)/2;
      //  scaleY = mainh/(bi.currY - bevArray[minI[mode.yi]].destY + 1);
      //} else if (compareMode.modeIY == 2) {        
      //  camY = (bi.currY + bevArray[maxI[mode.yi]].destY)/2;
      //  scaleY = mainh/(bevArray[maxI[mode.yi]].destY - bi.currY + 1);
      //} else {        
      //  camY = bi.currY;
      //  scaleY = bi.fsy;
      //}
      //scale = max(scaleX, scaleY);
      camX = bi.dog.x;
      camY = bi.dog.y;
      scale = bi.focusScale;
    }
  }

  if (t == false && mouseButton == RIGHT) {
    isFocusState = false;
    //camX = camXsave;
    //camY = camYsave; 
    //scale = scaleSave;
  }

  //for (int i = 0; i < 2; i++) {
  //  for (int j = 0; j < 4; j++) { 
  //    compareModeSelection[i][j].mouseCheck();
  //    if (compareModeSelection[i][j].mouseIsNear) {
  //      if (i == 0) compareMode.modeIX = j;
  //      else compareMode.modeIY = j;
  //    }
  //  }
  //}
}


void keyReleased() {
  for (int i = repulseSprings.size() - 1; i >= 0; i--) {
    VerletSpring2D s = (VerletSpring2D) repulseSprings.get(i);
    physics.removeSpring(s);
    repulseSprings.remove(i);
  }
  mung.clear();
  repulseSprings.clear();
  for (int i = 0; i < chartSize; i++) {
    Beverage bi = bevArray[i];
    bi.alreadyMung = false;
  }
}
// for saving close clusters
ArrayList mung = new ArrayList();
ArrayList repulseSprings = new ArrayList();
void keyPressed() {
  if (key == 'g' || key == 'G') {
    for (int i = 0; i < chartSize; i++) {
      Beverage bi = bevArray[i];          
      VerletParticle2D di = (VerletParticle2D) bi.dog;
      if (dist(mouseX, mouseY, bi.dispX, bi.dispY) < 50*scale ) {
        if (!bi.alreadyMung) {
          mung.add(di);
          bi.alreadyMung = true;
        }
      } else {
        mung.remove(di);          
        bi.alreadyMung = false;
      }
    }
    for (int i = 0; i < mung.size(); i++) {
      for (int j = 0; j < i; j++) {
        VerletParticle2D di = (VerletParticle2D)mung.get(i);
        VerletParticle2D dj = (VerletParticle2D)mung.get(j);
        VerletSpring2D sij = new VerletMinDistanceSpring2D(di, dj, max(125.0/scale, 25), 0.05);
        repulseSprings.add(sij);
        physics.addSpring(sij);
      }
    }
  }

  if (key == '`') {
    compareMode.modeIX = 0;
  }  
  if (key == '1') {
    compareMode.modeIX = 1;
  } 
  if (key == '2') {
    compareMode.modeIX = 2;
  } 
  if (key == '3') {
    compareMode.modeIX = 3;
  }  
  if (key == '4') {
    compareMode.modeIY = 1;
  }  
  if (key == '5') {
    compareMode.modeIY = 2;
  }  
  if (key == '6') {
    compareMode.modeIY = 3;
  } 
  if (key == '7') {
    compareMode.modeIY = 0;
  }
}

void setCamera() {
  // set Camera controls by key

  if (keyPressed) {
    if (keyCode == LEFT || key == 'a' || key == 'A') {
      camVx = -10;
    }  
    if (keyCode == RIGHT || key == 'd' || key == 'D') {
      camVx = 10;
    }  
    if (keyCode == UP || key == 'w' || key == 'W') {
      camVy = -10;
    }  
    if (keyCode == DOWN || key == 's' || key == 'S') {
      camVy = 10;
    }

    if (key == 'q' || key == 'Q') {
      scVel = -0.05;
    }  
    if (key == 'e' || key == 'E') {
      scVel = 0.1;
    }

    // reset
    if (key == 'r' || key == 'R') {
      camX = mainw/2;
      camY = mainh/2;
      scale = 0.8;
    }

    // scale only Bevs
    for (int i = 0; i < chartSize; i++) {
      if (key == 'z' || key == 'Z') {
        bevArray[i].w = constrain(bevArray[i].w - 2, 2, 50);
        bevArray[i].updateH();
      }
      if (key == 'c' || key == 'C') {
        bevArray[i].w = constrain(bevArray[i].w + 2, 2, 50);     
        bevArray[i].updateH();
      }
      if (key == 'r' || key == 'R') {
        bevArray[i].w = bevDispWidth;
        bevArray[i].updateH();
      }
    }
  } else {
    camVx = 0; 
    camVy = 0;
    scVel = 0;
  }
  // update Camera point
  if (isFocusState && keyPressed && (key == 'f' || key == 'F')) {
    camX = bevArray[focusBevIndex].dog.x;
    camY = bevArray[focusBevIndex].dog.y;
  } else {
    camX = constrain(camX + camVx, 0, mainw);
    camY = constrain(camY + camVy, 0, mainh);
  }    
  scale = constrain(scale + scVel, 0.5, 4);
}
