int uiio = 1;
ArrayList People;
Economy economy;
int initPop = 100;
int minute = 0;
int oneDay = 60*24;
float taxRate = 0.2;
float frameRateSetting = 60;

void birth() {
}
void death(Person corpse) {
}

float relationship(Person p, Person q) {
  return random(-10, 10);
}

class Person {
  // basic emotions, -10~10
  float[] e = {0, 0, 0, 0, 0, 0, 0}; //0joy, 1trust, 2fear, 3surprise, 4sadness, 5disgust, 6anger
  float happiness = 0;
  // person number
  int index;
  // playing(0) or working(1)
  int state = 0;
  // money (manwon)
  float money = max(randomGaussian(), 0) * 100000 + 100;
  // monthly salary
  float salary = max(randomGaussian(), 0) * 10000 + 100;
  // how successfully this person works
  float capacity = random(0.1, 0.9);
  // location
  int xpos, ypos;

  Person(int i) {
    index = i;
  }

  void updateHappiness() {
    happiness = e[0] + e[1] - e[2] - e[3] - e[4] - e[5] - e[6]; 
  }
  
  void sleep() { //alleviate all emotions
    for (int i = 0; i < 7; i++) {
      e[i] /= 2;
    }
  }

  void work() {
    if (random(1) < capacity) { // if work succeeds
      float value = random(100);
      economy.money += value;
      e[0]++;
      e[1]++;
      e[4]--;
    } else {
      e[0]--;
      e[1]++;
      e[4]--;
    }
  }

  void getPaid() { // once a month
    money += salary;
    economy.money -= salary;
  }

  void playAlone() {
    float cost = random(50000);
    money -= cost;
    economy.money += cost;
    for (int i = 0; i < 7; i++) {
      e[i] += random(-2, 2);
    }
  }

  void interact(Person other) {
  }

  void suicide() {
  }

  void kill() {
  }

  void love() {
  }

  void payTax() {
    int playTime = 0;
    if (playTime == 0) {
      float tax = money * taxRate;
      money -= tax;
      economy.money += tax;
    }
  }

  boolean mouseIsNear() {
    return false;
  }

  void withinRange() {
  }

  void display() {
  }
}

class Economy {
  int money;

  void socialContribution() {
  }

  void corrupt() {
  }
}

void setup() {
  size(800, 500);
  People = new ArrayList<Person>(initPop);
  frameRate(frameRateSetting);
}


void draw() {
  background(255);
  minute = (minute + 1) % (oneDay);

  ellipse(width/2, height/2, 10, 10);

  if (uiio == 1) {
    // Intro scene
    background(0);
    fill(255);
    textSize(50);
    textAlign(CENTER);
    text("metaethics", width/2, height/2);
    textSize(20);
    text("click to continue", width/2, height*0.75);
    // click to start
    if (mousePressed) {
      uiio = 0;
    }
  }
}
