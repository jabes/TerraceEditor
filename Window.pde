abstract class Window {
  
  final int boxPadding;
  
  final int sizeWidth;
  final int sizeHeight;
  final int posX;
  final int posY;
  
  final int headerX;
  final int headerY;
  final int headerWidth;
  final int headerHeight;
  
  private int buttonOffsetRight = 0;
  private int numberFieldOffsetTop = 0;
  
  boolean isOpen;
  
  Window (int w, int h) {
    boxPadding = 10;
    sizeWidth = w;
    sizeHeight = h;
    posX = (applet.width / 2) - (sizeWidth / 2);
    posY = (applet.height / 2) - (sizeHeight / 2);
    headerX = posX;
    headerY = posY;
    headerWidth = sizeWidth;
    headerHeight = 30;
  }
  
  void drawModalBox (String headerText) {
    
    pushStyle();
    fill(0, getAlpha(0.75));
    rect(0, 0, applet.width, applet.height);
    popStyle();
    
    pushStyle();
    fill(255);
    rect(posX, posY, sizeWidth, sizeHeight);
    popStyle();
    
    pushStyle();
    fill(100);
    rect(headerX, headerY, headerWidth, headerHeight);
    popStyle();
    
    pushStyle();
    fill(240);
    textFont(fonts.TheSans);
    textAlign(LEFT, CENTER);
    text(
      headerText,
      headerX + boxPadding, 
      headerY, 
      headerWidth,
      headerHeight
    );
    popStyle();
    
  }
  
  void drawModalBodyText (String bodyText) {
    
    pushStyle();
    fill(50);
    textFont(fonts.TheSans);
    textAlign(LEFT, TOP);
    text(
      bodyText,
      posX + boxPadding, 
      posY + boxPadding + headerHeight, 
      sizeWidth - (boxPadding * 2), 
      sizeHeight - (boxPadding * 2)
    );
    popStyle();
    
  }
  
  boolean drawNumberField (int w, String label, int value, boolean hasFocus) {
    
    final int labelX = posX + boxPadding;
    final int labelY = posY + boxPadding + numberFieldOffsetTop;
    final int labelW = (int) textWidth(label);
    final int labelH = 24;
    
    final int fieldPadding = 5;
    final int fieldX = posX + boxPadding + labelW + 5;
    final int fieldY = labelY;
    final int fieldW = w + (fieldPadding * 2);
    final int fieldH = 18 + (fieldPadding * 2);
    
    boolean isMouseOverField = mouse.overRect(fieldX, fieldY, fieldW, fieldH);
    
    numberFieldOffsetTop += (fieldH + boxPadding);
    
    pushStyle();
    fill(80);
    textFont(fonts.TheSans);
    textAlign(LEFT, CENTER);
    text(label, labelX, labelY, labelW, labelH);
    popStyle();
    
    pushStyle();
    if (isMouseOverField) {
      fill(220);
      mouse.cursor = HAND;
    } else fill(200);
    if (hasFocus) stroke(230, 100, 0);
    else stroke(180);
    rect(fieldX, fieldY, fieldW, fieldH);
    popStyle();
    
    pushStyle();
    fill(0);
    textFont(fonts.TheSans);
    textAlign(LEFT, CENTER);
    text(str(value), fieldX + fieldPadding, fieldY + fieldPadding, fieldW - (fieldPadding * 2), fieldH - (fieldPadding * 2));
    popStyle();
    
    return isMouseOverField;
    
  }
  
  boolean drawModalButton (String label) {
     
    final int buttonW = (int) textWidth(label) + 25;
    final int buttonH = 30;
    final int buttonX = posX + sizeWidth - buttonW - boxPadding - buttonOffsetRight;
    final int buttonY = posY + sizeHeight - buttonH - boxPadding;
    
    buttonOffsetRight += (buttonW + boxPadding);
    
    boolean isMouseOverButton = mouse.overRect(buttonX, buttonY, buttonW, buttonH);
    
    pushStyle();
    if (isMouseOverButton) {
      fill(215, 125, 250);
      mouse.cursor = HAND;
    } else fill(230, 165, 255);
    rect(buttonX, buttonY, buttonW, buttonH);
    popStyle();
    
    pushStyle();
    if (isMouseOverButton) fill(80, 45, 90);
    else fill(120, 75, 130);
    textFont(fonts.TheSans);
    textAlign(CENTER, CENTER);
    text(label, buttonX, buttonY, buttonW, buttonH);
    popStyle();
    
    return isMouseOverButton;
    
  }
  
  void init () {
    isOpen = false;
    resetOffsets();
  }
  
  void resetOffsets () {
    buttonOffsetRight = 0;
    numberFieldOffsetTop = headerHeight;
  }
  
  //abstract void init();
  abstract void reset();
  abstract void destroy();
  abstract void iterate();

}
