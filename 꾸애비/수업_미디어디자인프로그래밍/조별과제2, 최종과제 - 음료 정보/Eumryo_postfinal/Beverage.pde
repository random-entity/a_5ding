import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

// Reference to physics world
VerletPhysics2D physics;

ArrayList masters;
ArrayList dogs;

class Node extends VerletParticle2D {
  int nodeNo;
  Node(Vec2D pos) {
    super(pos);
  }
  // All we're doing really is adding a display() function to a VerletParticle
  void display() {
    fill(255);
    ellipse(x, y, 16, 16);
  }
}



class Beverage {
  String name;
  int index, price, kcal, sugar, na, ml;
  float defX, defY, currX, currY, destX, destY, dispX, dispY, dispW, dispH, dogdispX, dogdispY, fixx, fixy;
  float jx, jy; // jinyeoldae
  PImage photo, white, pphoto;
  float w, h;
  Beverage[] nearest = new Beverage[4];
  float ccx, ccX, ccy, ccY, focusScale, fsx, fsy;
  Node master, dog;
  boolean alreadyMung;

  Beverage(int i, String name_, int p, int k, int s, int n, int m) {
    name = name_;
    index = i;
    price = p;
    kcal = k;
    sugar = s;
    na = n;
    ml = m;
    photo = loadImage(i + 2 + ".png");
    pphoto = loadImage(i + 2 + "b.png");
    //println(pphoto.width);
    //white = loadImage(i + 2 + "a.png");
    //white.filter(THRESHOLD, 0);
    fixx = map(i%25, -2, 26, 0, mainw);
    fixy = map(i/25, -1, 2, 0, height-mainh);
    jx = map(i%7, -1, 7, 0, mainw);
    jy = map(i/7, -1, 7, 0, mainh);
    defX = map(i, -1, chartSize, 0, mainw);
    currX = defX;
    defY = mainh/2;
    currY = defY;
    dispX = currX;
    dispY = currY;
    w = bevDispWidth;
    h = bevDispWidth*pphoto.height/pphoto.width;
    dispW = w;
    dispH = h;
    Vec2D currP = new Vec2D(currX, currY);
    master = new Node(currP);
    dog = new Node(currP);
    VerletParticle2D ma = (VerletParticle2D) master;
    VerletParticle2D d = (VerletParticle2D) dog;
    VerletSpring2D leash = new VerletSpring2D(ma, d, 1, 0.5);
    physics.addSpring(leash);
    alreadyMung = false;
  }

  void display() {
    imageMode(CENTER);
    blendMode(BLEND);
    //tint(0);
    //blendMode(DIFFERENCE);
    //image(white, dog.x, dog.y, (5+w)/scale, (5+h)/scale);
    float ss = constrain(scale, 1, 2);
    image(pphoto, dog.x, dog.y, w/ss, h/ss);
    blendMode(BLEND);
    noTint();
  }

  void displayDot() {
    float x = map(currX, 0, mainw, 255, 0);
    float y = map(currY, mainh, 0, 255, 0);
    float t = map(minimapCounter, 12, 0, 255, 0);
    if (minimapCounter < 12) fill(255, x, y, t);
    else fill(255, x, y);
    ellipse(currX, currY, 60, 60);
  }  

  void displayMaster() {
    fill(0, 255, 0);
    noStroke();
    ellipse(master.x, master.y, 10/scale, 10/scale);
  }
  void displayDog() {
    noStroke();
    fill(0, 0, 255);
    dog.display();
  }
  void displaySpring() {
    strokeWeight(0.5);
    stroke(255);
    line(master.x, master.y, dog.x, dog.y);
  }

  void updateDispLoc() {
    dispX = currX*scale + mainw/2 - scale*camX;
    dispY = currY*scale + mainh/2 - scale*camY;
    dogdispX = dog.x*scale + mainw/2 - scale*camX;
    dogdispY = dog.y*scale + mainh/2 - scale*camY;
    dispW = w*scale;
    dispH = h*scale;
  }

  void updateH() {
    h = w*pphoto.height/pphoto.width;
  }

