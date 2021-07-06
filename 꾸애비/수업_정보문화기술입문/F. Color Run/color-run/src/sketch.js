/*
장애물 :
까마귀(중간 높이, 슬라이딩),
가시덤불(지면과 닿음, 점프),
길고 낮은 벽(캐릭터 누운 채 두 명 정도 들어갈 수 있는 높이, 슬라이딩),
호박(주기적으로 점프, 슬라이딩/점프)

아이템 :
빨간 시계(일시적으로 속도가 빨라지는 아이템),
파란 시계(일시적으로 속도가 느려지는 아이템),
노란 별(일시적으로 무적 상태가 되는 아이템),
컬러 동그라미(게임 스토리 상 찾아야 하는 색깔들을 의미)
*/

/*
To-Do:
spawn 방식 (확률매니저, 시간간격조정)
속도 빨라졌을 때 캐릭터의 속도 가속도 및 spawn freq 어떻게 변화?
카메라 컨트롤 피드백
미세 밸런스 조정
*/

//meta

function reset() {
  person = new Person();
  mainwaitcounter = 0;
  tutorialFrameCount = 0;
  successFrameCount = 0;
  enemies = [];
  enemyGlobalSpeed = 12;
  mjTimer = 0;
  redclocktimer = 0;
  circleGetTimer = 0;
  heartGetTimer = 0;
  colorColl = [false, false, false, false, false, false];
  storyPageNo = 1;
  tutorialPageNo = 1;
}

let meta = "story"; //"story", "cameracheck", "tutorial", "maingame", or "ending"
let storyPageNo = 1;
let tutorialPageNo = 1;
let mainwaitcounter = 0;
let tutorialFrameCount, successFrameCount;
//ui
let storyNextButton, storyPrevButton;
let cameracheckNextButton;
let tutorialNextButton, tutorialPrevButton;
let startButton;
let restartButton;
let tutorialimg;
//setting environment
let groundLevel, groundThickness, skylevel;
//characters
let person;
let enemies = [];
let enemyTypes = ["crow", "vine", "wall", "pumpkin", "clock-red", "clock-blue", "star", "heart", "circle", "cloud"]; //color circle은 색깔별 이미지 있어서 (그리고 사인운동) 별개의 클래스로
let colors = ["orange","yellow","green","blue","pink","purple"];//0orange 1yellow 2green 3blue 4pink 5purple
let colorvalues, colorvaluesOpaque;
// physics
let jumpvi = -50*1.1;
let gravity = 6*1.1; // 체공시간 = 2*|jumpvi|/gravity
//item state
let enemyGlobalSpeed = 12;//절대값!!!!!
let mjTimer = 0; //무적
let redclocktimer = 0;
let circleGetTimer = 0;
let heartGetTimer = 0;
let colorColl = [false, false, false, false, false, false];
let uncollected = [0, 1, 2, 3, 4, 5];
//for cam-pixel work
let camtx, camty, desttx, destty;
let capture;
let getrgb = [];
let getrgbcounter = 0;
let sampleRadius, sampleRes;
let redsig, bluesig;
let redsens = 180, bluesens = 180;
let redsensslider, bluesensslider;
//for animation
let images = [];
let es, esb, ef, efb;
// sound
let bgmOpening, bgmMain, bgmSuccess, bgmFail, soundHit;

function preload() {
  images[0] = loadImage('assets/run-1.png');
  images[1] = loadImage('assets/run-2.png');
  images[2] = loadImage('assets/run-colliding-1.png');
  images[3] = loadImage('assets/run-colliding-2.png');
  images[4] = loadImage('assets/run-star-1.png');
  images[5] = loadImage('assets/run-star-2.png');
  images[6] = loadImage('assets/jump.png');
  images[7] = loadImage('assets/duck.png');
  images[8] = loadImage('assets/enemy-crow.png');
  images[9] = loadImage('assets/enemy-vine.png');
  images[10] = loadImage('assets/enemy-wall.png');
  images[11] = loadImage('assets/enemy-pumpkin.png');
  images[12] = loadImage('assets/enemy-clock-red.png');
  // images[13] = loadImage('assets/enemy-clock-blue.png');
  images[14] = loadImage('assets/enemy-star.png');
  images[15] = loadImage('assets/enemy-heart.png');
  images[16] = loadImage('assets/circle-orange.png');
  images[17] = loadImage('assets/circle-yellow.png');
  images[18] = loadImage('assets/circle-green.png');
  images[19] = loadImage('assets/circle-blue.png');
  images[20] = loadImage('assets/circle-pink.png');
  images[21] = loadImage('assets/circle-purple.png');
  images[22] = loadImage('assets/cloud-1.png');
  images[23] = loadImage('assets/cloud-2.png');
  images[24] = loadImage('assets/cloud-3.png');
  images[25] = loadImage('assets/cloud-4.png');
  images[26] = loadImage('assets/dead.png');
  images[27] = loadImage('assets/story-1.png');
  images[28] = loadImage('assets/story-2.png');
  images[29] = loadImage('assets/story-3.png');
  images[30] = loadImage('assets/story-4.png');
  images[31] = loadImage('assets/story-5.png');
  tutorialimg = loadImage('assets/tutorial.jpeg');
  // es = loadImage('assets/ending-success-1.png');
  es = loadImage('assets/ending-success.png');
  // esb = loadImage('assets/ending-success-2.png');
  // ef = loadImage('assets/ending-failed-1.png');
  ef = loadImage('assets/ending-failed.png');
  // efb = loadImage('assets/ending-failed-2.png');
  bgmOpening = loadSound('assets/opening.mp3');
  bgmMain = loadSound('assets/main.mp3');
  bgmSuccess = loadSound('assets/success.mp3');
  bgmFail = loadSound('assets/fail.mp3');
  soundHit = loadSound('assets/hit.mp3');
  soundGood = loadSound('assets/good.wav');
  soundWoohoo = loadSound('assets/woohoo.ogg');
  soundJump = loadSound('assets/jump.wav');
  soundJumpEE = loadSound('assets/jump-fun.wav');
  soundSlide = loadSound('assets/grilling-meat.wav');
  soundDead = loadSound('assets/dead.mp3');

}

