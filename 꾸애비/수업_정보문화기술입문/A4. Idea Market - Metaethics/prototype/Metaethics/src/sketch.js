let systems = [];
let realSystem;
let initPopulation = 30;
let population = initPopulation;
let accumPopulation = [population, population, population];
let economy;

let actionIndexList = [1, 2, 11, 12, 13, 14, 15, 16, 17, 18];

let time = 1;
let timeInDay = 1;
let frameInterval = 1;

let mobility = 50;
let socialRange = 200;

let newsAccum = 0;

let empathy = 5;
let jealousy = 50;
let naturalVsEthicalRate = 0.25; // chance of being ethical. 0 all natural, 1 all ethical

let weightEmotion = 0.2;
let weightMentalHealth = 0.2;
let weightMoney = 0.2;
let weightRelationships = 0.2;
let weightFreedom = 0.2;

function setup() {
  createCanvas(800, 500);
  realSystem = new System(0);
  economy = new Economy(); // give up making systems for economies (to prevent imaginations affecting the real economy) economies[0], economies[1]만 분리해도 될 거 같긴 한데 일단 보류
  // noLoop();
}

// GET PERSON PROPERTIES
function mentalState(p) {
  if(p.mentalHealth > 0.9) {
    return "mania";
  } else if (p.mentalHealth < 0.1) {
    return "depression";
  } else {
    return "normal";
  }
}

function relationState(p, q) {
  let i = p.relationships[q.index];
  let u = q.relationships[p.index];
  if(i > 0.75) {
    if(u > 0.75) {
      return "romance";
    } else {
      return "heartbreak";
    }
  } else if(i > -0.25) {
    return "favor";
  } else if(i > -0.5) {
    return "hate";
  } else if(i > -0.9){
    return "resentment";
  } else {
    return "murderous intent";
  }
}

// UTILITIES
function distance(p, q) {
  return dist(p.xpos, p.ypos, q.xpos, q.ypos);
}

function indexInArray(p) {
  // find person's location in people array
  let where = 0;
  let found = false;
  for(let i = 0; i < p.parentSystem.people.length; i++) {
    if(p.parentSystem.people[i] != p) {
      where++;
    } else {
      found = true;
      break;
    }
  }
    if(found) {
      return where;
    } else {
      return -1;
    }
}

function findRealPersonLocInSysArrayByPersonIndex(p, sys) {
  let ind = p.index;
  let loc = 0;
  for(let i = 0; i < sys.people.length; i++){
    if(sys.people[i].index != ind) {
      loc++;
    } else {
      break;
    }
  }
  return loc;
}

function updatePopulation() {
  population = realSystem.people.length;
}

function sigmoid(x) {
  return 1/(1 + exp(-x));
}

function normalizeAll(n) {
  for(p of systems[n].people) {
    p.normalize();
  }
}

// GRAPHICS
function news(sysInd, bg, f, ts, txt) {
  if(sysInd == 0) {
    newsAccum++;
    background(bg);
    fill(f);
    textSize(ts);
    textAlign(CENTER, CENTER);
    text("news #" + newsAccum + ": \n" + txt, width/2, height/2);
    console.log(txt);
  }
}

function displayRelations() {
  for(p of realSystem.people) {
    for(q of realSystem.people) {
      if(p != q) {
        stroke(127);
        strokeWeight(0.1);
        line(p.xpos, p.ypos, q.xpos, q.ypos);
        textAlign(CENTER, CENTER);
        textSize(10);
        text(relationState(p, q), p.xpos*2/3+q.xpos*1/3, p.ypos*2/3+q.ypos*1/3);
      }
    }
  }
}

// POPULATION CHANGES
function birth(p, q) {
  accumPopulation[p.parentSystemIndex]++;
  r = new Person(accumPopulation[p.parentSystemIndex], p.parentSystemIndex);
  // inherit money from parents
  r.money += (p.money * 1/3 + q.money * 1/3);
  p.money *= 2/3;
  q.money *= 2/3;
  p.parentSystem.people.push(r);
  for(s of p.parentSystem.people) {
    s.relationships[r.index] = random(0.25, 0.75);
  }
  p.parentSystem.people.push(r);
  news(p.parentSystemIndex, color(0, 255, 0), color(0), 60, r.index + " is born from " + p.index + " and " + q.index + ".");
}

