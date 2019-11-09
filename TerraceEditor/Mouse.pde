public class Mouse {
  
  int cursor;
  boolean isActive;
  boolean wasClicked;
  
  Mouse () {
    init();
  }
  
  void init () {
    isActive = false;
    wasClicked = false;
    cursor = ARROW;  
  }
  
  void reset () {
    init();
  }

  void pressed () {
    isActive = true;
  }
  
  void released () {
    wasClicked = true;
    isActive = false;
  }
  
  boolean overRect (int x, int y, int w, int h) {
    return (
      applet.mouseX >= x 
      && applet.mouseX <= x + w - 1
      && applet.mouseY >= y 
      && applet.mouseY <= y + h - 1
    );
  }

  
}
