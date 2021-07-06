class AlertSystem {  
  int alertState;
  int bufferSize;
  float[] ampBuffer;
  boolean IO, pIO;
  int[] frameCounter;
  int[] phaseStartTimeRecord;
  int currentPhaseNo;
  int chejoMinCallNo, chejoTimeThr; // How many successive calls will activate Chejo? How short should the time interval of calls be(unit = frames)?

  AlertSystem() {
    alertState = 0; // 0 = Idle, 1 = Aware, 2 = Arranged, 3 = Jump.
    bufferSize = 2;
    ampBuffer = new float[bufferSize];
    IO = false; 
    pIO = false;
    frameCounter = new int[1000];
    phaseStartTimeRecord = new int[1000];
    phaseStartTimeRecord[0] = 1;
    currentPhaseNo = 0;
    chejoMinCallNo = 3;
    chejoTimeThr = 24;
  }

  void update() {
    // Save last [bufferSize] frame's amplitude.
    for (int i = bufferSize - 1; i >= 1; i--) {
      ampBuffer[i] = ampBuffer[i-1];
    }
    ampBuffer[0] = amplitude;

    // Determine if alert ON or OFF.
    boolean IOTest = false;
    for (int i = 0; i < bufferSize; i++) {
      if (ampBuffer[i] >= ampThr) {
        IOTest = true;
      }
    }
    pIO = IO;
    IO = IOTest;

    // What Phase are we in? + Record the start time of current phase.
    if (pIO != IO) {
      currentPhaseNo++;
      phaseStartTimeRecord[currentPhaseNo] = frameCount;
    }

    // Measure time each OFF/ON phase.
    frameCounter[currentPhaseNo]++;

    // Update the AlertState.
    if (alertState == 0) {
      if (pIO == false && IO == true) alertState = 1;
    } else if (alertState == 1) {
      if (currentPhaseNo % 2 == 1 && frameCounter[currentPhaseNo] > arrangingWhistleDuration*frameRateSetting) alertState = 2; //pIO == false && IO == true
      if (currentPhaseNo % 2 == 0 && frameCounter[currentPhaseNo] > awareDaegi*frameRateSetting) {
        alertState = 0; //"IO == true" and "currentPhase even" don't happen at the same time
        daegiTimeSaver = awareDaegi;
      }
    } else if (alertState == 2) {
      if (currentPhaseNo % 2 == 0 && allArrived && frameCounter[currentPhaseNo] > arrangedDaegi*frameRateSetting + allArriveTimer) {
        alertState = 0;
        daegiTimeSaver = arrangedDaegi + allArriveTimer/frameRateSetting;
      } else if (this.chejoIsActive()) {
        alertState = 3;
      }
    } else if (alertState == 3) {
      if (currentPhaseNo % 2 == 0 && frameCounter[currentPhaseNo] > chejoDaegi*frameRateSetting) {
        alertState = 0;
        daegiTimeSaver = chejoDaegi;
      }
    }
  }

  //Is Chejo Activated?
  boolean chejoIsActive() {
    boolean reverse = false;
    int r = 1 - currentPhaseNo % 2;
    int c = currentPhaseNo;
    if (c-r-2*chejoMinCallNo >= 0) {
      for (int i = 0; i < chejoMinCallNo; i++) {
        if (phaseStartTimeRecord[c-r-2*i] - phaseStartTimeRecord[c-r-2*(i+1)] > chejoTimeThr) reverse = true;
      }
      return !reverse;
    } else return false;
  }
}
