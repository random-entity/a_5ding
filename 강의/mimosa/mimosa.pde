class leaf {
  // fields
  float pivotX, pivotY;
  float baseAngle;
  float rotation;
  float w, h;

  leaf(float px, float py) {
    pivotX = px;
    pivotY = py;
    baseAngle = 0;
    rotation = 0;
    w = 10;
    h = 20;
  }

  // methods
  void display() {
    noStroke();
    
    fill(255);
    ellipse(pivotX, pivotY, w, h);
    
    fill(255, 0, 0);
    ellipse(pivotX, pivotY, 4, 4);
  }
}

leaf[] leaves = new leaf[20];

void setup() {
  size(500, 500);
  
  for(int i = 0; i < leaves.length; i++) {
    leaves[i] = new leaf(width / 2, map(i, 0, leaves.length - 1, 20, height - 20));

    leaves[i].display();
  }
}

void draw() {
}

void mousePressed() {
}