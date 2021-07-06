int[] result = new int[width];
  
void setup() {
  size(500, 400);
  background(255);
  stroke(0);
}

void draw() {
  
  int chosenThisFrame = int(parabolaChoice());
  //println(result[chosenThisFrame]);
  result[chosenThisFrame]++;
  
  for (int i = 0; i < width; i++) {
    line(i, height, i, height - result[i]);
  }
}

float parabolaChoice() {
  while (true) {
    float r1 = random(width);
    float p = height * (r1 / width) * (r1 / width);
    float r2 = random(height);
    if (r2 < p) {
      return r1;
    }
  }
}
