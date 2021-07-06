String[] words;
int index;
IntDict con;

void setup() {
  size(600, 400);
  background(0);
  String[] lines = loadStrings("hamlet_txt.txt");
  String entireplay = join(lines, " ");
  println(entireplay);
  words = splitTokens(entireplay, " ,.?!:[]");
  con = new IntDict();
  for (int i = 0; i < words.length; i++) {
    con.increment(words[i].toLowerCase());
  }
  con.sortValuesReverse();
  println(con);
}

void draw() {
  background(0);
  fill(255);
  textSize(64);
  textAlign(CENTER);
  //text(words[index].toLowerCase(), width/2, height/2);
  //index++;

  String[] keys = con.keyArray();

  for (int i = 0; i < keys.length; i++) {
    int count = con.get(keys[i]);
    println(keys[i], count);
  }
  noLoop();
}
