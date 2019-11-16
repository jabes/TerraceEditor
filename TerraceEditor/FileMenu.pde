private class FileMenu {

  private int posX;
  private int posY;
  private int sizeWidth;
  private int sizeHeight;

  private boolean isActive;
  private boolean isMouseOverMenu;
  private int activeMenuItem;

  private int menuButtonWidth;
  private int menuButtonHeight;
  private int menuButtonPadding;

  private int subMenuWidth;
  private int subMenuHeight;
  private int subMenuOffsetLeft;
  private int subMenuOffsetTop;
  private int subMenuButtonWidth;
  private int subMenuButtonHeight;
  private int subMenuButtonPadding;

  private String[] menuItems;
  private String[] subMenuItems;
  private String[] subMenuFile;
  private String[] subMenuOptions;

  FileMenu (int x, int y, int w, int h) {
    posX = x;
    posY = y;
    sizeWidth = w;
    sizeHeight = h;
    menuItems = new String[] {"File", "Options"};
    subMenuFile = new String[] {"Save..", "Load..", "Close"};
    subMenuOptions = new String[] {"Change Map Size"};
  }

  public void init () {
    menuButtonPadding = 3;
    menuButtonWidth = 0; // calculated during draw based on inner text size
    menuButtonHeight = sizeHeight - (menuButtonPadding * 2) - 1; // the final subtraction of 1 is to compensate for the bottom border
    subMenuItems = null;
    subMenuWidth = 140;
    subMenuHeight = 0; // calculated during draw based on how many items are in the active sub-menu
    subMenuOffsetTop = posY + sizeHeight;
    subMenuOffsetLeft = 0; // calculated during draw based on which parent menu item is active
    subMenuButtonPadding = 3;
    subMenuButtonWidth = subMenuWidth - (subMenuButtonPadding * 2);
    subMenuButtonHeight = 24;
    activeMenuItem = -1;
  }

  public void reset () {
    init();
  }

  public void deactivate () {
    isActive = false;
  }

  public void activate () {
    isActive = true;
  }

  public boolean hasActiveMenuItem () {
    return activeMenuItem > -1;
  }

  public void iterate () {
    // start as false and evaluate as true while drawing the menu
    isMouseOverMenu = false;
    // always draw the parent menu
    drawMenu();
    // draw the sub menu if it was defined
    if (subMenuItems != null) {
      drawSubMenu();
    }
    // close the active menu if mouse was clicked outside of it
    if (hasActiveMenuItem() && mouse.wasClicked && !isMouseOverMenu) {
      reset();
    }
  }

  private int getButtonWidth (String menuItemText) {
    textFont(fonts.VcrOsdMono);
    return (int) textWidth(menuItemText) + 20;
  }

  private void drawMenu () {
    // initial placement which is incremented for each button
    int menuButtonX = posX + menuButtonPadding;
    int menuButtonY = posY + menuButtonPadding;

    drawMenuBackground();

    for (int menuButtonIndex = 0; menuButtonIndex < menuItems.length; menuButtonIndex++) {
      menuButtonWidth = getButtonWidth(menuItems[menuButtonIndex]);
      boolean isMouseOverButton = isActive && mouse.overRect(menuButtonX, menuButtonY, menuButtonWidth, menuButtonHeight);
      // create menu button
      drawMenuButton(menuButtonIndex, menuButtonX, menuButtonY, isMouseOverButton);
      executeMenuButtonActions(menuButtonIndex, isMouseOverButton);
      // use the current active menu button to determine the sub menu offset
      if (activeMenuItem == menuButtonIndex) {
        subMenuOffsetLeft = menuButtonX - subMenuButtonPadding;
      }
      // update at bottom of loop so as affect the next iteration
      menuButtonX += menuButtonPadding + menuButtonWidth;
    }
  }

  private void drawMenuBackground () {
    // draw menu background
    pushStyle();
    fill(200);
    rect(posX, posY, sizeWidth, sizeHeight);
    popStyle();
    // add bottom border to menu
    pushStyle();
    stroke(100);
    line(posX, posY + sizeHeight - 1, posX + sizeWidth - 1, posY + sizeHeight - 1);
    popStyle();
  }

  private void drawMenuButton (int menuButtonIndex, int menuButtonX, int menuButtonY, boolean isMouseOverButton) {
    // button state is active if mouse over or clicked
    boolean isMenuButtonActive = isMouseOverButton || activeMenuItem == menuButtonIndex;
    // draw button rectangle
    pushStyle();
    fill(isMenuButtonActive ? 200 : 100, isMenuButtonActive ? 121 : 100, isMenuButtonActive ? 214 : 100);
    rect(menuButtonX, menuButtonY, menuButtonWidth, menuButtonHeight);
    popStyle();
    // draw button text
    pushStyle();
    fill(isMenuButtonActive ? 40 : 200);
    textFont(fonts.VcrOsdMono);
    textAlign(CENTER, CENTER);
    text(
      menuItems[menuButtonIndex],
      menuButtonX + (menuButtonWidth / 2),
      menuButtonY + (menuButtonHeight / 2)
    );
    popStyle();
  }

  private void executeMenuButtonActions (int menuButtonIndex, boolean isMouseOverButton) {
    if (isMouseOverButton) {
      mouse.cursor = HAND;
      isMouseOverMenu = true;
      if (mouse.wasClicked) {
        activeMenuItem = menuButtonIndex;
        switch (menuButtonIndex) {
          case 0: subMenuItems = subMenuFile; break;
          case 1: subMenuItems = subMenuOptions; break;
        }
      }
    }
  }

  private void drawSubMenu () {
    calcSubMenuHeight();
    drawSubMenuBackground();

    int subMenuButtonIndex = 0;
    while (subMenuItems != null && subMenuButtonIndex < subMenuItems.length) {
      int subMenuButtonX = subMenuOffsetLeft + subMenuButtonPadding;
      int subMenuButtonY = subMenuOffsetTop + subMenuButtonPadding + ((subMenuButtonHeight + subMenuButtonPadding) * subMenuButtonIndex);
      boolean isMouseOverButton = mouse.overRect(subMenuButtonX, subMenuButtonY, subMenuButtonWidth, subMenuButtonHeight);
      drawSubMenuButton(subMenuButtonIndex, subMenuButtonX, subMenuButtonY, isMouseOverButton);
      executeSubMenuButtonActions(subMenuButtonIndex, isMouseOverButton);
      subMenuButtonIndex++;
    }
  }

  private void calcSubMenuHeight () {
    subMenuHeight = subMenuButtonPadding + (
                      subMenuItems.length * (
                        subMenuButtonHeight + subMenuButtonPadding
                      )
                    );
  }

  private void drawSubMenuBackground () {
    pushStyle();
    fill(200);
    rect(subMenuOffsetLeft, subMenuOffsetTop, subMenuWidth, subMenuHeight);
    popStyle();
  }

  private void drawSubMenuButton (int subMenuButtonIndex, int subMenuButtonX, int subMenuButtonY, boolean isMouseOverButton) {
    // draw button rectangle
    pushStyle();
    fill(isMouseOverButton ? 180 : 160);
    rect(subMenuButtonX, subMenuButtonY, subMenuButtonWidth, subMenuButtonHeight);
    popStyle();
    // draw button text
    pushStyle();
    fill(isMouseOverButton ? 80 : 60);
    textFont(fonts.VcrOsdMono);
    textAlign(LEFT, CENTER);
    text(
      subMenuItems[subMenuButtonIndex],
      subMenuButtonX + 8,
      subMenuButtonY + (subMenuButtonHeight / 2)
    );
    popStyle();
  }

  private void executeSubMenuButtonActions (int subMenuButtonIndex, boolean isMouseOverButton) {
    if (isMouseOverButton) {
      mouse.cursor = HAND;
      isMouseOverMenu = true;
      if (mouse.wasClicked) {
        switch (activeMenuItem) {
          case 0:
            switch (subMenuButtonIndex) {
              case 0: reset(); exportMap(); break;
              case 1: reset(); requestMapImport(); break;
              case 2: exit(); break;
            }
            break;
          case 1:
            switch (subMenuButtonIndex) {
              case 0: changeMapSizeWindow.show(); break;
            }
            break;
        }
      }
    }
  }
}