function death(p) {
  p.parentSystem.people.splice(indexInArray(p), 1);
  // separate NEWS for each death cause
}

// ACTIONS
// *Normalize at the end of the routine method that called action: beAlone(), interactWith(), sleep(), work()
// ACTIONS FROM beAlone() (called by beAlone() in Person class): suicide, play, mutate
function play(p) {
  let maxCost = max(randomGaussian(p.money/30, p.money/60), 0);
  let cost = random(maxCost);
  let whether;
  this.money -= cost;
  economy.money += cost;
  if(random() < 0.75) { // if healing succeeds
    this.emotion += cost;
    this.mentalHealth--;
    whether = "succeeded";
  } else { // if healing fails
    this.emotion--;
    this.mentalHealth--;
    whether = "failed";
  }
  console.log(p.index + " played alone and " + whether + ".");
}

function suicide(p) { // how can suicide be ethical utilitarianically? remove the big negative happiness from the socical-sum
  death(p);
  // what will be the reactions?
  news(p.parentSystemIndex, color(200, 0, 50), color(255), 60, p.index + " committed suicide.", width/2, height/2);
}

function mutate(p) { // generate madness
  let r = random();
  if(r < 0.05){
    p.mentalHealth = -100;
    news(p.parentSystemIndex, color(0), color(255), 60, p.index + " became depressed.", width/2, height/2);
  } else if (r < 0.1) {
    p.emotion += 100;
    news(p.parentSystemIndex, color(0), color(255), 60, p.index + " became maniac.", width/2, height/2);
  } else if (r < 0.15) {
    p.emotion -= 100;
  } else if (r < 0.2) {
    for(other of realSystem.people) {
      if(other != p) {
        p.relationships[other.index] = -100;
        news(p.parentSystemIndex, color(0), color(255), 60, p.index + " became mad.", width/2, height/2);
      }
    }
  }
}

// ACTIONS FROM interactWith(other) (called by interactWith() in Person class) :
function kill(p, q) {
  p.emotion += 5;
  p.mentalHealth -= (5 + p.relationships[q.index]);
  p.relationships[q.index] += random(-2, 2);
  p.money += max(q.money, 0);
  q.money = min(q.money, 0);
  news(p.parentSystemIndex, color(200,0,0), color(255), 60, p.index + " killed " + q.index + "\nand robbed $" + (max(q.money, 0)).toFixed(2) + ".");
  death(q);
  // others react
  for(r of p.parentSystem.people) {
    if(r != p) {
      r.relationships[p.index] = -10;
    }
  }
}

function violence(p, q) {
  p.emotion += 2.5;
  p.mentalHealth -= (3 + p.relationships[q.index]*2);
  p.relationships[q.index] += random(-2, 2);
  p.money += max(q.money, 0)/2;
  news(p.parentSystemIndex, color(127,25,0), color(255), 60, p.index + " committed violence to " + q.index + "\nand robbed $" + (max(q.money, 0)/2).toFixed(2) + ".");
  q.emotion -= 5;
  q.mentalHealth -= 7.5;
  q.relationships[p.index] -= 10;
  q.money -= max(q.money, 0)/2;
  // others react
  for(r of p.parentSystem.people) {
    if(r != p && r != q) {
      r.relationships[p.index] -= 5;
      r.relationships[q.index] += (empathy * random(-0.5, 1.5));
    }
  }
}

function fight(p, q) {
  p.emotion += 1;
  p.mentalHealth--;
  p.relationships[q.index] += random(-1, 1);
  q.emotion -= 2;
  q.mentalHealth--;
  q.relationships[p.index] -= 2;
  news(p.parentSystemIndex, color(235, 116, 5), color(0), 60, p.index + " fought with " + q.index + ".");
  // others react
  for(r of p.parentSystem.people) {
    if(r != p && r != q) {
      r.relationships[p.index] -= 1;
      r.relationships[q.index] -= 10;
    }
  }
}

function solitude(p, q) {
  p.emotion -= 0.5;
  p.mentalHealth -= 0.5;
  p.relationships[q.index] += random(-0.5, 0.5);
  q.relationships[p.index] += random(-0.5, 0.5);
  news(p.parentSystemIndex, color(38, 61, 89), color(0), 60, p.index + " felt lonely because of " + q.index + ".");
}

