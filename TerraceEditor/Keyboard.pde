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
    wasPressed = true;
    currentKeyCode = code;
    switch (code) {
      case LEFT: keyLeft = true; break;
      case UP: keyUp = true; break;
      case RIGHT: keyRight = true; break;
      case DOWN: keyDown = true; break;
      case CONTROL: keyControl = true; break;
      case DELETE: keyDel = true; break;
      case BACKSPACE: keyBack = true; break;
    }
  }

  void released (int code) {
    switch (code) {
      case LEFT: keyLeft = false; break;
      case UP: keyUp = false; break;
      case RIGHT: keyRight = false; break;
      case DOWN: keyDown = false; break;
      case CONTROL: keyControl = false; break;
      case DELETE: keyDel = false; break;
      case BACKSPACE: keyBack = false; break;
    }
  }

}