function setup() {

  bgmOpening.setVolume(0.1);
  bgmMain.setVolume(0.1);
  bgmSuccess.setVolume(0.1);
  bgmFail.setVolume(0.1);
  soundHit.setVolume(0.1);
  soundGood.setVolume(1);
  soundWoohoo.setVolume(0.1);
  soundJump.setVolume(0.1);
  soundJumpEE.setVolume(0.1);
  soundSlide.setVolume(0.1);
  soundDead.setVolume(0.1);

  // frameRate(200);
  createP(" ");
  // createP("초록색 원 안에 들어오는 색을 인식합니다. 범위 내의 평균 색이 화면 양옆 네모에 표시되고 있습니다. 빨간색 혹은 파색으로 인식되면 위에 표시됩니다. 슬라이더로 민감도를 조정하고 완료되면 하단의 시작버튼을 클릭하세요.");
  // sensPara = createP("빨강 민감도 = " + redsens + ", 파랑 민감도 = " + bluesens);
  redsensslider = createSlider(0, 255, 180);
  bluesensslider = createSlider(0, 255, 180);

  createCanvas(windowWidth, windowHeight);

  colorvalues = [color(250, 134, 25, 100), color(244, 229, 129, 100), color(86, 210, 104, 100), color(144, 220, 255, 100), color(240, 153, 241, 100), color(188, 32, 217, 100)];
  colorvaluesOpaque = [color(250, 134, 25), color(244, 229, 129), color(86, 210, 104), color(144, 220, 255), color(240, 153, 241), color(188, 32, 217)];
  textSize(12);
  skylevel = 0.2*height;
  groundLevel = 0.8*height;
  groundThickness = 0.05*height;
  person = new Person();
  capture = createCapture(VIDEO);
  console.log("cam width: " + capture.width + ", cam height: " + capture.height);
  capture.hide();
  camtx = width/2 - capture.width/2;
  camty = height/2 - capture.height/2;
  //sampleRadius는 draw()에서 정의해야됨

  storyNextButton = new Button(width*0.9, height*0.9, 100, 20, "다음");
  storyPrevButton = new Button(width*0.1, height*0.9, 100, 20, "이전");
  cameracheckNextButton = new Button(width/2, height*0.9, 100, 20, "다음");
  tutorialNextButton = new Button(width*0.8, height*0.9, 100, 20, "다음");
  tutorialPrevButton  = new Button(width*0.2, height*0.9, 100, 20, "이전");
  startButton = new Button(width/2, height*0.9, 100, 20, "건너뛰고 바로 시작");
  restartButton = new Button(width/2, height/2 + (width/2)*(1668/2224)/2+20, 100, 20, "다시하기");
}

function soundManager() {
  //person.pstate = person.state;는 draw() 맨 위에
  if(person.pstate != "JUMP" && person.state == "JUMP") {
    if(random(1) > 0.2) soundJump.play();
    else soundJumpEE.play();
  }
  if(person.pstate != "DUCK" && person.state == "DUCK") {
    soundSlide.loop();
  }
  if(person.state!="DUCK") soundSlide.stop();

  if(person.pstate != "DEAD" && person.state == "DEAD") {
    soundDead.play();
  }
}

