// buttons for selecting Mode
class Button { 
  float centerX, centerY, radius = 0, bwid = 0, bhei = 0, dispX, dispY;
  int modeIndex;
  color col;
  String name;
  boolean mouseIsNear = false;
  boolean selected = false;

  Button(float x, float y, float w, float h, int i) {
    centerX = x;
    centerY = y;
    bwid = w;
    bhei = h;
    modeIndex = i; 
    if (i > -1) name = hangulRow.getString(modeIndex);
    else name = "default";
    col = color(255, 255, 0);
    dispX = mainw + centerX;
    dispY = infoBoxH + centerY;
  }

  void setColor(color c) {
    col = c;
  }

  void mouseCheck() {
    float mx = mouseX;
    float my = mouseY;
    if ((abs(mx - centerX) < bwid/2 && abs(my - centerY) < bhei/2)) {
      col = color(127, 0, 0);
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
    //fill(0);    
    //rectMode(CENTER);
    //blendMode(ADD);
    //mouseCheck();
    //if (mouseIsNear) {
    //  fill(0, 255, 255);
    //}
    //if(selected) {
    //  fill(255, 0, 0);
    //}
    //rect(centerX, centerY, bwid, bhei);
    //blendMode(BLEND);
    //textAlign(CENTER, CENTER);
    //text(name, centerX, centerY);
  }
}
