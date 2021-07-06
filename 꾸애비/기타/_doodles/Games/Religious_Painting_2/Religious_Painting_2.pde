boolean isIntro = true;
Player player;
ArrayList<Enemy> enemies;
ArrayList<Bullet> bullets;
float xshift = 0, yshift = 6;
float xint = 25, yint = 20, xoff, yoff;
float transX = 0, transY = 0, destTransX = 0, destTransY = 0;
float globd = 10;
float fenceY, swordY, truthY;
boolean truthIsFound = false, reachedWall = false, stageChanging = false;
int stageNo = 0;
int waitCounter = 0, scaleCounter = 0;
int waitTime = 500;
PImage img;
float sc;
int year;

void setup() {
  size(200, 300);
  noStroke();
  year = (int) random(32489, 284533);
  xoff = width/2;
  yoff = height/2 - 80;
  fenceY = height + 20;
  swordY = -100;
  truthY = height * 1.75;
  player = new Player();
  enemies = new ArrayList<Enemy>();
  for (int i = -3; i <= 3; i++) {
    for (int j = -2; j <= 2; j++) {
      enemies.add(new Enemy(i*xint + xoff, -j*yint + yoff, i, j)); // center = #17
    }
  }
  bullets = new ArrayList<Bullet>();

  //img = loadImage();
}

void draw() {

  println(stageChanging);
  if (isIntro) {
    showIntro();
  } else {
    background(25);

    player.checkArrested();
    player.checkSurrendered();
    if (dist(player.xpos, player.ypos, width/2, truthY) < 25 && player.hasSurrendered) {
      truthIsFound = true;
    }
    if (waitCounter == waitTime) {
      stageChanging = true;
    }
    // set camera
    if (stageChanging) {
      sc = map(scaleCounter, 0, 240, 1, 0.015);
      scaleCounter++;
      destTransX = width/2 - sc*enemies.get(17).xpos;
      destTransY = height-20 - sc*enemies.get(17).ypos;

      transX = lerp(transX, destTransX, 0.5);
      transY = lerp(transY, destTransY, 0.5);

      pushMatrix();
      translate(transX, transY);
      scale(sc);

      if (scaleCounter > 240) {
        stageChanging = false;
        waitCounter = 0;
        scaleCounter = 0;
        transX = 0;
        transY = 0;
        destTransX = 0;
        destTransY = 0;
        reset();
        year++;
      }
    } else {

      if (player.isArrested) {
        if (!player.hasSurrendered) {
          destTransY = height/2-enemies.get(17).ypos;
        } else {
          destTransY = height/2-player.ypos;
        }
      } else {
        if (player.hasSurrendered) {
          destTransY = height/2-player.ypos;
        } else {      
          destTransY = 0;
        }
      }
      if (player.reachedTop()) {
        destTransY = height/2;
      }
      transY = lerp(transY, destTransY, 0.05);
      pushMatrix();
      translate(0, transY);
    }
    if (truthIsFound) {
      println("truthIsFound "+truthIsFound);
      textSize(15);
      fill(255, 0, 0);
      textAlign(CENTER,CENTER);
      text("the truth is disclosed", width/2, truthY + 60);
      if (waitCounter < waitTime) {
        waitCounter++;
        println("waitCounter "+waitCounter);
      }
    } 

    // display all
    for (Enemy e : enemies) {
      e.display();
    }
    for (Bullet b : bullets) {
      if (b.done == false) {
        b.counter++;
        if ((b.counter < 48 || b.ypos > getMinY(enemies.size()) - random(30, 50))/* && b.ypos > height/2*/) {        
          b.move(0, -1);
        } else {
          enemies.add(new Enemy(b.xpos + random(-10, 10), b.ypos));
          b.done = true;
        }
        b.display();
      }
    }
    player.display();
    rectMode(CORNER);
    fill(69, 29, 38);
    if (!truthIsFound) rect(0, fenceY, width, 20);
    fill(255);
    rectMode(CENTER);
    rect(width/2, swordY, 20, 3);
    if (!truthIsFound) fill(196, 66, 43);
    else fill(255, 25, 25);
    ellipse(width/2, truthY, 50, 50);

    // move enemies every 10 frame
    if (frameCount % 10 == 0) {
      if (!truthIsFound) {
        if (getMaxY(enemies.size()) < height + 10) {
          for (Enemy e : enemies) {
            e.move(0, yshift);
          }
        } else {
          reachedWall = true;

          for (Enemy e : enemies) {
            e.move(random(-1, 1), random(-1, 1));
          }
        }
      } else {
        if (getMaxY(enemies.size()) < truthY + 20) {
          for (Enemy e : enemies) {
            e.move(0, yshift);
          }
        } else {
          for (Enemy e : enemies) {
            e.move(random(-1, 1), random(-1, 1));
          }
        }
      }
    }
    if (reachedWall) { 
      fill(255, 50, 50);
      textAlign(CENTER, CENTER);
      textSize(10);
      text("WE DEMAND YOU TO TELL THE TRUTH!\nOPEN THE DOOR!", width/2, height/2);
    }
    if (player.hasSurrendered) {
      fill(255, 50, 50);
      textSize(10);
      textAlign(CENTER, CENTER);
      text("you killed yourself to become \nthe KEY to the truth", width/2, swordY - 30);
    }
    popMatrix();
    fill(255);
    textAlign(RIGHT, BOTTOM);
    textSize(10);
    text("score: " + year, width, height);
  }
  //noFill();
  //stroke(255);
  //rectMode(CORNER);
  //rect(0, 0, width, height);

  moveNewBulletEnemies();

  if (1 <= scaleCounter && scaleCounter <= 241) {
    float c = map(scaleCounter, 0, 240, 0, 255);
    fill(c, c);
    noStroke();
    rectMode(CENTER);
    ellipse(width/2, height-20, 10, 10);
  }
}
