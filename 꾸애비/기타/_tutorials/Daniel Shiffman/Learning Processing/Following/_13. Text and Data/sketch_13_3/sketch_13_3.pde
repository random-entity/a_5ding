String[] words;
int index;

void setup() {
  size(600, 400);
  background(0);
  String[] lines = loadStrings("hamlet_txt.txt");
  String entireplay = join(lines, " ");
  println(entireplay);
  words = splitTokens(entireplay, " ,.?!:[]");
}

void draw() {
  background(0);
  fill(255);
  textSize(64);
  textAlign(CENTER);
  text(words[index].toLowerCase(), width/2, height/2);
  index++;
  }
