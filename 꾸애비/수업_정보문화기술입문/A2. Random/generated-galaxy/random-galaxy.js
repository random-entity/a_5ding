let body;
let galaxy;

function setup() {
  createCanvas(windowWidth, windowHeight);
  noStroke();
  background(0);

  body = new Body();
  galaxy = new Galaxy();

  push();
  translate(width/2, height/2);
  scale(1, -1)
  scale(2);

  blendMode(ADD);
  galaxy.display();

  pop();

  for (let i = 0; i < width; i++) {
    for (let j = 0; j < height; j++){
      let r = random();
      if(r < 0.0075 && brightness(get(i, j)) < 5) {
        blendMode(LIGHTEST);
        fill(random(255));
        let d = r * randomGaussian(330, 100);//random(100, 400);
        ellipse(i, j, d, d);
      }
    }
  }
  pixelate(1.5);
}

function pixelate(res) {
  for(let i = 0; i < width/res; i += 1) {
    for (let j = 0; j < height/res; j += 1) {
      rectMode(CORNER);
      noStroke();
      blendMode(BLEND);
      fill(get(i*res, j*res));
      rect(i*res, j*res, res, res);
    }
  }
}

class Body {
  constructor() {
    this.slope = random(-1, 1);
  }

  getYfromX(x) {
    return this.slope * x;
  }
}

class Droplet {
  constructor() {
    this.x = randomGaussian(0, 50);
    this.d = map(abs(this.x), 0, width/2, 3, 0.25);
    this.y = body.getYfromX(this.x) + randomGaussian(0, map(abs(this.x), 0, width/2, 10, 20));
  }

  display() {
    noStroke();
    fill(random(15), random(15), random(15), 50);
    ellipse(this.x, this.y, this.d, this.d);
  }
}

class Galaxy {
  constructor() {
    this.dropletArray = [];
    for(let i = 0; i < 100000; i++) {
      this.dropletArray.push(new Droplet());
    }
  }

  display() {
    for(let d of this.dropletArray) {
      d.display();
    }
  }
}

function draw() {
  noLoop();
}
