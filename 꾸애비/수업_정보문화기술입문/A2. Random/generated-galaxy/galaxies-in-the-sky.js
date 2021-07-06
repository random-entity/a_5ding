// let body;
// let scene;
//
// function setup() {
//   createCanvas(windowWidth, windowHeight);
//   noStroke();
//   blendMode(ADD);
//
//   body = new Body();
//   scene = new Scene();
//
//   background(0);
//   push();
//   translate(width/2, height/2);
//   scale(1, -1)
//
//   scene.display();
//
//   pop();
// }
//
// class Body {
//   constructor() {
//     this.slope = 0;//random(-1, 1);
//   }
//
//   getYfromX(x) {
//     return this.slope * x;
//   }
// }
//
// class Droplet {
//   constructor(ysdi, ysdf) {
//     this.x = randomGaussian(0, 50);
//     this.d = map(abs(this.x), 0, width/2, 7, 1);
//     this.y = body.getYfromX(this.x) + randomGaussian(0, map(abs(this.x), 0, width/2, ysdi, ysdf));
//   }
//
//   display() {
//     noStroke();
//     fill(random(15), random(15), random(15), 50);
//     ellipse(this.x, this.y, this.d);
//   }
// }
//
// class Galaxy {
//   constructor() {
//     this.sceneX = random(width) * random(-1, 1);
//     this.sceneY = random(height) * random(-1, 1);
//     this.sceneTheta = random(2*PI);
//     this.sceneScale = random(0.25, 0.75);
//
//     this.dropletArray = [];
//     let a = random(5, 20), b = random(15, 25);
//     for(let i = 0; i < 20000; i++) {
//       this.dropletArray.push(new Droplet(a, b));
//     }
//   }
//
//   display() {
//     for(let d of this.dropletArray) {
//       d.display();
//     }
//   }
// }
//
// class Scene {
//   constructor() {
//     this.scene = []
//     for(let i = 0; i < 15; i++){
//       this.scene.push(new Galaxy());
//     }
//   }
//
//   display() {
//     for(let gal of this.scene) {
//       push();
//       translate(gal.sceneX, gal.sceneY);
//       rotate(gal.sceneTheta);
//       scale(gal.sceneScale);
//       gal.display();
//       pop();
//     }
//   }
// }
//
// function draw() {
//
// }