function pixelWork(tx, ty) {
  camtx = tx;
  camty = ty;
  push();
  translate(camtx, camty);
  imageMode(CORNER);
  // for mirrored image->
  push();
  translate(capture.width, 0);
  scale(-1, 1);
  image(capture, 0, 0, capture.width, capture.height);
  pop();
  // <-for mirrored image

  getrgb = [0, 0, 0];
  getrgbcounter = 0;
  for(let x = capture.width/2-sampleRadius; x < capture.width/2+sampleRadius; x+=sampleRes) {
    for(let y = capture.height/2-sampleRadius; y < capture.height/2+sampleRadius; y+=sampleRes) {
      if(dist(x, y, capture.width/2, capture.height/2) < sampleRadius) {
        let c = get(camtx+x, camty+y);
        getrgb[0] += red(c);
        getrgb[1] += green(c);
        getrgb[2] += blue(c);
        getrgbcounter++;
        // noStroke();
        // rectMode(CENTER);
        // fill(c);
        // rect(x, y, sampleRes+1, sampleRes+1);
        // fill(255, 0, 0);
        // noStroke();
        // ellipse(x, y, 5);
      }
    }
  }
  getrgb[0] /= getrgbcounter;
  getrgb[1] /= getrgbcounter;
  getrgb[2] /= getrgbcounter;

  // green circle to show perception range
  stroke(0, 255, 0);
  strokeWeight(5);
  noFill();
  ellipse(capture.width/2, capture.height/2, 2*sampleRadius);

  let c = color(getrgb[0], getrgb[1], getrgb[2]);
  redsig = red(c) - (green(c) + blue(c))/2;
  bluesig = blue(c) - (red(c) + green(c))/2;
  // 걍 빨강 인식 영역 파랑 인식 영역 따로 두고 따로 조정할 수 있게 해야할듯
  //평균색 네모 그리기
  fill(c);
  noStroke();
  rectMode(CENTER);
  rect(-camtx/2, capture.height/2, camtx/2, camtx/2);
  rect(capture.width+camtx/2, capture.height/2, camtx/2, camtx/2);

  if(redsig > 255-redsens) {
    noFill();
    stroke(255, 0, 0);
    strokeWeight(15);
    rect(-camtx/2, capture.height/2, camtx/2, camtx/2);
    fill(0);
    textSize(30);
    noStroke();
    textAlign(CENTER,CENTER);
    text("빨강\n점프", -camtx/2, capture.height/2);
    textSize(12);
  }
  if(bluesig > 255-bluesens) {
    noFill();
    stroke(0, 0, 255);
    strokeWeight(15);
    rect(capture.width+camtx/2, capture.height/2, camtx/2, camtx/2);
    fill(0);
    textSize(30);
    textAlign(CENTER,CENTER);
    noStroke();
    text("파랑\n슬라이딩", capture.width+camtx/2, capture.height/2);
    textSize(12);
  }
  fill(0);
  noStroke();
  textAlign(CENTER, CENTER);
  text("redness = "+redsig.toFixed(0), -camtx/2, capture.height/2 + camtx/4 + 10);
  text("blueness = "+bluesig.toFixed(0), capture.width+camtx/2, capture.height/2 + camtx/4 + 10);

  pop();

}

function spawn(enemyTypeInd) {
  enemies.push(new Enemy(enemyTypeInd));
}

function spawnManager() {
  //0"crow", 1"vine", 2"wall", 3"pumpkin", 4"clock-red", 5"clock-blue", 6"star", 7"heart", 8"circle", 9"cloud"

  // 9 clouds
  if(frameCount % 31 == 23) {
    enemies.push(new Enemy(9));
  }

  // enemies & items
  if(frameCount % 24 == 0) {
    //0, 1, 2, 3: enemies
    let pp = random(1);
    if(pp < 0.65) {
      let n = floor(random(4));
      enemies.push(new Enemy(n));
    } else {   // 4, 6, 7: items (clock-blue는 제외)
      let p = random(1);
      if(p < 0.5) {
        enemies.push(new Enemy(4));
      } else if(p < 0.5+0.2) {
        enemies.push(new Enemy(6));
      } else {
        enemies.push(new Enemy(7));
      }
    }
  }
  // 8 circles
  let ppp =  random(1);
  if(ppp < 0.02) {
    enemies.push(new Enemy(8));

  }

}

function story() {
  if(storyPageNo <= 5) {
    let storyImg = images[26+storyPageNo];
    imageMode(CENTER);
    image(storyImg, width/2, height/2, width/3, width/3);
    storyNextButton.display();
    if(storyPageNo != 1) storyPrevButton.display();
    //버튼 누르면 넘어가는 건 mousePressed()에
  } else {
    meta = "cameracheck";
  }
  startButton.display();
}

