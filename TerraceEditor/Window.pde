abstract class Window {

  final int windowX;
  final int windowY;
  final int windowWidth;
  final int windowHeight;
  final int windowPadding;

  final int headerX;
  final int headerY;
  final int headerWidth;
  final int headerHeight;

  private int buttonOffsetRight = 0;
  private int numberFieldOffsetTop = 0;

  boolean isOpen;

  Window (int w, int h) {
    windowWidth = w;
    windowHeight = h;
    windowX = (applet.width / 2) - (windowWidth / 2);
    windowY = (applet.height / 2) - (windowHeight / 2);
    windowPadding = 10;
    headerX = windowX;
    headerY = windowY;
    headerWidth = windowWidth;
    headerHeight = 30;
  }

  void drawModalBox (String headerText) {
    pushStyle();
    fill(0, getAlpha(0.75));
    rect(0, 0, applet.width, applet.height);
    popStyle();

    pushStyle();
    fill(255);
    rect(windowX, windowY, windowWidth, windowHeight);
    popStyle();

    pushStyle();
    fill(100);
    rect(headerX, headerY, headerWidth, headerHeight);
    popStyle();

    pushStyle();
    fill(240);
    textFont(fonts.AndaleMono);
    textAlign(LEFT, CENTER);
    text(
      headerText,
      headerX + windowPadding,
      headerY,
      headerWidth,
      headerHeight
    );
    popStyle();
  }

  void drawModalBodyText (String bodyText) {
    pushStyle();
    fill(50);
    textFont(fonts.AndaleMono);
    textAlign(LEFT, TOP);
    text(
      bodyText,
      windowX + windowPadding,
      windowY + windowPadding + headerHeight,
      windowWidth - (windowPadding * 2),
      windowHeight - (windowPadding * 2)
    );
    popStyle();
  }

  boolean drawNumberField (int width, String label, int value, boolean hasFocus) {

    final int fieldPadding = 5;
    final int fieldW = width + (fieldPadding * 2);
    final int fieldH = 18 + (fieldPadding * 2);
    final int fieldX = windowX + windowWidth - windowPadding - fieldW;
    final int fieldY = windowY + windowPadding + numberFieldOffsetTop;

    final int labelW = windowWidth - (windowPadding * 2) - fieldW;
    final int labelH = fieldH;
    final int labelX = windowX + windowPadding;
    final int labelY = fieldY;

    boolean isMouseOverField = mouse.overRect(fieldX, fieldY, fieldW, fieldH);
    numberFieldOffsetTop += (fieldH + windowPadding);

    pushStyle();
    fill(80);
    textFont(fonts.AndaleMono);
    textAlign(LEFT, CENTER);
    text(label, labelX, labelY, labelW, labelH);
    popStyle();

    pushStyle();
    fill(isMouseOverField ? 220 : 200);
    stroke(hasFocus ? 230 : 180, hasFocus ? 100 : 180, hasFocus ? 0 : 180);
    rect(fieldX, fieldY, fieldW, fieldH);
    popStyle();

    pushStyle();
    fill(0);
    textFont(fonts.AndaleMono);
    textAlign(LEFT, CENTER);
    text(str(value), fieldX + fieldPadding, fieldY + fieldPadding, fieldW - (fieldPadding * 2), fieldH - (fieldPadding * 2));
    popStyle();

    if (isMouseOverField) {
      mouse.cursor = HAND;
    }

    return isMouseOverField;
  }

  boolean drawModalButton (String label) {
    final int buttonW = (int) textWidth(label) + 25;
    final int buttonH = 30;
    final int buttonX = windowX + windowWidth - buttonW - windowPadding - buttonOffsetRight;
    final int buttonY = windowY + windowHeight - buttonH - windowPadding;

    buttonOffsetRight += (buttonW + windowPadding);
    boolean isMouseOverButton = mouse.overRect(buttonX, buttonY, buttonW, buttonH);

    pushStyle();

    if (isMouseOverButton) {
      fill(215, 125, 250);
      mouse.cursor = HAND;
    } else {
      fill(230, 165, 255);
    }

    rect(buttonX, buttonY, buttonW, buttonH);
    popStyle();

    pushStyle();

    if (isMouseOverButton) {
      fill(80, 45, 90);
    } else {
      fill(120, 75, 130);
    }

    textFont(fonts.AndaleMono);
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

  abstract void reset();
  abstract void destroy();
  abstract void iterate();

}
