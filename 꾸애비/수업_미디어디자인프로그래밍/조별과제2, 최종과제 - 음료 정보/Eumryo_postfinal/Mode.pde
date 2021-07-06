class Mode {
  int xi, yi;
  String hangulX, hangulY;
  boolean isDefaultX, isDefaultY;

  Mode(int x, int y) {
    xi = x;
    yi = y;
    isDefaultX = false;
    isDefaultY = false;
  }

  Mode(boolean det) {
    xi = -1;
    yi = -1;
  }

  void changeModeX(int x) {
    mode.xi = x;
  }

  void changeModeY(int y) {
    mode.yi = y;
  }

  void update() {
    if (xi == -1) {
      mode.isDefaultX = true;
      hangulX = "default";
    } else {
      mode.isDefaultX = false;
      hangulX = hangulRow.getString(xi);
    }
    if (yi == -1) {
      mode.isDefaultY = true;
      hangulY = "default";
    } else {
      mode.isDefaultY = false;
      hangulY = hangulRow.getString(yi);
    }
  }
}