function friendship(p, q) {
  if(p.index > q.index) { // no redundance for mutual action
    p.emotion += 0.5;
    p.mentalHealth += 0.5;
    p.relationships[q.index] += random(-0.5, 2.5);
    p.money -= 1;
    q.emotion += 0.5;
    q.mentalHealth += 0.5;
    q.relationships[p.index] += random(-0.5, 2.5);
    q.money -= 1;
    economy.money += 2;
    news(p.parentSystemIndex, color(255,255,0), color(0), 60, p.index + " had a good time with " + q.index + ".");
    // others react
    for(r of p.parentSystem.people) {
      if(r != p && r != q) {
        r.relationships[p.index] += 0.5;
        r.relationships[q.index] += 0.5;
      }
    }
  }
}

function generosity(p, q) {
  let cost = random(max(p.money, 0)/10);
  p.money -= cost;
  q.emotion += 5;
  q.mentalHealth += 1;
  q.relationships[p.index] += 5;
  q.money += cost;
  news(p.parentSystemIndex, color(0,255,255), color(0), 60, p.index + " donated $" + cost.toFixed(2) + " to " + q.index + ".");
  // others react
  for(r of p.parentSystem.people) {
    if(r != p && r != q) {
      r.relationships[p.index] += 2.5;
      r.relationships[q.index] -= (jealousy * random(-0.5, 5));
    }
  }
}

function love(p, q) {
  if(relationState(p, q) == "romance") {
    if(p.index > q.index) { // no redundance for mutual action
      p.emotion += 5;
      p.mentalHealth += 5;
      p.relationships[q.index] += (5 + random(-7, 5));
      p.money -= 5;
      q.emotion += 5;
      q.mentalHealth += 5;
      q.relationships[p.index] += (5 + random(-7, 5));
      q.money -= 5;
      economy.money += 10;
      news(p.parentSystemIndex, color(222, 102, 156), color(0), 60, p.index + " made love with " + q.index + ".");
      if(random() < 0.1) { // 10% make baby
        birth(p, q);
      }
    }
  } else {
    p.emotion += 5;
    p.mentalHealth -= 5;
    p.relationships[q.index] += (random(-10, 5));
    p.money -= 5;
    q.emotion -= 5;
    q.mentalHealth -= 5;
    q.relationships[p.index] += (5 + random(-20, 5));
    q.money -= 5;
    economy.money += 10;
    news(p.parentSystemIndex, color(41, 6, 74), color(255), 60, p.index + " failed to date " + q.index + ".");
    // no rapes in this world please
  }
  // others react
  for(r of p.parentSystem.people) {
    if(r != p && r != q) {
      r.relationships[p.index] -= (jealousy * random(1.5));
      r.relationships[q.index] -= (jealousy * random(1.5));
    }
  }
}

function heartbreak(p, q) {
  p.emotion -= 5;
  p.mentalHealth -= 7.5;
  p.relationships[q.index] += random(-0.5, 0.5);
  q.relationships[p.index] += random(-1, 1);
  news(p.parentSystemIndex, color(56, 1, 1), color(255), 60, p.index + " is heartbroken by " + q.index + ".");
  // others react
  for(r of p.parentSystem.people) {
    if(r != p && r != q) {
      r.relationships[p.index] += (empathy * random(0.5));
      r.relationships[q.index] -= (jealousy * random(1));
    }
  }
}

function affair(p, q, r) { // call condition: relationState(p,q) == "romance" && relationState(p, r) == "romance"
  if(random() < 0.95) { // chance of being caught
    p.emotion -= 5;
    q.emotion -= 10;
    q.mentalHealth -= 10;
    q.relationships[p.index] = -1;
    q.relationships[r.index] = -1;
    r.emotion -= 10;
    r.mentalHealth -= 10;
    r.relationships[p.index] = -1;
    r.relationships[q.index] = -1;
    news(p.parentSystemIndex, color(75, 92, 128), color(255), 60, p.index + " got caught cheating " + q.index + " and " + r.index + ".");
    // others react
    for(s of p.parentSystem.people) {
      if(s != p && s != q && s!= r) {
        s.relationships[p.index] -= (jealousy * random(2));
        s.relationships[q.index] += (empathy * random(1));
        s.relationships[r.index] += (empathy * random(1));
      }
    }
  }
}

