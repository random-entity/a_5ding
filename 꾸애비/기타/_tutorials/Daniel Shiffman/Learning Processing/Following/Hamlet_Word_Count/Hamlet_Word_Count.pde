String[] words;

IntDict concordance;

int index = 0;

void setup() {
  size(1000, 400);
  textSize(60);
  String[] byLinesHamlet = loadStrings("Hamlet.txt");
  String entireHamlet = join(byLinesHamlet, " ");
  words = splitTokens(entireHamlet, " ,.:;!?&/\\");
  concordance = new IntDict();
  for (int i = 0; i < words.length; i++) {
    concordance.increment(words[i].toLowerCase());
  }
concordance.sortValues();
println(concordance);
}

void draw() {
  background(0);
  
  String[] keys = concordance.keyArray();
  for (int i = 0; i < keys.length; i++) {
    int count = concordance.get(keys[i]);
    println(keys[i], count);
  }
  
  textAlign(CENTER);
  text(words[index] + " " + words[index + 1]+ " " + words[index + 2], width/2, height/2);
  frameRate(5);
  index++;
}