function cameracheck() {
  pixelWork(width/2 - capture.width/2, height/2 - capture.height/2);
  //show text instructions
  noStroke();
  fill(0);
  textAlign(CENTER, TOP);
  text("자기 얼굴이 갑툭튀했다고 놀라지 마세요. 색깔인식민감도를 조정하기 위한 화면입니다.\n컴퓨터는 초록색 원 안에 들어오는 색을 인식합니다. 범위 내의 평균 색이 화면 양옆 네모에 표시되고 있습니다.\n빨간색 혹은 파란색으로 인식되면 됐다고 표시됩니다. 카메라에 빨간 물체와 파란 물체를 대보며 시험해보세요.\n왼쪽 위의 슬라이더(안 보일 경우 위로 스크롤해주세요)로 민감도를 조정하고 완료되면 하단의 다음버튼을 클릭하세요.\n빨강 민감도 = "+redsens+"\n파랑 민감도 = "+bluesens, width/2, 10);
  //radius, resolution, sensitivity 조정 슬라이더 추가, 시작버튼 추가, meta = "maingame";
  cameracheckNextButton.display();
}

function tutorial() {
  textSize(12);
  basicGameSetup();

  if(tutorialPageNo <= 3) {
    tutorialNextButton.display();
    if(tutorialPageNo != 1) tutorialPrevButton.display();
    //버튼 누르면 넘어가는 건 mousePressed()에
  } else {
    meta = "maingame";
  }
  noStroke();
  switch (tutorialPageNo) {
    case 1:
      textAlign(CENTER,TOP);
      textSize(20);
      fill(0);
      text("먼저, 빨간 색은 어떤 에너지를 가지고 있는 지 확인해봅시다. \n주변에 있는 빨간 색 물체를 가져와 이를 통해 빨간 색의 에너지를 사용해보세요!\n<화면 중앙부에 빨간 색 물체를 비춰보세요.>", width/2, skylevel + 20);
      if(person.state == "JUMP") {
        fill(255, 0, 0);
        textSize(30);
        textAlign(CENTER,CENTER);
        text('점프!', width/2, height/2);
      }
      break;
    case 2:
      textAlign(CENTER,TOP);
      textSize(20);
      fill(0);
      text("빨간 색을 이용하면 점프해서 장애물들을 건너뛸 수 있습니다!\n그렇다면 파란 색은 어떤 에너지를 가지고 있을까요?\n주변에 있는 파란 색 물체를 가져와 이를 통해 파란 색의 에너지를 사용해보세요!\n<화면 중앙부에 파란 색 물체를 비춰보세요.>", width/2, skylevel + 20);
      if(person.state == "DUCK") {
        fill(0, 0, 255);
        textSize(30);
        textAlign(CENTER,CENTER);
        text('슬라이딩!', width/2, height/2);
      }
      break;
    case 3:
      textAlign(CENTER,TOP);
      textSize(20);
      fill(0);
      text("파란 색을 이용하면 슬라이딩 해서 허공에 있는 장애물들을 피할 수 있습니다!\n그리고 마지막 한가지, 점프도 슬라이딩도 안 하고 뛰는 상태입니다.\n가만히 있으면 중간이라고 간다고 하지요.\n어떨 때에는 빨강에너지도 파랑에너지도 발산하지 않고 가만히 있는 게 낫습니다.\n모험을 떠날 준비가 되셨다면 다음 버튼을 누르세요!", width/2, skylevel + 20);
      break;
    default: break;

  }

  textSize(12);
  startButton.display();
}

