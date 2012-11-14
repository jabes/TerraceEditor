public class Scrollbar {
  
  final int posX;
  final int posY;
  final int sizeWidth;
  final int sizeHeight;
  
  final int scrubPadding;
  final int scrubWidth;
  final int scrubHeight;
  
  int scrubX;
  int scrubY;
  
  boolean isScrubbing;
  boolean isDisabled;

  int scrubOffsetLeft;
  
  float scrubValue;
  
  Scrollbar (int x, int y, int w, int h) {
    posX = x;
    posY = y;
    sizeWidth = w;
    sizeHeight = h;
    scrubPadding = 1;
    scrubWidth = 100 - (scrubPadding * 2);
    scrubHeight = sizeHeight - (scrubPadding * 2);
  }
  
  void init () {
    scrubX = posX + scrubPadding;
    scrubY = posY + scrubPadding;
    isScrubbing = false;
    isDisabled = false;
    scrubOffsetLeft = 0;
    scrubValue = 0;
  }
  
  void reset () { init(); }
  
  void iterate () {
    
    if (
      !isDisabled 
      && !dialog.isOpen
      && !changeMapSizeWindow.isOpen
      && (
        isScrubbing 
        || mouse.overRect(scrubX, scrubY, scrubWidth, scrubHeight)
      )
    ) {
      mouse.cursor = HAND;
      if (mouse.isActive) {
        if (!isScrubbing) {
          isScrubbing = true;
          scrubOffsetLeft = mouseX - scrubX;
        }
        scrubX = mouseX - scrubOffsetLeft;
        if (scrubX < posX + scrubPadding) scrubX = posX + scrubPadding;
        else if (scrubX > sizeWidth - scrubWidth - scrubPadding) scrubX = sizeWidth - scrubWidth - scrubPadding;
        scrubValue = (scrubX - scrubPadding) / (float) (sizeWidth - scrubWidth - (scrubPadding * 2));
      } else {
        isScrubbing = false;
        scrubOffsetLeft = 0; // not mandatory to reset, but for the sake of a peaceful mind..
      }
    }
    
    pushStyle();
    fill(200);
    rect(posX, posY, sizeWidth, sizeHeight);
    popStyle();
    
    if (!isDisabled) {
      pushStyle();
      fill(100);
      rect(scrubX, scrubY, scrubWidth, scrubHeight);
      popStyle();
      image(resources.srubberSprite, scrubX + (scrubWidth / 2) - 4, scrubY + (scrubHeight / 2) - 4, 9, 8);
    }
  }
  
  //void disable () { isDisabled = true; }
  //void enable () { isDisabled = false; }
  
  // compare two values that will determine if the scroller is needed
  void check (int a, int b) {
    if (a <= b) isDisabled = true;
    else reset();
  }

}