  void setCurrLoc() {
    TableRow ro = bevChart.getRow(index);
    if (mode.isDefaultX && mode.isDefaultY) {
      currX = lerp(currX, jx, 0.25);      
      currY = lerp(currY, jy, 0.25);
    } else {
      if (!mode.isDefaultX) {
        String en = headerRow.getString(mode.xi);
        float dx = ro.getInt(en);      
        destX = map(dx, min[mode.xi], max[mode.xi], 0, mainw);
      } else if (!mode.isDefaultY) {
        destX = mainw/2;
      } else destX = defX;

      currX = lerp(currX, destX, 0.25);

      if (!mode.isDefaultY) {
        String en = headerRow.getString(mode.yi);
        float dy = ro.getInt(en); 
        destY = map(dy, min[mode.yi], max[mode.yi], mainh, 0);
      } else if (!mode.isDefaultX) {
        destY = mainh/2;
      } else destY = defY;

      currY = lerp(currY, destY, 0.25);
    }      
    master.x = currX;
    master.y = currY;
  }

  boolean mouseIsNear() {
    if ((mouseX > 87 && mouseY < mainh - 76 && abs(mouseX - dogdispX) < dispW/2/scale && abs(mouseY - dogdispY) < dispH/2/scale)
      ||
      (mouseX < mainw && mouseY > mainh && abs(mouseX-fixx)<15 && abs(mouseY-mainh-fixy)<20)) {
      stroke(255, 255, 0);
      float ss = constrain(scale, 1, 2);
      strokeWeight(4/ss);
      noFill();
      rectMode(CENTER);
      rect(dog.x, dog.y, w/ss, h/ss);
      noStroke();
      rectMode(CORNER);
      return true;
    } else return false;
  }

  void searchNearest() {
    Beverage l, r, d, u;
    if (mode.xi != -1) {
      l = bevArray[minI[mode.xi]];
      r = bevArray[maxI[mode.xi]];
    } else if (mode.yi != -1) {
      l = this;
      r = this;
    } else {
      l = bevArray[0]; 
      r = bevArray[chartSize-1];
    }
    if (mode.yi != -1) {
      d = bevArray[minI[mode.yi]];
      u = bevArray[maxI[mode.yi]];
    } else if (mode.xi != -1) {
      d = this;
      u = this;
    } else {
      d = bevArray[0]; 
      u = bevArray[chartSize-1];
    }

    for (int i = 0; i < chartSize; i++) {
      Beverage bi = bevArray[i];
      if (l.destX < bi.destX && bi.destX < destX) l = bi;
      if (destX < bi.destX && bi.destX < r.destX) r = bi;
      if (destY < bi.destY && bi.destY < d.destY) d = bi; // dest gijun
      if (u.destY < bi.destY && bi.destY < destY) u = bi;
    }
    if (mode.xi == -1 && mode.yi == -1) {
      d = l; 
      u = r;
    }

    nearest[0] = l;
    nearest[1] = r;
    nearest[2] = d;
    nearest[3] = u;

    // get the min max x y of the four
    ccx = l.destX;
    ccX = r.destX;
    ccy = d.destY;
    ccY = u.destY;
    //for (int i = 0; i < 4; i++) {
    //  ccx = min(ccx, nearest[i].destX);
    //  ccX = max(ccX, nearest[i].destX);
    //  ccy = min(ccy, nearest[i].destY);
    //  ccY = max(ccY, nearest[i].destY);
    //}

    float fx, fy;
    fx = max(ccX - destX, destX - ccx);
    fy = max(ccY - destY, destY - ccy);

    fsx = mainw/(2*fx); 
    fsy = mainh/(2*fy);

    if (fx/fy > mainw/mainh) {
      focusScale = fsx;
    } else {
      focusScale = fsy;
    }
    //focusScale *= 0.8;

    int dispRadius = 10;
    for (int i = 0; i < width; i += 5) {
      int counter = 0;
      for (int n = 0; n < chartSize; n++) {
        if (dist(destX, destY, bevArray[n].destX, bevArray[n].destY) < i) counter++;
      }
      if (counter >= 4) {
        dispRadius = i;
        break;
      }
    }
    focusScale = height/(2*dispRadius);
    focusScale *= 0.8;
  }
}


void constructBevArray() {
  for (int i = 0; i < chartSize; i++) {
    TableRow row = bevChart.getRow(i);
    String name_ = row.getString("Name");
    int p = row.getInt("Price");
    int k = row.getInt("Calories(kcal)");
    int s = row.getInt("Sugars(g)");
    int n = row.getInt("Sodium(mg)");
    int m = row.getInt("Volume(ml)");
    bevArray[i] = new Beverage(i, name_, p, k, s, n, m);
  }
}
