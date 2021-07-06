String Mugung = "무궁화 꽃이 피었습니다"; //"ABC DE FGHIJ"; //"MGH KI PUSND"
PFont font;
float startingX = 100;
float endingX;
Kid[] KidsArray = new Kid[12];
Sullae player;
int[] frameCounter = new int[12];

void setup() {
  size(1440, 700);
  frameRate(60);
  smooth();
  //String[] fontList = PFont.list();
  //printArray(fontList);
  font = createFont("AppleGothic", 50); // Set Korean Font!!!
  textAlign(CENTER, CENTER);
  noStroke();
  endingX = width - startingX * 3;
  player = new Sullae();
  for (int i = 0; i < KidsArray.length; i++) {
    KidsArray[i] = new Kid(i);
  }
}

void mousePressed() {
  for (Kid k : KidsArray) {
    k.reset();
  }
}

void draw() {
  background(255);
  stroke(0);
  line(startingX, 0, startingX, height);
  line(endingX, 0, endingX, height);
  textSize(15);
  text("마우스를 오른쪽 선 오른쪽에 두고 시작하세요. 마우스 클릭하면 리셋.", width/2, 10); // "Place mouse at the right side of the right line before starting. Click mouse to reset."

  player.update();
  player.display();

  int deadCount = 0;
  for (Kid k : KidsArray) {
    deadCount += k.isDead();
    if (deadCount == 12) {
      textSize(60);
      fill(255, 0, 0);
      text("내가 짱이다!!", width/2, height/4); // "Naega Jjangida!!!"
    } else if (k.isNearPlayer()) {
      k.textSize = constrain(k.textSize - 3, 1, 100);
      if (k.isDead() == 0) {
        k.displayScream();
      }
      if (player.isLookingBack()) {
        textSize(60);
        fill(255, 0, 0);
        text("반칙!", width/2, height/4); // "Banchik!"
      }
    }
  }


  if (! player.isLookingBack()) {
    for (Kid k : KidsArray) {
      // Set Direction of Kid not jumping
      if (k.frame == -1) {
        k.setDirection();
      }
      // initial 3 steps doljin
      if (k.jumpCounter <= k.initJumpNumber) {
        k.letterJumpNoWait();
      } else {
        // after first 3 steps, let probability decide whether to wait or not
        if (k.lottery < 0.6) {
          k.letterJump();
        } else {
          k.letterJumpNoWait();
        }
      }
      k.display();
    }
  } else {
    for (Kid k : KidsArray) {
      k.setJejari();
      k.mump();
      k.display();
      k.frameM++;
    }
  }
}