// DECISION MAKING
function predictHappiness(p, q, actionIndex) { // What will happen if p action(i) to q?
  cloneSystem = new System(1);
  cloneSystem.cloneFromReal();
  // get location of p, q in cloned array
  let pci = findRealPersonLocInSysArrayByPersonIndex(p, cloneSystem);
  let qci = findRealPersonLocInSysArrayByPersonIndex(q, cloneSystem);
  // console.log("cloneSys", cloneSystem, pci, qci, "pclone", cloneSystem.people[pci], "qclone", cloneSystem.people[qci]);
  cloneSystem.people[pci].actionByIndex(actionIndex, cloneSystem.people[qci]);
  return cloneSystem.getTotalHappiness();
  systems.splice(1, 1);

}

function getEthicalActionIndex(p, solOrInter, q) { // what is the most ethical action to act on q? or alone(in case of "solitary")
  let h = Number.NEGATIVE_INFINITY;
  let e = -1;
  for(i of actionIndexList) {
    if(solOrInter == "Interactive") {
      if(i >= 11) {
        let prediction = predictHappiness(p, q, i);
        if(prediction > h) {
          h = prediction;
          e = i;
        }
        // console.log("p", p, "q", q, "i", i, "pred", prediction, "h", h);
      }
    } else if(solOrInter == "Solitary") {
      if(i <= 10) {
        let prediction = predictHappiness(p, p, i);
        if(prediction > h) {
          h = prediction;
          e = i;
        }
      }
    }
  }
  return e;
}

//CLASSES: System, Person, Economy
class System {
  constructor(n) {
    this.people = [];
    this.systemIndex = n;
    systems[n] = this;
    for(let i = 0; i < population; i++) {
      this.people.push(new Person(i, n));
    }
  }

  cloneFromReal() {
    this.people = [];
    for(let i = 0; i < realSystem.people.length; i++) {
      let pi = realSystem.people[i];
      let p = new Person(i);
      p.parentSystemIndex = this.systemIndex;
      p.parentSystem = systems[this.systemIndex];
      p.emotion = pi.emotion;
      p.mentalHealth = pi.mentalHealth;
      p.relationships = [];
      for(let j = 0; j < accumPopulation[0]; j++) {
        p.relationships.push(pi.relationships[j]);
      }
      p.relationHealth = pi.relationHealth;
      p.money = pi.money;
      p.salary = pi.salary;
      p.capacity = pi.capacity;
      p.xpos = pi.xpos;
      p.ypos = pi.ypos;
      p.desiredAction = pi.desiredAction ;
      p.currentAction = pi.currentAction;
      p.freedomAccum = pi.freedomAccum;
      p.freedom = pi.freedom;
      p.index = pi.index;
      p.lovers = pi.lovers;
      p.happiness = pi.happiness;

      this.people[i] = p;

      // this.people.push(realSystem.people[i]);
      // this.people[i].parentSystemIndex = this.systemIndex;
      // this.people[i].parentSystem = this;
    }
  }

  getTotalHappiness() {
    let s = 0;
    for(let i = 0; i < this.people.length; i++){
      this.people[i].update();
      s += this.people[i].happiness;
    }
    return s;
  }

  run(hour) {

  }
}

class Person {
  constructor(i, n) {
    this.parentSystemIndex = n;
    this.parentSystem = systems[n];
    this.emotion = 0.5; // short term pleasure
    this.mentalHealth = 0.5; // long term mental health
    this.relationships = []; // +1 max love, -1 max hate
    for(let i = 0; i < accumPopulation[systems[n]]; i++) { // natural preferences
      this.relationships[i] = random(0.25, 0.75);
    }
    this.relationHealth = 0.5;
    this.money = max(randomGaussian(100, 50), 1);
    this.salary = max(randomGaussian(1, 0.5), 0.01); // monthly pay
    this.capacity = random(0.1, 0.9); // chance to succeed work
    this.xpos = random(width);
    this.ypos = random(height);
    this.desiredAction = 0;
    this.currentAction = 0;
    this.freedomAccum = 0;
    this.freedom = 0;
    this.index = i;
    this.lovers = [];

    this.happiness = 0;
  }