function basicGameSetup() { // common for both tutorial() and maingame()
  //run and display pixelWork
  desttx = width/2 - capture.width/2;
  destty = skylevel/2 - capture.height/2;
  camtx = lerp(camtx, desttx, 0.2);
  camty = lerp(camty, destty, 0.2);
  // camtx = width/2 - capture.width/2;
  // camty = skylevel/2 - capture.height/2;

  pixelWork(camtx, camty);

  if((redsig > 255-redsens) && person.state == "IDLE") {
     person.state = "JUMP"
     console.log("RED jump start");
     person.yspeed = jumpvi;
   }
  if(bluesig > 255-bluesens) {
    if(person.state == "IDLE") {
      person.width = person.duckwidth;
      person.height = person.duckheight;
      person.state = "DUCK";
      console.log("BLUE duck start");
    } else if(person.state == "JUMP") {
      person.state = "WANT-TO-DUCK";
      console.log("BLUE want to duck");
    }
  }

    switch (meta) {
      case 'tutorial'://leave the capture only above the sky
        fill(255);
        noStroke();
        rectMode(CORNER);
        rect(0, skylevel, width, height);
        rectMode(CORNER);
        fill(255);
        stroke(0);
        rect(0, groundLevel, width, groundThickness);
        line(0, skylevel, width, skylevel);
        break;
      case 'maingame':
        //draw environment
        for(let y = skylevel; y <= groundLevel; y+=10) {
          let ri = 50, gi = 162, bi =227;
          let rf = 12, gf = 83, bf = 138;
          let r = map(y, groundLevel, skylevel, ri, rf);
          let g = map(y, groundLevel, skylevel, gi, gf);
          let b = map(y, groundLevel, skylevel, bi, bf);
          fill(color(r, g, b));
          noStroke();
          rect(0, y, width, 11);
        }
        for(let y = groundLevel; y <= height; y+=15) {
          let ri = 99, gi = 69, bi =42;
          let rf = 28, gf = 23, bf = 18;
          let r = map(y, groundLevel, height, ri, rf);
          let g = map(y, groundLevel, height, gi, gf);
          let b = map(y, groundLevel, height, bi, bf);
          fill(color(r, g, b));
          noStroke();
          rect(0, y, width, 16);
        }
      default: break;
    }

  //run person and enemies and timers
  if(mjTimer > 0) {
    fill(colorvaluesOpaque[floor(random(colorvalues.length))]);
    noStroke();
    textSize(30);
    textAlign(CENTER,CENTER);
    text('☆☆☆무적상태☆☆☆', width/2, height/2+40);
    textSize(12);
    mjTimer--;
  } else {
    mjTimer = 0;
  }
  if(person.state != "DEAD"){
    if(redclocktimer > 0) {
      fill(250, 239, 27);
      noStroke();
      textAlign(CENTER,CENTER);
      textSize(30);
      text('속도증가!', width/2, height/2);
      textSize(12);
      redclocktimer--;
      enemyGlobalSpeed = 18;
    } else {
      redclocktimer = 0;
      enemyGlobalSpeed = 12;
    }
  }
  if(circleGetTimer > 0) {
    circleGetTimer--;
    if(uncollected.length >= 1) {
      textAlign(CENTER,CENTER);
      textSize(30);
      fill(255);
      text('앞으로 '+uncollected.length+'가지 색만 더 모으자!', width/2, skylevel + 100);
      textSize(12);
    }
  } else {
    circleGetTimer = 0;
  }
  if(heartGetTimer > 0) {
    heartGetTimer--;
    textAlign(CENTER,CENTER);
    textSize(30);
    fill(255,203,203);
    text('♡♥♡♥♡♥♡♥힘이 난다♡♥♡♥♡♥♡♥', width/2, height/2 - 40);
    textSize(12);
  } else {
    heartGetTimer = 0;
  }
  // textAlign(LEFT, TOP);
  // fill(0);
  // text("무적타이머: "+mjTimer, 10, skylevel + 10);

  for(e of enemies) {
    person.runCollision(e);
    e.physics();
    e.display();
    if(e.xpos < -e.width) {
      enemies.splice(0, 1);
    }
  }

  person.display();
  person.physics();

}

function maingame() {

  basicGameSetup();

  // spawn enemies
  spawnManager();

  uncollected = [];
  for(let i = 0; i < colorColl.length; i++) {
    if(colorColl[i] == false) {
      uncollected.push(i);
    }
  }

  soundManager();

  displayStatus();
}

function displayStatus() {
    // fill(0);
    // textAlign(CENTER, CENTER);
    // text(person.state, width/2, height/4);
    // text("global speed = " + enemyGlobalSpeed.toFixed(1), width/2, height/4+40);
    // text("HP = " + person.health.toFixed(1), width/2, height/4+60);
    // text(colorColl, width/2, height/4+80);

    for(let i = 0; i <= 5; i++) {
      let x = width/2 - 40*(2.5-i);
      let y = skylevel + 50;
      if(!colorColl[i]){
        // tint(255, 100);
        noStroke();
        fill(colorvalues[i]);
        ellipse(x, y, 44.8/0.9, 40.3/0.9);
      } else {
        image(images[i+16], x, y, 44.8/0.75, 40.3/0.75);
      }
      // noTint();
    }
}

function ending() {
  soundSlide.stop();
  imageMode(CENTER);
  if(colorColl[0] == true && colorColl[1] == true && colorColl[2] == true && colorColl[3] == true && colorColl[4] == true && colorColl[5] == true) {
    // if(!restartButton.mouseIsNear()) {
      image(es, width/2, height/2, width/2, (width/2)*(1668/2224));
      textSize(50);
      fill(0);
      textAlign(CENTER, CENTER);
      text("걸린 시간 : "+((successFrameCount-tutorialFrameCount)/24).toFixed(0)+"초", width/2, height/2 - (width/2)*(1668/2224)/2 - 40);
      textSize(12);
    // } else {
    //   image(esb, width/2, height/2, width/2, (width/2)*(1668/2224));
    // }
  } else {
    // if(!restartButton.mouseIsNear()) {
      image(ef, width/2, height/2, width/2, (width/2)*(1668/2224));
    // } else {
    //   image(efb, width/2, height/2, width/2, (width/2)*(1668/2224));
    // }
  }
  restartButton.display();
}


