class ShitCircle {
  constructor(x_, y_, d_){
    this.x = x_;
    this.y = y_;
    this.d = d_;
    this.c = color(random(255), random(255), random(255), random(100));
  }

   display() {
    noStroke();
    fill(this.c);
    ellipse(this.x, this.y, this.d);
  }

   move() {
    this.x += random(-1, 1) * random(5);
    this.y += random(-1, 1) * random(5);
  }

  mouseIsNear() {
    if(dist(mouseX, mouseY, this.x, this.y) < this.d/2) return true;
    else return false;
  }
}

let red;
let circleArray = [];

function overPara() {
  switch (namePara.onoff) {
    case 0:
    namePara.html("don't touch me");
    namePara.onoff = 1;
      break;
    case 1:
    namePara.html("ha!");
    namePara.onoff = 0;
      break;
    default:
  }
}

function clickInput() {
  red.c = color(random(255), random(255), random(255));
}

function setNameAgePara() {
    namePara.html(nameInput.value() + "? What a shitty name!");
    agePara.html(ageSlider.value() + "? You're old as fuck!");
}

function setup() {
  // put setup code here
  let canvas = createCanvas(400, 400);
  red = new ShitCircle(width/2, height/2, 50);
  namePara = createP("Ha! what a shitty name!");
  namePara.onoff = 0;
  namePara.mouseClicked(overPara);
  agePara = createP("How old are you?");
  nameInput = createInput("enter your shit");
  nameInput.mouseClicked(clickInput);
  nameInput.changed(setNameAgePara);
  createP();
  ageSlider = createSlider(0, 100, 20);
  ageSlider.changed(setNameAgePara);
  someElem = createElement("qq", "nono");

  for(let i = 0; i < 100; i++){
    let par = createP("SHIT!!!");
    par.position(random(500), 600 + random(500));
    par.class(".lottashit");
  }

  lottashitArray = selectAll(".lottashit");
  for(let i = 0; i < lottashitArray.length; i++) {
    lottashitArray[i].mouseOver(highlight);
    lottashitArray[i].mouseOut(unhighlight);
  }

  namePara.mouseOver(highlight);
  namePara.mouseOut(unhighlight);
}

function highlight() {
  this.style('backgound-color', '#F0F');
}
function unhighlight() {
  this.style("backgound-color", "#FFF");
}

function mousePressed() {
  // let newCircle = new ShitCircle(random(100), random(100), 50);
  // console.log(newCircle);
  circleArray.push(new ShitCircle(random(width), random(height), random(25, 50)));
  // circleArray.push(newCircle);
  // console.log(circleArray);
}

function draw() {
  // put drawing code here
  background(255);
  red.move();
  red.display();
  if(red.mouseIsNear()) {
    namePara.html("I SAID DON'T TOUCH ME!!!!!")
  }
  for(let c of circleArray){
    c.move();
    c.display();
  }
}
