public class Scrollbar {

  // used to translate the viewport
  // values range from 0 to 1
  public float scrubValueX;
  public float scrubValueY;

  private boolean isScrubbingHorizontal;
  private boolean isScrubbingVertical;
  private boolean isDisabledHorizontal;
  private boolean isDisabledVertical;

  private final int containerPadding;

  // scrub bar container position
  private final int containerHorizontalPosX;
  private final int containerHorizontalPosY;
  private final int containerVerticalPosX;
  private final int containerVerticalPosY;

  // scrub bar dimensions
  private final int barHorizontalLength;
  private final int barHorizontalThickness;
  private final int barVerticalLength;
  private final int barVerticalThickness;

  // the current scrollbar position in pixels
  private int scrubHorizontalX;
  private int scrubHorizontalY;
  private int scrubVerticalX;
  private int scrubVerticalY;

  // the current mouse position relative the scrub bar at the moment of activation (on click)
  // used to calculate the change in scrub bar position while dragging
  private int scrubOffsetX;
  private int scrubOffsetY;

  Scrollbar () {
    containerHorizontalPosX = globals.viewportX;
    containerHorizontalPosY = globals.viewportY + globals.viewportHeight;
    containerVerticalPosX = globals.viewportX + globals.viewportWidth;
    containerVerticalPosY = globals.viewportY;
    containerPadding = 2;
    barHorizontalLength = barVerticalLength = 100 - (containerPadding * 2);
    barHorizontalThickness = barVerticalThickness = globals.viewportScrollbarThickness - (containerPadding * 2);
  }

  void init () {
    resetHorizontal();
    resetVertical();
  }

  void resetHorizontal () {
    scrubHorizontalX = containerHorizontalPosX + containerPadding;
    scrubHorizontalY = containerHorizontalPosY + containerPadding;
    isScrubbingHorizontal = false;
    isDisabledHorizontal = false;
    scrubOffsetX = 0;
    scrubValueX = 0;
  }

  void resetVertical () {
    scrubVerticalX = containerVerticalPosX + containerPadding;
    scrubVerticalY = containerVerticalPosY + containerPadding;
    isScrubbingVertical = false;
    isDisabledVertical = false;
    scrubOffsetY = 0;
    scrubValueY = 0;
  }

  void iterate () {
    if (isHorizontalScrubActive() == true) {
      mouse.cursor = HAND;
      if (mouse.isActive) {
        calculateHorizontalScrubValues();
      } else {
        isScrubbingHorizontal = false;
      }
    }

    if (isVerticalScrubActive() == true) {
      mouse.cursor = HAND;
      if (mouse.isActive) {
        calculateVerticalScrubValues();
      } else {
        isScrubbingVertical = false;
      }
    }

    drawHorizontalContainer();
    drawVerticalContainer();

    if (!isDisabledHorizontal) drawHorizontalScrubber();
    if (!isDisabledVertical) drawVerticalScrubber();
  }

  public void checkHorizontal (int mapWidth, int viewportWidth) {
    if (mapWidth <= viewportWidth) {
      isDisabledHorizontal = true;
    } else {
      resetHorizontal();
    }
  }

  public void checkVertical (int mapHeight, int viewportHeight) {
    if (mapHeight <= viewportHeight) {
      isDisabledVertical = true;
    } else {
      resetVertical();
    }
  }

  public boolean isScrubbing () {
    return isScrubbingHorizontal || isScrubbingVertical;
  }

  private void calculateHorizontalScrubValues () {
    if (!isScrubbingHorizontal) {
      isScrubbingHorizontal = true;
      scrubOffsetX = mouseX - scrubHorizontalX;
    }

    scrubHorizontalX = mouseX - scrubOffsetX;

    // hitting left boundary
    if (scrubHorizontalX < containerHorizontalPosX + containerPadding) {
      scrubHorizontalX = containerHorizontalPosX + containerPadding;
    // hitting right boundary
    } else if (scrubHorizontalX > globals.viewportScrollbarLength + containerHorizontalPosX - barHorizontalLength - containerPadding) {
      scrubHorizontalX = globals.viewportScrollbarLength + containerHorizontalPosX - barHorizontalLength - containerPadding;
    }

    scrubValueX = (scrubHorizontalX - containerPadding - containerHorizontalPosX) / (float) (globals.viewportScrollbarLength + containerHorizontalPosX - barHorizontalLength - (containerPadding * 2));
  }

  private void calculateVerticalScrubValues () {
    if (!isScrubbingVertical) {
      isScrubbingVertical = true;
      scrubOffsetY = mouseY - scrubVerticalY;
    }

    scrubVerticalY = mouseY - scrubOffsetY;

    // hitting top boundary
    if (scrubVerticalY < containerVerticalPosY + containerPadding) {
      scrubVerticalY = containerVerticalPosY + containerPadding;
    // hitting bottom boundary
    } else if (scrubVerticalY > globals.viewportScrollbarLength + containerVerticalPosY - barVerticalLength - containerPadding) {
      scrubVerticalY = globals.viewportScrollbarLength + containerVerticalPosY - barVerticalLength - containerPadding;
    }

    scrubValueY = (scrubVerticalY - containerPadding - containerVerticalPosY) / (float) (globals.viewportScrollbarLength - barVerticalLength - (containerPadding * 2));
  }

  private boolean isHorizontalScrubActive () {
    return (
      !isDisabledHorizontal
      && !dialog.isOpen
      && !changeMapSizeWindow.isOpen
      && (
        isScrubbingHorizontal
        || mouse.overRect(scrubHorizontalX, scrubHorizontalY, barHorizontalLength, barHorizontalThickness)
      )
    );
  }

  private boolean isVerticalScrubActive () {
    return (
      !isDisabledVertical
      && !dialog.isOpen
      && !changeMapSizeWindow.isOpen
      && (
        isScrubbingVertical
        || mouse.overRect(scrubVerticalX, scrubVerticalY, barVerticalThickness, barVerticalLength)
      )
    );
  }

  private void drawHorizontalContainer () {
    pushStyle();
    fill(200);
    rect(containerHorizontalPosX, containerHorizontalPosY, globals.viewportScrollbarLength, globals.viewportScrollbarThickness);
    popStyle();
  }

  private void drawVerticalContainer () {
    pushStyle();
    fill(200);
    rect(containerVerticalPosX, containerVerticalPosY, globals.viewportScrollbarThickness, globals.viewportScrollbarLength);
    popStyle();
  }

  private void drawHorizontalScrubber () {
    pushStyle();
    fill(100);
    rect(scrubHorizontalX, scrubHorizontalY, barHorizontalLength, barHorizontalThickness);
    popStyle();
    image(
      resources.srubberHorizontal,
      scrubHorizontalX + (barHorizontalLength / 2) - 4,
      scrubHorizontalY + (barHorizontalThickness / 2) - 4,
      9,
      8
    );
  }

  private void drawVerticalScrubber () {
    pushStyle();
    fill(100);
    rect(scrubVerticalX, scrubVerticalY, barVerticalThickness, barVerticalLength);
    popStyle();
    image(
      resources.srubberVertical,
      scrubVerticalX + (barVerticalThickness / 2) - 4,
      scrubVerticalY + (barVerticalLength / 2) - 4,
      8,
      9
    );
  }

}