function draw() {
  background(255);

  sampleRadius = capture.height/6;
  sampleRes = 40;

  textAlign(LEFT, CENTER);
  fill(0);
  text(meta, 10, 20);

  redsens = redsensslider.value();
  bluesens = bluesensslider.value();
  // sensPara.html("빨강 민감도 = " + redsens + ". 파랑 민감도 = " + bluesens);

  person.pstate = person.state;
  if(person.pstate != person.state) {console.log(person.pstate, person.state);}

  switch (meta) {

    case "story": story(); break;

    case "cameracheck": cameracheck(); break;

    case "tutorial": tutorial(); break;

    case "maingame": maingame();
    if(colorColl[0] == true && colorColl[1] == true && colorColl[2] == true && colorColl[3] == true && colorColl[4] == true && colorColl[5] == true) {
      if(mainwaitcounter < 48) {
        if(mainwaitcounter == 0) {successFrameCount = frameCount;}
        mainwaitcounter++;
        textSize(40);
        fill(173, 255, 210);
        textAlign(CENTER,CENTER);
        text("색깔을 다 모았습니다.", width/2, height/2 - 100);
        textSize(12);
      } else {
        meta = "ending";
      }
    }
    if(person.health <= 0) {
      enemyGlobalSpeed = 0;
      if(mainwaitcounter < 48) {
        mainwaitcounter++;
        fill(0);
        textSize(40);
        textAlign(CENTER,CENTER);
        text("죽었습니다.", width/2, height/2);
        textSize(12);
      } else {
        meta = "ending";
      }
    }
    // console.log(uncollected);
    break;

    case "ending": ending(); break;

    default: break;
  }
}

class Person {
  constructor() {
    this.origwidth = 62.6/2;
    this.origheight = 85.4;
    this.duckwidth = this.origheight;
    this.duckheight = this.origwidth;
    this.width = this.origwidth;
    this.height = this.origheight;
    this.xpos = 0.25*width;
    this.ypos = groundLevel;
    this.yspeed = 0;
    this.yacc = 0;
    this.isJumping = false;
    this.state = "IDLE"; //idle, jump, duck, stop
    this.pstate = "IDLE";
    this.health = 100;
  }

  physics() {
    if(this.state == "JUMP" || this.state == "WANT-TO-DUCK") {
      person.width = person.origwidth;
      person.height = person.origheight;
      this.yacc = gravity;
      this.yspeed += this.yacc;
      this.ypos += this.yspeed;
      if(this.ypos > groundLevel) {
        console.log("jump end");
        this.ypos = groundLevel;
        if(this.state == "WANT-TO-DUCK"){
          person.width = person.duckwidth;
          person.height = person.duckheight;
          this.state = "DUCK";
        } else {
          person.width = person.origwidth;
          person.height = person.origheight;
          this.state = "IDLE";
        }
      }
    } else if (this.state == "DUCK") {
      if((bluesig < 255-bluesens) && !keyIsDown(DOWN_ARROW)) {
        person.width = person.origwidth;
        person.height = person.origheight;
        this.state = "IDLE";
        console.log("duck end");
      }
    } else if(this.state == "DEAD" && this.ypos < groundLevel) {
      this.ypos+=2;
    }

    if(this.health <= 0) {
      this.state = "DEAD";
    }
  }

  getCollidingEnemyTypeIndex() {
    for(e of enemies) {
      if(person.isColliding(e)) {
        return e.typeIndex;
        break;
      }
    }
  }

  isColliding(e) {
    if(this.ypos-this.height < e.ypos+e.height/2 && this.ypos > e.ypos-e.height/2 && this.xpos+this.width/2 > e.xpos-e.width/2 && this.xpos-this.width/2 < e.xpos+e.width/2) {
      return true;
    } else {
      return false;
    }
  }

  isCollidingSomething() {
    let t = false;
    for(e of enemies) {
      if(this.isColliding(e)) {
        t = true;
        break;
      }
    }
    return t;
  }

  runCollision(e) {
    if(this.isColliding(e)) {
      // textAlign(CENTER, CENTER);
      // fill(0);
      // if(e.typeIndex <= 3) {
      //   text("collision with enemy "+enemyTypes[e.typeIndex], width/2, height/4 + 20);
      // } else {
      //   text("collision with item "+enemyTypes[e.typeIndex], width/2, height/4 + 20);
      // }
      e.pcollided = e.collided;
      e.collided = true;
      switch (e.type) {
        case "crow":
          if(mjTimer == 0) {this.health -= 4;}
          break;
        case "vine":
          if(mjTimer == 0) {this.health -= 2;}
          break;
        case "wall":
          if(mjTimer == 0) {this.health -= 5;}
          break;
        case "pumpkin":
          if(mjTimer == 0) {this.health -= 3;}
          break;

        case "clock-red":
          redclocktimer = 100;
          break;
        case "clock-blue":
          enemyGlobalSpeed = max(enemyGlobalSpeed-0.25, 5);
          break;
        case "star":
          mjTimer = 100;
          break;
        case "heart":
          this.health = min(this.health+3, 100);
          heartGetTimer = 24;
          break;

        case "circle":
        // this.health += 3
        circleGetTimer = 24;
        colorColl[e.colorIndex] = true;

        break;

        default: break;
      }

      if(e.pcollided == false && e.collided == true) {
        if(e.typeIndex <= 3){
          if(mjTimer == 0){
            soundHit.play();
          } else {
            soundWoohoo.play();
          }
        } else if(4<=e.typeIndex&&e.typeIndex<=8) {
          soundGood.play();
        }
      }
    }
  }

