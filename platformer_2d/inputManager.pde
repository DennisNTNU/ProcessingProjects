class InputManager {

  boolean[] keyDown;
  boolean[] keyDownLastFrame;
  boolean[] keyPress;
  boolean[] keyReleased;

  InputManager() {
    keyDown = new boolean[256];
    keyDownLastFrame = new boolean[256];
    keyPress = new boolean[256];
    keyReleased = new boolean[256];

    for (int i = 0; i < 256; i++) {
      keyDown[i] = false;
      keyDownLastFrame[i] = false;
      keyPress[i] = false;
      keyReleased[i] = false;
    }
  }

  void update() {

    for (int i = 0; i < 256; i++) {

      if (keyDown[i] && !keyDownLastFrame[i]) {
        keyPress[i] = true;
      } else {
        keyPress[i] = false;
      }


      if (!keyDown[i] && keyDownLastFrame[i]) {
        keyReleased[i] = true;
      } else {
        keyReleased[i] = false;
      }

      keyDownLastFrame[i] = keyDown[i];
    }
  }

  void keyDown(char key_Code) {
    keyDown[key_Code] = true;
  }

  void keyUp(char key_Code) {
    keyDown[key_Code] = false;
  }
}