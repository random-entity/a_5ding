class Kid {
  float arngX, arngY;
  float d, moml, legl, arml; 
  int number, row, column;
  PVector groundLoc, arrangedLoc, destLoc, saveBeforeHopLoc = new PVector(0, 0), pgroundLoc;
  float legAngle, armAngle, legoffset, armoffset, idleArmJugi;
  int arrangwalkframe = 0;
  int chejoframe = 0;
  float velocity;
  PVector vel;
  int changeDirJugi, changeDirCounter;
  PImage arm, body, head, leg;

  Kid(int i) {
    number = i; 
    row = i/10; 
    column = i % 10;
    if (row <= 1) {
      arm = loadImage("arm-1.png");
      body = loadImage("body-1.png");
      head = loadImage("head-1.png");
      leg = loadImage("leg-1.png");
    } else if (row <= 3) {      
      arm = loadImage("arm-2.png");
      body = loadImage("body-2.png");
      head = loadImage("head-2.png");
      leg = loadImage("leg-2.png");
    } else if (row <= 5) {      
      arm = loadImage("arm-3.png");
      body = loadImage("body-3.png");
      head = loadImage("head-2.png");
      leg = loadImage("leg-3.png");
    } else if (row <= 7) {      
      arm = loadImage("arm-2.png");
      body = loadImage("body-4.png");
      head = loadImage("head-2.png");
      leg = loadImage("leg-3.png");
    } else {      
      arm = loadImage("arm-1.png");
      body = loadImage("body-1.png");
      head = loadImage("head-1.png");
      leg = loadImage("leg-1.png");
    }  
    arngX = map(row, 0, 9, width/4, width*3/4);
    arngY = map(column, 0, 9, height/5, height*4/5);
    groundLoc = new PVector(arngX, arngY);
    pgroundLoc = new PVector(arngX, arngY);
    destLoc = new PVector(arngX, arngY);

    velocity = random(1, 5);
    vel = new PVector(0, 0);

    d = 20;
    moml = 30;
    legl = 25;
    arml = 20;

    legAngle = 0;
    armAngle = 0;
    legoffset = random(24);
    armoffset = random(24);
    idleArmJugi = random(5, 15);
    //println(legoffset);

    changeDirJugi = int(random(1, 4));
    changeDirCounter = 0;
  }

  void storeLoc() {
    pgroundLoc = groundLoc;
  }

  void idlewalk() {
    float destx = getNodeByNodeNo(number).x; 
    float desty = getNodeByNodeNo(number).y;
    float x = lerp(groundLoc.x, destx, 0.02);
    float y = lerp(groundLoc.y, desty, 0.02);
    PVector aniLoc = new PVector(x, y);
    groundLoc.set(aniLoc);
  }

  void idlewalk(float lerpSetting) {
    float destx = getNodeByNodeNo(number).x; 
    float desty = getNodeByNodeNo(number).y;
    float x = lerp(groundLoc.x, destx, lerpSetting);
    float y = lerp(groundLoc.y, desty, lerpSetting);
    PVector aniLoc = new PVector(x, y);
    ////Move by Velocity? START
    //destLoc = new PVector(destx, desty);
    //vel = PVector.sub(destLoc, groundLoc);
    //float m = vel.mag();
    //vel.setMag(min(m, velocity));
    //groundLoc.add(vel);
    //Move by Velocity? END
    groundLoc.set(aniLoc);
  }  

  void idlewalk(boolean move_by_velocity) {
    if (changeDirCounter == 0) {
      float destx = getNodeByNodeNo(number).x; 
      float desty = getNodeByNodeNo(number).y;

      destLoc = new PVector(destx, desty);
      vel = PVector.sub(destLoc, groundLoc);
      float m = vel.mag();
      vel.setMag(min(m, velocity));
    } else if (changeDirCounter >= changeDirJugi) {
      changeDirCounter = -1;
    }
    PVector aniLoc =  PVector.add(groundLoc, vel);
    groundLoc.set(aniLoc);
    changeDirCounter++;
  }

  void framehop(float h) {
    float desty = saveBeforeHopLoc.y - h;
    groundLoc.y = desty;//lerp(groundLoc.y, desty, 0.5);
  }

  void awarewalk() { // same as idlewalk other than the lerp parameter
    //float destx = getNodeByNodeNo(number).x; 
    //float desty = getNodeByNodeNo(number).y;
    //float x = lerp(groundLoc.x, destx, 0.01);
    //float y = lerp(groundLoc.y, desty, 0.01);
    PVector aniLoc = groundLoc;
    groundLoc.set(aniLoc);
  }

  boolean hasArrived() {
    if (groundLoc.dist(destLoc) < 5) return true;
    else return false;
  }
  boolean hasArrived(float gijun) {
    if (groundLoc.dist(destLoc) < gijun) return true;
    else return false;
  }  
  boolean hasArrivedx(float gijun) {
    if (abs(groundLoc.x - destLoc.x) < gijun) return true;
    else return false;
  }  
  boolean hasArrivedy(float gijun) {
    if (abs(groundLoc.y - destLoc.y) < gijun) return true;
    else return false;
  }

  void arrangewalk() {
    float destx = arngX; 
    float desty = arngY;
    float x, y;
    if (!hasArrived(10)) {
      x = lerp(groundLoc.x, destx, 0.04);
      y = lerp(groundLoc.y, desty, 0.04);
    } else {
      x = lerp(groundLoc.x, destx, 0.4);
      y = lerp(groundLoc.y, desty, 0.4);
    }
    PVector aniLoc = new PVector(x, y);
    groundLoc.set(aniLoc);

    destLoc = new PVector(destx, desty);
    if (this.hasArrived(2)) {
      armfold(); 
      legfold();
    } else {
      armflap(arrangearmrange);
      legflap(arrangelegrange);
    }
  }

  void arrangewalk(float lerpSetting) {
    float destx = arngX; 
    float desty = arngY;
    float x = groundLoc.x, y = groundLoc.y;

    //if (!hasArrived(90)) {
    //  x = lerp(groundLoc.x, destx, lerpSetting*200/(20+abs(groundLoc.x - destx)));
    //  y = lerp(groundLoc.y, desty, lerpSetting*200/(20+abs(groundLoc.y - desty)));
    //} else if (!hasArrived(40)) {
    //  x = lerp(groundLoc.x, destx, lerpSetting*200/(10+abs(groundLoc.x - destx)));
    //  y = lerp(groundLoc.y, desty, lerpSetting*200/(10+abs(groundLoc.y - desty)));
    //} else if (!hasArrived(15)) {
    //  x = lerp(groundLoc.x, destx, lerpSetting*100/(5+abs(groundLoc.x - destx)));
    //  y = lerp(groundLoc.y, desty, lerpSetting*100/(5+abs(groundLoc.y - desty)));
    //} else {
    //  x = lerp(groundLoc.x, destx, 0.4);
    //  y = lerp(groundLoc.y, desty, 0.4);
    //}    
    if (!hasArrivedx(20)) {
      x = lerp(groundLoc.x, destx, lerpSetting*200/(20+abs(groundLoc.x - destx)));
    } else if (!hasArrivedy(40)) {
      y = lerp(groundLoc.y, desty, lerpSetting*200/(20+abs(groundLoc.y - desty)));
    } else if (!hasArrived(20)) {
      x = lerp(groundLoc.x, destx, lerpSetting*200/(10+abs(groundLoc.x - destx)));
      y = lerp(groundLoc.y, desty, lerpSetting*200/(10+abs(groundLoc.y - desty)));
    } else if (!hasArrived(15)) {
      x = lerp(groundLoc.x, destx, lerpSetting*100/(5+abs(groundLoc.x - destx)));
      y = lerp(groundLoc.y, desty, lerpSetting*100/(5+abs(groundLoc.y - desty)));
    } else {
      x = lerp(groundLoc.x, destx, 0.4);
      y = lerp(groundLoc.y, desty, 0.4);
    }
    PVector aniLoc = new PVector(x, y);
    groundLoc.set(aniLoc);

    destLoc = new PVector(destx, desty);
    if (this.hasArrived(2)) {
      armfold(); 
      legfold();
    } else {
      armflap(arrangearmrange);
      legflap(arrangelegrange);
    }
  }

  void chejo() {
    if (alertsys.pIO == false && alertsys.IO == true) {
      chejoframe = 1; 
      saveBeforeHopLoc.x = groundLoc.x;
      saveBeforeHopLoc.y = groundLoc.y;
    } 

    float protoheight;
    float hopheight;
    if (1<=chejoframe && chejoframe<=8) {
      protoheight = 25*amplitude*(1-sq(chejoframe-4)/16);
      hopheight = 2 * protoheight;
      //println(chejoframe);
      framehop(hopheight);
      float a = map(protoheight, 0, 25*max(amplitude, 0.00000001), 0, PI/2);
      if (alertsys.currentPhaseNo % 4 == 3) a *= 2;
      //else ;
      armflap(a+random(-.1, .2), 1);
      legflap(a/3+random(.05), 1);
    } else {
      hopheight = 0;
      armfold();
      legfold();
    }

    if (chejoframe > 0) chejoframe++;
    if (chejoframe > 8) chejoframe = 0;
  }

  void armflap(float range) { // default jugi = 6frames
    armAngle = lerp(armAngle, map(sin((armoffset+frameCount)*2*PI/6), -1, 1, 0, range), 0.75); //PI/3
  }  

  void armflap(float range, float jugi_in_frames) {
    armAngle = lerp(armAngle, map(sin((armoffset+frameCount)*2*PI/jugi_in_frames), -1, 1, 0, range), random(0.2, 0.5));
  }

  void armflap(float range, float jugi_in_frames, float anxiety) { // 'anxiety' = max armAngle offset during chojo in radian
    float timemapped = map(alertsys.frameCounter[alertsys.currentPhaseNo], 0, awareDaegi*frameRateSetting, 0, 1);
    float adding; 
    float jugi_dec;
    if (timemapped > 0.6 + random(-0.05, 0.1)) {
      jugi_dec = jugi_in_frames * (1.1 - sq(timemapped)); 
      adding = anxiety*sq(timemapped)*1.5;
      armAngle = lerp(armAngle, map(sin((armoffset*frameCount)*2*PI/jugi_dec), -1, 1, 0, range+adding), 0.5);
    } else {
      adding = 0; 
      jugi_dec = jugi_in_frames;
      armAngle = lerp(armAngle, map(sin((armoffset*frameCount)*2*PI/jugi_dec), -1, 1, 0, range+adding), 0.1);
    }
    //text(adding, 500, 10);
    //text(jugi_dec, 500, 20);
    //text(timemapped, 500, 30);
  }

  void armflap(float destA, int i_want_to_set_directly) { // directly set destAngle
    armAngle = lerp(armAngle, destA, 0.8);
  }

  void armfold() {
    armAngle = lerp(armAngle, 0, 0.05);
  }

  void legflap(float range) {
    legAngle = lerp(legAngle, map(sin((legoffset+frameCount)*2*PI/12), -1, 1, -PI/24, range), 0.75); //PI/6
  }

  void legflap(float destA, int select) {
    legAngle = lerp(legAngle, destA, 0.75);
  }

  void legfold() {
    legAngle = lerp(legAngle, 0, 0.05);
  }

  void display() {
    imageMode(CORNER);
    pushMatrix();
    float sc = 0.75;
    //scale(sc);
    //translate((1-sc)*groundLoc.x, (1-sc)*groundLoc.y);

    // groundLoc becomes new (0, 0);
    pushMatrix();
    translate(groundLoc.x, groundLoc.y); 
    // to draw shadow
    blendMode(MULTIPLY);
    fill(200);
    noStroke();
    if (1<=chejoframe && chejoframe<=8) {
      pushMatrix(); 
      translate(0, saveBeforeHopLoc.y - groundLoc.y);
      ellipse(0, -0.25*d, 1.2*d, 0.3*d);
      popMatrix();
    } else {
      ellipse(0, -0.25*d, 1.2*d, 0.3*d);
    }
    blendMode(BLEND);
    stroke(0);
    fill(255, 255, 0);
    // bodycenter becomes new (0, 0);
    pushMatrix();
    translate(0, -legl); 
    // to draw right leg
    pushMatrix();
    rotate(-legAngle); 
    scale(sc);
    //rect(0, 0, d/2, legl);
    image(leg, 0, 0, d/2, legl);

    popMatrix();
    // to draw left leg
    pushMatrix();
    scale(sc);
    rotate(legAngle); 
    //rect(-d/2, 0, d/2, legl);
    image(leg, -d/2, 0, d/2, legl);
    popMatrix();

    // to draw left arm 
    pushMatrix();
    scale(sc);
    translate(-d*2/4, -moml/*+d/4*/);
    rotate(armAngle);
    //rect(-d/4, 0, d/2, arml);//-d/4, -d/4, d/2, arml);
    image(arm, -d/4, 0, d/2, arml);
    popMatrix();
    // to draw right arm 
    pushMatrix();
    scale(sc);
    translate(d*2/4, -moml/*+d/4*/);
    rotate(-armAngle);
    //rect(-d/4, 0, d/2, arml); 
    image(arm, -d/4, 0, d/2, arml);
    popMatrix();

    // draw body and head over legs
    scale(sc);
    //rect(-d/2, -moml, d, moml); 
    image(body, -d/2, -moml, d, moml);
    //ellipse(0, -moml-d/2, d, d);
    image(head, -d/2, -moml-d, d, d);
    // reset the pushes
    popMatrix();
    popMatrix();

    // reset the Scale
    popMatrix();

    //    //DEBUG start
    //    fill(0);
    //    text(number, groundLoc.x, groundLoc.y-legl-moml-d/2);
    //    //DEBUG end
  }
}
