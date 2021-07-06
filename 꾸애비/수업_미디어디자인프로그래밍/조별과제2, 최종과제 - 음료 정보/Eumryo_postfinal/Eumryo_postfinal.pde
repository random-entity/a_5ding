Table bevChart;
int chartSize;
Beverage[] bevArray;
Mode mode;
int maxPrice, maxKcal, maxSugars, maxNa, maxMl;
int minPrice, minKcal, minSugars, minNa, minMl;
int[] max = {0, 0, 0, 0, 0, 0};
int[] min = {0, 0, 0, 0, 0, 0};
int[] maxI = {0, 0, 0, 0, 0, 0};
int[] minI = {0, 0, 0, 0, 0, 0};
//for grid
int[] bigInterval = {0, 500, 50, 10, 50, 100};
int[] smallInterval = {0, 100, 10, 5, 10, 25};
Table headerIndex, inverseHeaderIndex;
TableRow headerRow, hangulRow, unitRow;
float mainw, mainh, rightPanelWidth;
int selectedBevIndex, focusBevIndex; //selected = mouse hover; focus = mouse click
boolean isFocusState;
float bevDispWidth;
float scale, scVel, camX, camY, camVx, camVy, mmx, mmy, camXsave, camYsave, scaleSave;
int margin1, photoH, margin2, margin3, margin4;
float minimapH, infoBoxH, axisBoxH;
Button[][] axisSelection;
CompareButton[][] compareModeSelection;
CompareMode compareMode;
PImage am;
PImage xy;
PImage rightPanel, mainbg, buttondef, buttondrop, minimapbg;
PImage[] whiteText = new PImage[6], blueText = new PImage[6];
Button defXb, defYb, dropXb, dropYb;
boolean dropX = false, dropY = false;
int minimapCounter = 0;
Button minimapB;

