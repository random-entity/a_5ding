let xpos = [];
let ypos = [];
let num = 500;

function setup() {
  // put setup code here
  createCanvas(400, 400);
  frameRate(1000);

  for(let i = 0; i < num; i++) {
    xpos[i] = -500;
    ypos[i] = -500;
  }
}

function draw() {
  // put drawing code here
  background(255);

  for(let i = num-1; i >= 1; i--) {
    xpos[i] = xpos[i-1];
    ypos[i] = ypos[i-1];
  }
  xpos[0] = mouseX;
  ypos[0] = mouseY;

  noStroke();

  for(let i = num-1; i >= 0; i--) {
    let r = map(i, 0, num-1, 0, 2*PI);
    // blendMode(ADD);
    fill(255*(1+sin(r))/2, 255*(1+cos(r))/2, max(min(tan(r), 255), 0));
    ellipse(xpos[i], ypos[i], 100*sin(2*r));
  }
}
