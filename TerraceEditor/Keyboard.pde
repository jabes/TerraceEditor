public class Keyboard {

  boolean keyUp;
  boolean keyDown;
  boolean keyLeft;
  boolean keyRight;
  boolean keyControl;
  boolean keyDel;
  boolean keyBack;

  boolean wasPressed;
  int currentKeyCode;

  Keyboard () {
    keyUp = false;
    keyDown = false;
    keyLeft = false;
    keyRight = false;
    keyControl = false;
    keyDel = false;
    keyBack = false;
    init();
  }

  void init () {
    wasPressed = false;
    currentKeyCode = 0;
  }

  void reset () {
    init();
  }

  void pressed (int code) {
    if (code == UP) {
      keyUp = true;
    } else if (code == DOWN) {
      keyDown = true;
    } else if (code == LEFT) {
      keyLeft = true;
    } else if (code == RIGHT) {
      keyRight = true;
    } else if (code == CONTROL) {
      keyControl = true;
    } else if (code == DELETE) {
      keyDel = true;
    } else if (code == BACKSPACE) {
      keyBack = true;
    }

    wasPressed = true;
    currentKeyCode = code;
  }

  void released (int code) {
    if (code == UP) {
      keyUp = false;
    } else if (code == DOWN) {
      keyDown = false;
    } else if (code == LEFT) {
      keyLeft = false;
    } else if (code == RIGHT) {
      keyRight = false;
    } else if (code == CONTROL) {
      keyControl = false;
    } else if (code == DELETE) {
      keyDel = false;
    } else if (code == BACKSPACE) {
      keyBack = false;
    }
  }

}