void setup() {
  physics = new VerletPhysics2D();
  physics.setWorldBounds(new Rect(0, 0, mainw, mainh));
  // setup the main display window and right panel
  size(1350, 850);
  smooth();
  frameRate(100);
  mainw = width;
  mainh = height;
  rightPanelWidth = width - mainw;
  bevDispWidth = 40; // photo width on the main display
  margin1 = 30;
  photoH = 300;
  margin2 = 20;
  minimapH = height - mainh;
  infoBoxH = margin1 + 300 + margin1;
  axisBoxH = height - minimapH - infoBoxH;
  margin3 = 20;
  margin4 = 20;
  //println(infoBoxH);
  //println(axisBoxH);
  //println(minimapH);
  //println(rightPanelWidth);  
  isFocusState = false;
  am = loadImage("alphaMap.png");
  xy = loadImage("xy.png");
  // initialize values
  frameRate(24);
  mode = new Mode(true/*default mode*/);
  compareMode = new CompareMode();

  // load images for panels and buttons
  rightPanel = loadImage("rightPanel.png");
  mainbg = loadImage("mainbg.png");
  buttondef = loadImage("button-default.png");
  buttondrop = loadImage("button-dropdown.png");
  minimapbg = loadImage("minimapbg.png");
  defYb = new Button(100, 63, 153, 69, -1);
  defXb = new Button(1235, 801, 153, 69, -1);
  dropYb = new Button(263, 166, 153, 275, -1);
  dropXb = new Button(1235, 617, 153, 275, -1);
  for (int i = 0; i < 6; i++) {
    whiteText[i] = loadImage(i+"whitetext.png");
    blueText[i] = loadImage(i+"bluetext.png");
  }
  minimapB = new Button(178.5, 718, 265, 202, -1);

  // load bevarage data and set array
  bevChart = loadTable("Eumryo_1202.csv", "header");
  chartSize = bevChart.getRowCount();
  bevArray = new Beverage[chartSize]; 
  constructBevArray(); //bevArray[0~chartSize-1]
  headerIndex = loadTable("HeaderIndex.csv");
  inverseHeaderIndex = loadTable("HeaderIndexInverse.csv", "header");
  headerRow = headerIndex.getRow(1);
  hangulRow = headerIndex.getRow(3);
  unitRow = headerIndex.getRow(4);
  selectedBevIndex = int(random(0, chartSize));

  // search the chart for max and min values
  for (int i = 1; i <= 5; i++) { // i = mode index
    max[i] = bevChart.getRow(0).getInt(i);
    min[i] = bevChart.getRow(0).getInt(i);
    for (int j = 1; j < chartSize; j++) { // j = Bev No.
      if (bevChart.getRow(j).getInt(i) > max[i]) {
        max[i] = bevChart.getRow(j).getInt(i); 
        maxI[i] = j;
      }
      if (bevChart.getRow(j).getInt(i) < min[i]) {
        min[i] = bevChart.getRow(j).getInt(i);
        minI[i] = j;
      }
    }
  }

  mode.xi = -1; 
  mode.yi = -1;
  axisSelection = new Button[2][6]; //Button[x or y][0~4, 5 is for returning to default mode] (thus j+1 needed to get right mode index)
  int[] blocxx = {1237, 1237, 1237, 1237, 1237, width};
  int[] blocxy = {518, 568, 618, 668, 718, height};
  int[] blocyx = {264, 264, 264, 264, 264, 0};
  int[] blocyy = {64, 113, 163, 212, 263, 0};
  for (int i = 0; i < 2; i++) {
    for (int j = 0; j < 6; j++) {
      float x, y;
      if (i == 0) {
        x = blocxx[j];
        y = blocxy[j];
      } else {
        x = blocyx[j];
        y = blocyy[j];
      }
      float w = 60;
      float h = 50;
      String s = hangulRow.getString(j) + " ";
      if (j != 5) {
        axisSelection[i][j] = new Button(x, y, w, h, j+1);
      } else {
        axisSelection[i][j] = new Button(x, y, w, h, -1);
      }
    }
  }
  compareModeSelection = new CompareButton[2][4];
  for (int i = 0; i < 2; i++) {
    for (int j = 0; j < 4; j++) {
      float x = margin4 + (rightPanelWidth - 2*margin4)*(2*j+3)/12;
      float y = margin3 + (axisBoxH - 2*margin3)*(4*i+3)/8;
      float w = (rightPanelWidth - 2*margin4)*2/12;
      float h = (axisBoxH - 2*margin3)*2/8;
      String s;
      if (j == 1) s = "보다 낮은";
      else if (j == 2) s = "보다 높은";
      else if (j == 3) s = "비슷한";
      else s = "취소";
      compareModeSelection[i][j] = new CompareButton(x, y, w, h, j, s, i, j);
    }
  }

  // pan and zoom
  camX = width/2;
  camY = height/2;
  scale = 1;
}

void draw() {
  physics.update();
  background(255);
  mode.update();
  // draw main display window
  //noStroke();
  //blendMode(BLEND);
  //fill(255);
  //rectMode(CORNER);
  //rect(0, 0, mainw, mainh);
  //color mainbgcol = color(36, 54, 76);
  //fill(color(mainbgcol));
  //rect(0, 0, mainw, mainh);
  imageMode(CORNER);
  image(mainbg, 0, 0);

  // set Camera
  setCamera();

  // draw main window
  displayMainWindow(); 
  // draw guides
  //displayGuide();
  displayGrid();
  displayAxes();
  // draw right panel
  displayRightPanels();
  // draw minimap
  displayMinimap();  
  runButtons();
  //displayBottomPanel();
}
//for (int i = 0; i < chartSize; i++) {
//  Beverage bi = bevArray[i];
//  rectMode(CENTER);
//  fill(255, 0, 0);
//  blendMode(ADD);
//  rect(bi.dispX, bi.dispY, bi.dispW, bi.dispH);
//}