  display() {
    push();
    translate(this.xpos, this.ypos);
    // rectMode(CORNER);
    // noFill();
    // rect(-this.width/2, -this.height, this.width, this.height);
    imageMode(CORNER);
    let img;
    let r, s, t, m;

    if(frameCount%4 < 2) {
      r = 0;
    } else {
      r = 1;
    }
    if(this.isCollidingSomething() && this.getCollidingEnemyTypeIndex()<=3) {
      s = 2;
    } else {
      s = 0;
    }
    if(mjTimer > 0) {
      t = 4;
    } else {
      t = 0;
    }

    if(this.state == "IDLE"){
      if(mjTimer > 0) {
        m = t+r;
      } else {
        m = s+r;
      }
      img = images[m];
      let w = this.height*img.width/img.height; //사람을 collider의 height에 맞춘다
      image(img, -w/2, -this.height, w, this.height);
    } else if(this.state == "JUMP" || this.state == "WANT-TO-DUCK") {
      if(mjTimer > 0) {
        m = t+r;
      } else {
        m = 6;
      }
      img = images[m];
      let w = this.height*img.width/img.height; //사람을 collider의 height에 맞춘다
      image(img, -w/2, -this.height, w, this.height);
    } else if(this.state == "DUCK") {
      if(mjTimer > 0) {
        m = t+r;
        img = images[m];
        push();
        rotate(-PI/2);
        translate(this.origwidth/2, this.origheight/2);
        let w = this.origheight*img.width/img.height; //사람을 collider의 height에 맞춘다
        image(img, -w/2, -this.origheight, w, this.origheight);
        pop();
      }
      else {
        img = images[7];
        let h = (this.width*img.height/img.width); //사람을 collider의 width에 맞춘다
        image(img, -this.width/2, -h*0.75, this.width, h);
        // stroke(0, 255, 0);
        // rect(-this.width/2, -h*0.75, this.width, h);
      }
    } else if(this.state == "DEAD"){
      img = images[26];
      let w = this.origheight*img.width/img.height; //사람을 collider의 height에 맞춘다
      image(img, -w/2, -this.height, w, this.height);
    }

    pop();
    if(this.health > 50) {
      // if(this.isCollidingSomething()) fill(0, 255, 0, 100);
      // else
      fill(0, 255, 0);
    } else if(this.health > 20) {
      // if(this.isCollidingSomething()) fill(255, 255, 0, 100);
      // else
      fill(255, 255, 0);
    } else if(this.health >= 0) {
      // if(this.isCollidingSomething()) fill(255, 0, 0, 100);
      // else
      fill(255, 0, 0);
    }
    if(this.getCollidingEnemyTypeIndex() <= 3 && frameCount%4 <= 1) fill(181, 0, 0);
    if(this.getCollidingEnemyTypeIndex() == 7 && frameCount%4 <= 1) fill(177, 255, 43);
    if(mjTimer > 0){
      if(frameCount%10 >= 5) fill(46, 255, 252);
    }
    if(this.health >= 0){
      rectMode(CORNER);
      noStroke();
      rect(person.xpos-50, person.ypos-person.height-20, this.health, 12);
    }
    stroke(0);
    noFill();
    rectMode(CORNER);
    rect(person.xpos-50, person.ypos-person.height-20, 100, 12);

  }
}

