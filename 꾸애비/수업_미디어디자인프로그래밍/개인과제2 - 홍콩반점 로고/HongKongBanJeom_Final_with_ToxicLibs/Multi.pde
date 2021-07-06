class Multi {
  int numberColumn; 
  float marginRatio; 
  ArrayList<Single> matrix;

  Multi(int n, float m) {
    numberColumn = n; 
    marginRatio = m;

    matrix = new ArrayList();
    for (int i = 0; i < numberColumn; i++) {
      float singleInitX = map(i, 0, numberColumn-1, marginRatio*width, (1-marginRatio)*width);
      matrix.add(new Single(singleLength + random(-singleLenRand, singleLenRand), singleNumPoints, singleInitX));
    }
  }

  void display() {
    for (Single s : matrix) {
      s.display();
      //s.displayBezier();
    }
  }

  int howManyCut() {
    int numcut = 0;
    for (Single s : matrix) {
      if (s.isCut()) numcut++;
    }
    return numcut;
  }
}
