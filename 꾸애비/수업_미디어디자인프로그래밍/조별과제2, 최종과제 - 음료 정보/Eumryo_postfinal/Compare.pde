void filterBev(int cmodeX, int cmodeY) {
  Beverage f = bevArray[focusBevIndex];
  blendMode(ADD);
  rectMode(CORNERS);
  fill(0, 30, 0); 
  if (cmodeX == 1) {
    rect(-9999, -9999, f.destX, 9999);
  } else if (cmodeX == 2) {      
    rect(f.destX, -9999, 9999, 9999);
  } else if (cmodeX == 3) {      
    rect(f.nearest[0].destX, -9999, f.nearest[1].destX, 9999);
  }     
  fill(0, 0, 30); 
  if (cmodeY == 1) {
    rect(-9999, f.destY, 9999, 9999);
  } else if (cmodeY == 2) {      
    rect(-9999, -9999, 9999, f.destY);
  } else if (cmodeY == 3) {      
    rect(-9999, f.nearest[3].destY, 9999, f.nearest[2].destY);
  } 
  blendMode(BLEND);
}

class CompareMode {
  int modeIX, modeIY; // default:0, lower:1, higher:2, similar:3

  CompareMode() {
    modeIX = 0;
    modeIY = 0;
  }
}

//class PerButton {
//  float centerX, centerY, bwid = 0, bhei = 0, dispX, dispY;
//  boolean active = false;

//  PerButton(float x, float y, float w, float h) {
//    centerX = x;
//    centerY = y;
//    bwid = w;
//    bhei = h;
//    active = false;
//  }
//}

class PerButton extends CompareButton {
  boolean isActive;
  
  PerButton(float x, float y, float w, float h) {
    super(x, y, w, h, -1, "y per x", -1, -1);
    isActive = false;
  }
  
}

class CompareButton {
  float centerX, centerY, bwid = 0, bhei = 0, dispX, dispY;
  int cmodeIndex;
  String name;
  color col;
  boolean mouseIsNear = false;
  boolean selected = false;
  int ii, jj;

  CompareButton(float x, float y, float w, float h, int i, String s, int i_, int j) {
    centerX = x;
    centerY = y;
    bwid = w;
    bhei = h;
    cmodeIndex = i;
    name = s;
    col = color(0, 255, 255);
    dispX = mainw + centerX;
    dispY = infoBoxH + centerY;
    ii = i_;
    jj = j;
  }

  void setColor(color c) {
    col = c;
  }

  void mouseCheck() {
    float mx = mouseX - mainw;
    float my = mouseY - infoBoxH;
    if ((abs(mx - centerX) < bwid/2 && abs(my - centerY) < bhei/2)) {
      //col = color(127, 0, 0);
      mouseIsNear = true;
    } else {      
      col = color(255, 255, 0);
      mouseIsNear = false;
    }

    if (selected) {
      col = color(255);
    }
  }

  void display() {
    //fill(col);    
    //if (ii == 0 && jj == compareMode.modeIX) this.setColor(255);
    //if (ii == 1 && jj == compareMode.modeIY) this.setColor(255);
    //rectMode(CENTER);
    //rect(centerX, centerY, bwid, bhei);
    //textAlign(CENTER, CENTER);
    //fill(0);
    //text(name, centerX, centerY);
  }
}