class Enemy { //includes Items
  constructor(typeInd) {
    this.typeIndex = typeInd;
    this.type = enemyTypes[typeInd];
    this.collided = false;
    this.pcollided = false;
    if(typeInd <= 7) {
      this.img = images[8+typeInd];//loadImage('assets/enemy-'+ this.type +'.png');
    } else if (typeInd == 8) { // 8"circle"
      if(uncollected.length >= 1) {
        let n = floor(random(uncollected.length));
        this.colorIndex = uncollected[n];
      } else {
        this.colorIndex = floor(random(colors.length));
      }

      this.color = colors[this.colorIndex];
      this.img = images[16+this.colorIndex]
      // console.log(this.colorIndex, this.color, this.img);
    } else {//9"cloud"
      let s = floor(random(0, 4));
      this.img = images[22+s];
    }

    //0"crow", 1"vine", 2"wall", 3"pumpkin", 4"clock-red", 5"clock-blue", 6"star", 7"heart", 8"circle", 9"cloud"
    this.width = 44.8;
    this.height = 40.3;
    this.xpos = width + this.width; //initiate from the right to right edge
    this.xspeed = -enemyGlobalSpeed;
    this.ypos = groundLevel - person.height;
    this.yposorig = this.ypos;
    this.yspeed = 0;
    this.yacc = 0;
    this.clock = floor(random(100));
    this.period = 72;
    this.amp = random(0.05, 0.2);
    //종류에 따라 y 지정식으로
    switch (this.type) {
      case "crow":
        this.width = 59.1*2;
        this.height = 36.5*2;
        this.ypos = groundLevel - person.origheight*0.9;
        break;
      case "vine":
        this.ypos = groundLevel-groundThickness*0.4;
        break;
      case "wall":
      this.width = 29.9*2.5;
      this.height = 54.3*2.5;
      this.ypos = groundLevel - person.origheight*1.55;
        break;
      case "pumpkin":
        this.width*=1.5;
        this.height*=1.5;
        this.ypos = groundLevel - person.origheight*0.35;
        break;
      case "heart":
        this.ypos-=person.duckheight;
        break;
      case "star":
        this.ypos-=person.duckheight;
        break;
      case "circle":
        this.xspeed *= random(-0.8, 1.5);
        break;
      case "cloud":
        this.width = 62.7*1.5;
        this.height = 57.6*1.5;
        this.ypos = random(skylevel+person.origheight*2, groundLevel - person.origheight*2);
        this.xpos += random(150);
      default:
        break;
    }
    this.yposorig = this.ypos;

    /* 0까마귀 1가시덤불 2벽 3호박
    4빨간시계 5파란시계 6별 7하트 */
  }

  physics() {

    this.xspeed = -enemyGlobalSpeed;
    this.xpos += this.xspeed;
    if(this.type == "pumpkin"){
      this.clock = (this.clock+1)%this.period;
      if(this.clock < this.period/2) {
        this.ypos = this.yposorig - person.origheight*2*(1 - sq((this.clock - this.period/4)/(this.period/4))) ;
      } else {
        this.ypos = this.yposorig;
      }
    }
    if(this.type == "circle") {
      this.xspeed *= 2;
      this.ypos += person.origheight*this.amp*sin(frameCount*2*PI/this.period);
    }
  }

  display() {
    if(this.collided == false || !((4 <= this.typeIndex)&&(this.typeIndex <= 8))){
      // rectMode(CENTER);
      // noFill();
      // stroke(0, 0, 255);
      // rect(this.xpos, this.ypos, this.width, this.height);
      imageMode(CENTER);
      image(this.img, this.xpos, this.ypos, this.width, this.height);
    }
  }
}

class Button {
  constructor(x, y, w, h, txt) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.t = txt;
  }

  mouseIsNear() {
    if(abs(this.x - mouseX) < this.w/2 && abs(this.y - mouseY) < this.h/2) {
      return true;
    } else {
      return false;
    }
  }

  display() {
    noFill();
    stroke(0);
    rectMode(CENTER);
    rect(this.x, this.y, this.w, this.h);
    if(this.mouseIsNear()) {
      fill(0, 255, 0);
      noStroke();
      rectMode(CENTER);
      rect(this.x, this.y, this.w, this.h);
    }
    fill(0);
    textAlign(CENTER, CENTER);
    text(this.t, this.x, this.y);
  }
}

function keyPressed() {
  console.log(key);
  if((key == ' ' || keyCode == UP_ARROW) && (person.state == "IDLE" || person.state == "DUCK")) {
    person.state = "JUMP";
    console.log("jump start");
    person.yspeed = jumpvi;
  } else if(keyCode == DOWN_ARROW) {
    if(person.state == "IDLE") {
      person.width = person.duckwidth;
      person.height = person.duckheight;
      person.state = "DUCK";
      console.log("duck start");
    } else if(person.state == "JUMP") {
      person.state = "WANT-TO-DUCK";
      console.log("want to duck");
    }
  }
}

function mousePressed() {
  if(meta == "story"){
    if(storyNextButton.mouseIsNear()) {
      storyPageNo++;
    }
    if(storyPrevButton.mouseIsNear()) {
      storyPageNo = max(1, storyPageNo-1);
    }
    if(startButton.mouseIsNear()) {
      meta = "maingame";
      tutorialFrameCount = frameCount;
    }
  } else if (meta == "cameracheck") {
    if(cameracheckNextButton.mouseIsNear()) {
      meta = "tutorial"
    }
  } else if(meta == "tutorial") {
    if(tutorialNextButton.mouseIsNear()) {
      tutorialPageNo++;
      tutorialFrameCount = frameCount;
    }
    if(tutorialPrevButton.mouseIsNear()) {
      tutorialPageNo = max(1, tutorialPageNo-1);
    }
    if(startButton.mouseIsNear()) {
      meta = "maingame";
      tutorialFrameCount = frameCount;
    }
  } else if(meta == "ending") {
    if(restartButton.mouseIsNear()) {
      meta = "story";
      reset();
    }
  }
}
