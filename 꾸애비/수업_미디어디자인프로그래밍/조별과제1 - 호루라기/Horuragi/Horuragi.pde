import processing.sound.*;

AudioIn in;
Amplitude amp;
int frameRateSetting = 24;
ArrayList<Kid> kidsArray = new ArrayList<Kid>();
ArrayList<Attractor> attractors = new ArrayList<Attractor>();
float ampThr = 0.2;
float amplitude;
AlertSystem alertsys = new AlertSystem();
float testMouseY;
int groupAll = 20;
PImage puppy;
PImage soccerball;
PImage background;
String[] stateLegend;
float idlearmrange = PI/3, idlelegrange = PI/6, arrangearmrange = PI/6, arrangelegrange = PI/12, slowjugi = 200;
int slowPeriod = 96;
float defaultLerp = 0.01;
float daegiTimeSaver = 0, awareDaegi = 3, arrangedDaegi = 3, chejoDaegi = 3, arrangingWhistleDuration = 1; // in seconds
boolean allArrived = false;
int allArriveTimer = 0;
int whether = 0;


void setup() {
  size(1080, 720, P2D);
  frameRate(frameRateSetting);
  stateLegend = new String[]{"idle", "aware", "arranged", "chejo"};
  puppy = loadImage("puppy.png");
  soccerball = loadImage("soccerball.png");
  background = loadImage("background.jpg");

  // Configure Sound things
  in = new AudioIn(this, 0);
  amp = new Amplitude(this);
  in.start();
  amp.input(in);

  // Create 100 Kids
  for (int i = 0; i < 100; i++) {
    kidsArray.add(new Kid(i));
  }

  // FORCE DIRECTED GRAPH setup Start
  //size(600, 600);
  smooth();
  //frameRate(30);
  f = createFont("Georgia", 12, true);

  // Initialize the physics
  physics = new VerletPhysics2D();
  physics.setWorldBounds(new Rect(0, 0, width, height));

  // Spawn a new random graph
  newGraph();
  // FORCE DIRECTED GRAPH setup Start

  //// Create Attractors
  //for (int i = 0; i < groupAll; i++) {
  //  attractors.add(new Attractor(i));
  //}
}

