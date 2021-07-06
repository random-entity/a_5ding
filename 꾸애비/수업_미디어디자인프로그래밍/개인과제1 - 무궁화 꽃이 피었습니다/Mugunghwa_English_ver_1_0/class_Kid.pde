float jumpDistSetting = 50;
float jumpDistUpBound = 60; 
float jumpDistLowBound = 40;

class Kid {
  float x, y, direction, jumpDist;
  float destX, destY, aniPosX, aniPosY, jejariX, jejariY;
  int frame = -1, waitTime, frameM = 0, number, jumpCounter, initJumpNumber;
  char ch;
  int textSize;
  float lottery, range = 25;

  Kid(int i) {
    x = startingX / 2;
    y = map(i, -2, 13, 0, height);
    ch = Mugung.charAt(i);
    number = i;
    jumpDist = random(jumpDistSetting - 5, jumpDistSetting + 5);
    waitTime = int(random(10, 50));
    jumpCounter = 0;
    initJumpNumber = int(random(2, 6));
    textSize = 50;
  }

  void setDirection() {
    direction = random(-PI*0.3, PI*0.3);
    jumpDist = constrain(jumpDist + random(- 5, 5), jumpDistLowBound, jumpDistUpBound);
    frame++;
    // lottery value will determine wheter to wait or not in the next jump
    lottery = random(0, 1);
  }

  void letterJumpNoWait() {
    destX = x + jumpDist * cos(direction);
    destY = constrain(y + jumpDist * sin(direction), 30, height - 30);
    float frameRatio = map(frame, 0, 10, 0, 1);
    aniPosX = lerp(x, destX, frameRatio);
    aniPosY = lerp(y, destY, frameRatio) - 100 * frameRatio * (1 - frameRatio);
    frame++;
    if (frame == 10) {
      x = destX;
      y = destY; 
      jumpCounter++;
      frame = -1;
    }
  }

  void letterJump() {
    destX = x + jumpDist * cos(direction);
    destY = constrain(y + jumpDist * sin(direction), 30, height - 30);
    float frameRatio = map(frame, 0, 10, 0, 1);
    aniPosX = lerp(x, destX, frameRatio);
    aniPosY = lerp(y, destY, frameRatio) - 100 * frameRatio * (1 - frameRatio);
    if (frame <= 9) {      
      frame++;
      frameCounter[number] = frameCount;
      if (frame == 9) {
        jumpCounter++;
      }
    } else if (frame == 10) {
      if (frameCount - frameCounter[number] > waitTime) {
        frame++;
      } else {
        aniPosX = destX; 
        aniPosY = destY;
      }
    } else if (frame > 10) { // end of jump, set anchor x and y, frame = -1 (jumping = false)
      x = destX; 
      y = destY;
      frame = -1;
    }
  }

  void setJejari() {  // Set jejari for all kids, set middle character to center and align else
    if (number == 6) {
      jejariX = aniPosX;
      jejariY = aniPosY;
    } else {
      jejariX = map(number, 0, 11, KidsArray[6].x, KidsArray[0].x + width/4);
      jejariY = KidsArray[6].y + random(-1, 1);
    }
  }

  void mump() {
    // Initiate x, y
    x = aniPosX;
    y = aniPosY;
    float frameRatio = map(frameM, 0, 30, 0, 1);
    aniPosX = lerp(x, jejariX, frameRatio);
    aniPosY = lerp(y, jejariY, frameRatio) + 0.2 * sin(frameRatio * 4 * PI); // slight shaking
    if (frameM > 50) { // end of jump, set anchor x and y, frame = -1 (jumping = false)
      x = jejariX; 
      y = jejariY;
      frameM = 0;
    }
    frame = -1;
  }

  void display() {
    fill(0);
    textSize(textSize);
    text(ch, aniPosX, aniPosY);
  }

  void displayScream() {
    fill(0, 0, 255);
    textSize(textSize * 2);
    text("꺅!!", aniPosX, aniPosY - textSize * 3); // "Kkyak!!"
  }

  boolean isNearPlayer() {
    if (dist(x, y, player.x, player.y) < range) {
      return true;
    } else {
      return false;
    }
  }

  int isDead() {
    if (textSize == 1) return 1;
    else return 0;
  }

  void reset() {
    for (int i = 0; i < KidsArray.length; i++) {
      KidsArray[i] = new Kid(i);
    }
  }
}