  display() {
    fill(0);
    noStroke();
    ellipse(this.xpos, this.ypos, 5);
    textSize(10);
    textAlign(LEFT, CENTER);
    text(this.index, this.xpos, this.ypos - 20);
    text(mentalState(this), this.xpos, this.ypos - 10)
    text("EMO" + this.emotion.toFixed(3), this.xpos, this.ypos);
    text("MH" + this.mentalHealth.toFixed(3), this.xpos, this.ypos + 10);
    text("RH" + this.relationHealth.toFixed(3), this.xpos, this.ypos + 20);
    text("$" + this.money.toFixed(3), this.xpos, this.ypos + 30);
    text("FREE" + this.freedom.toFixed(3), this.xpos, this.ypos + 40);
  }

  // UPDATE STATUS
  updateHappiness() {
    // happiness = weighted sum
    this.happiness = weightEmotion * this.emotion
    + weightMentalHealth * this.mentalHealth
    + weightRelationships * this.relationHealth
    + weightMoney * sigmoid(this.money)
    + weightFreedom * this.freedom;
  }

  updateEmotion() {
    if(this.money < 0) { // if broke
      this.emotion -= 10;
    } else if(this.money < 10) {
      this.emotion -= (10-this.money);
    }
  }

  updateMH() {
    if(this.emotion < -0.9 || this.emotion > 0.9) {
      this.mentalHealth += this.emotion;
    }
  }

  updateRH() {
    // set relational health
    this.relationHealth = 0;
    for(let i = 0; i < population; i++) {
      this.relationHealth += this.relationships[i];
    }
    this.relationHealth /= max(population - 1, 1);
  }

  updateFreedom() {
    if(this.desiredAction != this.currentAction) {
      this.freedomAccum++;
    }
    this.freedom = this.freedomAccum / time;
  }

  update() {
    this.updateEmotion();
    this.updateMH();
    this.updateRH();
    this.updateFreedom();
    // this.normalize();
    this.updateHappiness();
  }

  normalize() {
    this.emotion = sigmoid(this.emotion);
    this.mentalHealth = sigmoid(this.mentalHealth);
    for(let i = 0; i < this.relationships.length; i++) {
      this.relationships[i] = sigmoid(this.relationships[i]);
    }
    this.relationHealth = sigmoid(this.relationHealth);
    this.freedom = sigmoid(this.freedom);
  }

  // PHYSICAL ACTIONS
  move(step) {
    let x = floor(random(-step, step));
    let y = floor(random(-step, step));
    this.xpos += x;
    this.ypos += y;

    if(this.xpos < 0) {
      this.xpos = 0;
    } else if(this.xpos > width) {
      this.xpos = width;
    }
    if(this.ypos < 0) {
      this.ypos = 0;
    } else if(this.ypos > height) {
      this.ypos = height;
    }
  }

  // ECONOMIC ACTIONS
  work() {
    if(random() < this.capacity) { // if this person succeeds
      economy.money++;
      this.emotion += 0.1;
    } else {
      this.emotion -= 0.1;
    }
    this.normalize();
  }

  getPaid() {
    this.money += this.salary;
  }

  // SOLITARY ACTIONS
  sleep() {
    if(random() < 0.01) {
      mutate(this);
    }
    this.emotion /= 2;
    if(realSystem.people.length > 50){
      this.mentalHealth -= 2;
    }
    // this.normalize();
  }

  naturalSolitaryAction() {
    if(this.mentalHealth < -0.9) {
      if(random() < 0.25) {
        suicide(this);
      }
    } else {
      play(this);
    }
  }

  ethicalSolitaryAction() {
  }

  beAlone() {

    this.normalize()
  }

  // SOCIAL ACTIONS
  naturalInteraction(other) {
    let e = this.getNaturalActionIndex(other);
    console.log("natural interaction decided: ", this.index, other.index, e);
    this.actionByIndex(e, other);
    // let r = relationState(this, other);
    // if (r == "murderous intent") {
    //   if(this.emotion < 0.75) {
    //     kill(this, other);
    //   }
    // } else if (r == "resentment") {
    //   if(this.emotion < 0.75) {
    //     violence(this, other);
    //   }
    // } else if (r == "hate") {
    //   fight(this, other);
    // } else if (r == "favor") {
    //   friendship(this, other);
    // } else if (r == "romance") {
    //   love(this, other);
    // } else if (r == "heartbreak") {
    //   heartbreak(this, other);
    // }
  }