void draw() {

  physics.update();
  background(0, 180, 0);
  imageMode(CORNER);
  image(background, 0, 0, width, height);

  amplitude = amp.analyze();//map(mouseY, 0, height, 0, 1);//
  alertsys.update();

  // FORCE DIRECTED GRAPH Draw Start
  // Update the physics world
  //physics.update(); // moved to the top of Draw

  // background(255);

  // Display all points
  //if (showParticles) {
  //  for (int i = 0; i < clusters.size(); i++) {
  //    Cluster c = (Cluster) clusters.get(i);
  //    c.display();
  //  }
  //}

  //// If we want to see the physics
  //if (showPhysics) {
  //  for (int i = 0; i < clusters.size(); i++) {
  //    // Cluster internal connections
  //    Cluster ci = (Cluster) clusters.get(i);
  //    ci.showConnections();

  //    // Cluster connections to other clusters
  //    for (int j = i+1; j < clusters.size(); j++) {
  //      Cluster cj = (Cluster) clusters.get(j);
  //      ci.showConnections(cj);
  //    }
  //  }
  //}

  //// Instructions
  //fill(0);
  //textFont(f);
  //text("'p' to display or hide particles\n'c' to display or hide connections\n'n' for new graph", 10, 20);
  //// FORCE DIRECTED GRAPH Draw End


  //Kid tempKid = kidsArray.get(0);
  //text(tempKid.groundLoc.x, 200, 50);
  //text(tempKid.groundLoc.y, 200, 75);

  // MOVE THE KIDS
  //for (Kid k : kidsArray) {
  //  k.storeLoc();
  //}
  // if Idle state
  if (alertsys.alertState == 0) {
    for (Attractor g : attractors) {
      g.update();
    }
    for (Kid k : kidsArray) {
      k.armflap(idlearmrange, k.idleArmJugi);
      k.legflap(idlelegrange);
      float l = map(alertsys.frameCounter[alertsys.currentPhaseNo] - daegiTimeSaver*frameRateSetting, 0, slowPeriod, 0.001, defaultLerp);
      if (alertsys.frameCounter[alertsys.currentPhaseNo] - daegiTimeSaver*frameRateSetting < slowPeriod) k.idlewalk(l); 
      else k.idlewalk(defaultLerp);
     
     // Moving by velocity = Mangham.
     // k.idlewalk(true);
    }
    // if Aware state
  } else if (alertsys.alertState == 1) {
    for (Attractor g : attractors) {
      // Attractors also alerted k
    }
    for (Kid k : kidsArray) {
      k.awarewalk();

      if (alertsys.IO) {
        k.armfold();
        k.legfold();
      }
      if (!alertsys.IO) {
        k.armflap(idlearmrange/4, slowjugi+random(0.05), idlearmrange/4);
        k.legfold();
      }
    }

    // Reset Arrange Timer for use in state 2
    allArriveTimer = 0;
    whether = 0;
    // if Arrange state
  } else if (alertsys.alertState == 2) {
    // Check if all arrived
    Kid kt = kidsArray.get(0);
    allArrived = kt.hasArrived();
    for (Kid k : kidsArray) {
      //text(int(k.hasArrived()), 600, 20*k.number);
      allArrived = (allArrived && k.hasArrived());
    }
    //text(int(allArrived), 500, 20);

    if (!allArrived && !alertsys.IO) {
      allArriveTimer++;
    } 
    //text(alertsys.frameCounter[alertsys.currentPhaseNo] - allArriveTimer, 500, 60);

    if (alertsys.pIO != alertsys.IO) whether += 1;
    //text(whether, 500, 50);
    int timeSum = 0;
    for (int i = 0; i <= whether; i++) {
      timeSum += alertsys.frameCounter[alertsys.currentPhaseNo-i];
    }
    //text(timeSum, 500, 75);
    //if(timeSum > 50) {fill(255, 0, 0); rect(550, 10, 40, 40);}
    
    float l = min(0.02, map(timeSum, 0, slowPeriod/2, 0, defaultLerp));
    //pushMatrix();
    //scale(4);
    //text(l, 10, 10);
    //popMatrix();
    
    for (Kid k : kidsArray) {
      k.arrangewalk(1.5*l);
    }
    for (Attractor g : attractors) {
      g.update();
    }
    // if Chejo state
  } else {
    if (alertsys.chejoIsActive()) {
      for (Kid k : kidsArray) {
        k.chejo();
      }
    } else {
      for (Kid k : kidsArray) {
        k.arrangewalk();
      }
    }
  }
  //text(allArriveTimer, 500, 40);

  //for (Kid k : kidsArray) {
  //  PVector v = PVector.sub(k.groundLoc, k.pgroundLoc);
  //  k.velocity = v.mag();
  //  text(k.velocity, 500, k.number * 20);
  //  text(k.groundLoc.mag(), 600, k.number * 20);
  //  text(k.pgroundLoc.mag(), 700, k.number * 20);    
  //  text(k.groundLoc.mag()-k.pgroundLoc.mag(), 800, k.number * 20);
  //}

  // Store groundLoc's to use in the next frame
  //storeLoc();

  // Display anyway, in y order
  for (int yy = 0; yy <= height + 100; yy++) { 
    for (Kid k : kidsArray) {
      if (abs(k.groundLoc.y - yy) <= 0.5)
        k.display();
    }
    for (Attractor g : attractors) {
      if (abs(g.locv.y + 10 - yy) <= 0.5)
        g.display();
    }
  }

  // // DEBUG start 
  //  for (int i = 0; i < 100; i++) {
  //    Node n = getNodeByNodeNo(i);
  //    fill(255, 0, 0);
  //    text(i, n.x, n.y - 10);
  //  }
  //// DEBUG end

  // DEBUG start 
  // displays for testing AlertSystem 
  // println(alertsys.IO);
  pushMatrix();
  //scale(2);
  fill(amplitude*500, (1-amplitude)*256, 0);
  rect(20, 15, 10, -amplitude*15);
  if (alertsys.IO) {
    fill(255, 0, 0);
    ellipse(10, 10, 10, 10);
  } else {
    fill(0);    
    ellipse(10, 10, 10, 10);
  }
  popMatrix();

  //fill(0);
  ////text("Current Phase No = " + alertsys.currentPhaseNo, 5, 30);
  //text("Alert State = " + stateLegend[alertsys.alertState], 5, 45);
  //if (alertsys.alertState == 2 && allArrived) { 
  //  text("Arrange Complete", 5, 60);
  //} else text("Arrange Incomplete", 5, 60);

  ////for (int i = 0; i < 50; i++) {
  ////  if (i % 2 == 0)  fill(0);
  ////  else fill(255, 0, 0);
  ////  text("Phase" + i + " Started " + alertsys.phaseStartTimeRecord[i] + " Elapsed " + alertsys.frameCounter[i], 5, 75+15*i);
  ////} 

  //fill(0);
  //if (alertsys.chejoIsActive()) text("Chejo = Active", 5, 75);
  //else text("Chejo Inactive", 5, 75);

  //text("Amplitude = " + amplitude, 5, 90);
  // // DEBUG end
}
