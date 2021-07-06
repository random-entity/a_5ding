import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;

VerletPhysics2D physics;
Multi hongkong;
Vec2D mousePos;
AttractionBehavior2D mouseAttractor;

PImage cash;
int cutCount = 0; 
Bowl bowl;
float progRate; // how many noodles cut, 0 to 1, by which control background and fire
color backgrCol; 
PFont font;
String helpEnglish;
String helpKorean;
PImage honghap, bowlImg;

// Global Settings
float singleLength = 475; // avg length of each noodle
float singleLenRand = 20; // random amount for noodle lengths
int singleNumPoints = 60; // # of nodes for each noodle
float springStrength = 1; // tangletangle
int numColumnGlobal = 19; // how many noodles (PRIME NUMBER WANTED)
float marginGlobal = .25; // margin rate left/right of window
float particleD = 9; // noodle thickness
color col = color(250, 250, 0); // noodle color
float repulseR = particleD*1.2; // repulsion range between noodle nodes
float repulseStrength = -2.2; // repulsion strength between noodle nodes
float cashX, cashY, setCashX = 215; // set x size of cash image
int res = 100; // Mouse-Connection Collision Detection Resolution
float topY_G = 600, bottomY_G = 950, topWidth_G = 700; // Bowl Location
float topYA_G = 700, topWidthA_G = 400;
int bowlRes_G = 100; // Bowl Border Particle Resolution
float repulseRangeBowl = 30, repulseStrengthBowl = -.25; // Bowl Border Repulsion Range, Strength
float coreAttrStr = 1; // Bowl Core Attraction Strength
float logoRadius = 150;
PImage Logo;

// Settings for Fire and GM
FireControlSystem fcs;
PImage img; // alpha map
PImage imgInv; // alpha map Inversed
PVector fcsLoc;
GMControlSystem gmcs;
PVector gmcsLoc;

void setup() {
  size(500, 850, P2D);
  frameRate(24);
  rectMode(CENTER);
  font = createFont("Georgia", 32);
  helpEnglish = "click and drag to feel the noodles.\npress any key to grab 5000 won.\nclick and drag while pressing any key to cut noodles.\n\n\n\n\ncut above this line ------------------------------------------------\ntry cutting all the noodles";
  helpKorean = "클릭하고 드래그 = 면발을 느끼기.\n키 누르기 = 오천원 쥐기.\n키 누른 채로 클릭하고 드래그 = 면발 자르기.";
  textAlign(LEFT);

  honghap = loadImage("mussel_shell.png"); // HongHap PNG
  bowlImg = loadImage("Bowl.png");
  Logo = loadImage("HKBJLogo.png");

  physics = new VerletPhysics2D();
  physics.addBehavior(new GravityBehavior2D(new Vec2D(0, .5)));
  physics.setWorldBounds(new Rect((width - bowlImg.width)/2, 0, bowlImg.width, height));//new Rect(-2*width, 0, 3*width, height));

  hongkong = new Multi(numColumnGlobal, marginGlobal);
  bowl = new Bowl(topY_G, bottomY_G, topWidth_G, bowlRes_G, topYA_G, topWidthA_G);
  cash = loadImage("ocheon.png");
  cashX = cash.width;
  cashY = cash.height;
  imageMode(CENTER);


  img = loadImage("alphaMap.png"); // Fire alpha mask png
  imgInv = loadImage("alphaMapInv.png");

  fcsLoc= new PVector(width/2, height - bowlImg.height); // origin of fire
  fcs = new FireControlSystem(fcsLoc);

  gmcsLoc = new PVector(width/2, height/3.5);
  gmcs = new GMControlSystem(gmcsLoc);
}

void draw() {
  physics.update();

  progRate = float(hongkong.howManyCut())/(numColumnGlobal);
  backgrCol = color(map(progRate, 0, 1, 5, 180), map(progRate, 0, 1, 0, 50), map(progRate, 0, 1, 0, 50)); //color(map(progRate, 0, 1, 150, 5), map(progRate, 0, 1, 25, 0), map(progRate, 0, 1, 25, 0));; 
  background(backgrCol);

  // display order important
  gmcs.runFire();
  fcs.runFire();
  // always reset tint after using
  tint(255);

  // draw matrix Multi hongkong
  hongkong.display();

  if (keyPressed && ((key != 'q') && key != 'Q')) {
    imageMode(CENTER);
    image(cash, mouseX, mouseY, setCashX*(1-progRate), setCashX*(cashY/cashX)*(1-progRate));
    if (mousePressed) { // if both key and mouse pressed cut noodles touched
      for (Single s : hongkong.matrix) {
        for (int i = 0; i <= numColumnGlobal - 2; i++) {
          if (s.springs_[i].mouseTouchedConnection()) {
            physics.removeSpring(s.springs_[i]);
          }
        }
      }
    }
  }

  bowl.updateAlt();
  tint(255);
  bowl.display();

  fill(255);
  text("Press 'Q' to see help", 5, 20);
  if (keyPressed) {
    if (key == 'q' || key == 'Q') {
      text(helpEnglish, 5, 40);
      //text(helpKorean, 5, 150);
    }
  }
}

void mousePressed() {
  mousePos = new Vec2D(mouseX, mouseY);

  //if (!keyPressed) {
  // create a new positive attraction force field around the mouse position (radius=250px)
  mouseAttractor = new AttractionBehavior2D(mousePos, 75, -2);
  physics.addBehavior(mouseAttractor);
  //}
}

void mouseDragged() {
  // update mouse attraction focal point
  mousePos.set(mouseX, mouseY);
}

void mouseReleased() {
  // remove the mouse attraction when button has been released
  physics.removeBehavior(mouseAttractor);
}