  getNaturalActionIndex(other) {
    let r = relationState(this, other);
    if (r == "murderous intent") {
      if(this.emotion < 0.75) {
        return 11;//kill(this, other);
      } else {
        return 2;
      }
    } else if (r == "resentment") {
      if(this.emotion < 0.75) {
        return 12;//violence(this, other);
      } else {
        return 2;
      }
    } else if (r == "hate") {
      return 13;//fight(this, other);
    } else if (r == "favor") {
      return 15;//friendship(this, other);
    } else if (r == "romance") {
      return 18;//love(this, other);
    } else if (r == "heartbreak") {
      return 17;//heartbreak(this, other);
    }
  }

  ethicalInteraction(other) {
    let e = getEthicalActionIndex(this, "Interactive", other);
    console.log("ethical interaction decided: ", this.index, other.index, e);
    this.actionByIndex(e, other);
  }

  interactWith(other) {
    if(random() < naturalVsEthicalRate) {
      this.ethicalInteraction(other);
    } else {
      this.naturalInteraction(other);
    }
    // check love affairs after interaction
    this.cheatCheck();
    if(this.lovers.length > 1) {
      affair(this, this.lovers[0], this.lovers[1]);
    }

    // generosity forced by ethics
    // if(random() < 0.25) {
    //   generosity(this, other);
    // }
  }

  cheatCheck() {
    this.lovers = [];
    for(other of realSystem.people) {
      if(p != this && relationState(this, other) == "romance") {
        this.lovers.push(other);
      }
    }
  }

  // REACTIONS: include reations in ACTIONS!
  // react() {
  // }

  actionByIndex(i, q) {
    switch (i) {
      case 1:
        suicide(this);
        break;
      case 2:
        play(this);
        break;
      case 11:
        kill(this, q);
        break;
      case 12:
        violence(this, q);
        break;
      case 13:
        fight(this, q);
        break;
      case 14:
        solitude(this, q);
        break;
      case 15:
        friendship(this, q);
        break;
      case 16:
        generosity(this, q);
        break;
      case 17:
        heartbreak(this, q);
        break;
      case 18:
        love(this, q);
        break;
      default:
        break;
      }
    }
}

class Economy {
  constructor() {
    this.money = 100000;
  }

  globalEvent() {
    let r = random(-0.5, 0.5);
    for(p of realSystem.people) {
      p.emotion += r;
    }
  }
}

function displayInfo() {
  /*
  display total kills, births, ratio of each relationship type,
  getTotalHappiness, ratio of mania/normal/depression
  distribution of mentalHealth, etc parameters
  */
}

function gameOver() {
  textSize(100);
  text("EXTINCT", width/2, height/2);
  noLoop();
}

function draw() {
  background(255);
  if(realSystem.people.length <= 1) {
    gameOver();
  }
  updatePopulation();
  displayRelations();
  for(p of realSystem.people) {
    p.display();
  }
  textAlign(LEFT, CENTER);
  textSize(30);
  text("hour:" + time, 10, 30);

  if(frameCount % frameInterval == 0) {
    time++;
    timeInDay = time % 10;
    if(timeInDay <= 0) {  // sleep at 0
      for(p of realSystem.people) {
        p.sleep();
      }
    } else if (timeInDay <= 3){ // work at daytime 1,2,3
      for(p of realSystem.people) {
        p.work();
      }
    } else if (timeInDay <= 6) { // social actions at evening 4,5,6
      for(p of realSystem.people) {
        p.move(mobility);
        for(other of realSystem.people) {
          if(0 < distance(p, other) && distance(p, other) < socialRange) {
            p.interactWith(other);
          }
        }
      }
    } else if (timeInDay <= 9){ // be alone at night 7,8,9
      for(p of realSystem.people) {
        p.beAlone();
      }
    }

    if(frameCount % 200 == 1) { // get paid monthly
      p.getPaid();
    }
  }
}
