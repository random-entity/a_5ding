PFont font;
Me MainCh = new Me();
Mine[] MineField = new Mine[10];
int mineDispSize = 30;

void setup() {
  size(800, 800);
  font = createFont("AppleMyungjo", 50);
  for (int i = 0; i < MineField.length; i++) {
    MineField[i] = new Mine();
  }
  //String[] fontList = PFont.list();
  //printArray(fontList);
}

void draw() {
  background(255);
  textSize(100);
  fill(0);
  MainCh.update();
  MainCh.display();
  for (Mine m : MineField) {
    m.tempDisplay();
    if (m.isActivated()) {
      m.display(mineDispSize);
      mineDispSize += 10;
      if (mineDispSize > 300) {
        mineDispSize = 30;
      }
    }
  }
}

class Me {
  float x, y, r;

  Me() {
    x = width/2; 
    y = height/2; 
    r = 50;
  }

  void update() { 
    x = mouseX; 
    y = mouseY;
  }

  void display() {
    textAlign(CENTER, CENTER);
    textSize(30);
    text("나", x, y);
  }
}

class Mine {
  float x, y, r;

  Mine() {
    x = random(10, width - 10);
    y = random(10, height - 10);
    r = 10;
  }

  boolean isActivated() {
    if (dist(MainCh.x, MainCh.y, x, y) < MainCh.r + r) {
      return true;
    } else {
      return false;
    }
  }

  void display(float dispSize) {
    textAlign(CENTER, CENTER);
    textSize(dispSize);
    text("펑", x, y);
  }

  void tempDisplay() {
    fill(255, 0, 0);
    ellipse(x, y, 5, 5);
  }

  class Window {
  }
}
