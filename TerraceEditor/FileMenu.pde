private class FileMenu {

  private int posX;
  private int posY;
  private int sizeWidth;
  private int sizeHeight;

  private int buttonWidth;
  private int buttonHeight;
  private int buttonPadding;

  private int submenuWidth;
  private int submenuHeight;
  private int submenuButtonWidth;
  private int submenuButtonHeight;
  private int submenuButtonPadding;

  private String[] menuItems;
  private String[] activeSubMenu;
  private String[] subMenuFile;
  private String[] subMenuOptions;

  private int activeMenuItem;
  private int activeSubMenuOffsetLeft;
  private int activeSubMenuOffsetTop;

  private boolean isMouseOverFileMenu;
  private boolean isActive;

  FileMenu (int x, int y, int w, int h) {
    posX = x;
    posY = y;
    sizeWidth = w;
    sizeHeight = h;
    buttonPadding = 3;
    submenuWidth = 140;
    submenuButtonPadding = 3;
    submenuButtonWidth = submenuWidth - (submenuButtonPadding * 2);
    submenuButtonHeight = 24;
    menuItems = new String[] {"File", "Options"};
    subMenuFile = new String[] {"Save..", "Load..", "Close"};
    subMenuOptions = new String[] {"Change Map Size"};
    activeSubMenuOffsetTop = posY + sizeHeight;
  }

  public void init () {
    activeSubMenu = null;
    buttonWidth = 0;
    submenuHeight = 0;
    activeSubMenuOffsetLeft = 0;
    activeMenuItem = -1;
    isMouseOverFileMenu = false;
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
    return activeMenuItem >= 0;
  }

  public void iterate () {
    isMouseOverFileMenu = false;

    pushStyle();
    fill(200);
    rect(posX, posY, sizeWidth, sizeHeight);
    popStyle();

    pushStyle();
    stroke(100);
    line(posX, posY + sizeHeight - 1, posX + sizeWidth - 1, posY + sizeHeight - 1);
    popStyle();

    int buttonX = posX + buttonPadding;
    int buttonY = posY + buttonPadding;

    for (int i = 0; i < menuItems.length; i++) {
      buttonWidth = (int) textWidth(menuItems[i]) + 20;
      buttonHeight = sizeHeight - (buttonPadding * 2) - 1; // the final subtraction of 1 is to compensate for the bottom border
      boolean isMouseOverButton = isActive && mouse.overRect(buttonX, buttonY, buttonWidth, buttonHeight);

      if (isMouseOverButton) {
        isMouseOverFileMenu = true;
        mouse.cursor = HAND;

        if (mouse.wasClicked) {
          switch (i) {
            case 0: activeSubMenu = (activeSubMenu == subMenuFile) ? null : subMenuFile; break;
            case 1: activeSubMenu = (activeSubMenu == subMenuOptions) ? null : subMenuOptions; break;
          }

          activeMenuItem = (activeSubMenu == null) ? -1 : i;
          activeSubMenuOffsetLeft = (activeSubMenu == null) ? 0 : buttonX;
        }
      }

      pushStyle();
      if (isMouseOverButton || activeMenuItem == i) {
        fill(200, 121, 214);
      } else {
        fill(100);
      }
      rect(buttonX, buttonY, buttonWidth, buttonHeight);
      popStyle();

      pushStyle();
      if (isMouseOverButton || activeMenuItem == i) {
        fill(40);
      } else {
        fill(200);
      }
      textFont(fonts.OpenSansRegular);
      textAlign(CENTER, CENTER);
      text(menuItems[i], buttonX + (buttonWidth / 2), buttonY + (buttonHeight / 2));
      popStyle();

      buttonX += buttonPadding + buttonWidth; // update at bottom of loop so as affect the next iteration
    }

    if (activeSubMenu != null) {
      int submenuButtonX = 0;
      int submenuButtonY = 0;
      submenuHeight = submenuButtonPadding + (activeSubMenu.length * (submenuButtonHeight + submenuButtonPadding));
      
      pushStyle();
      fill(200);
      rect(activeSubMenuOffsetLeft, activeSubMenuOffsetTop, submenuWidth, submenuHeight);
      popStyle();
      
      int i = 0;

      while (activeSubMenu != null && i < activeSubMenu.length) {
        submenuButtonX = activeSubMenuOffsetLeft + buttonPadding;
        submenuButtonY = activeSubMenuOffsetTop + buttonPadding + ((submenuButtonHeight + buttonPadding) * i);
        boolean isMouseOverButton = mouse.overRect(submenuButtonX, submenuButtonY, submenuButtonWidth, submenuButtonHeight);
        
        pushStyle();
        if (isMouseOverButton) {
          fill(180);
          isMouseOverFileMenu = true;
          mouse.cursor = HAND;
        } else {
          fill(160);
        }
        rect(submenuButtonX, submenuButtonY, submenuButtonWidth, submenuButtonHeight);
        popStyle();

        pushStyle();
        fill(80);
        textFont(fonts.OpenSansRegular);
        textAlign(LEFT, CENTER);
        text(activeSubMenu[i], submenuButtonX + 8, submenuButtonY + (submenuButtonHeight / 2));
        popStyle();

        if (isMouseOverButton && mouse.wasClicked) {
          switch (activeMenuItem) {
            case 0:
              switch (i) {
                case 0: reset(); exportMap(); break;
                case 1: reset(); requestMapImport(); break;
                case 2: exit(); break;
              }
              break;
            case 1:
              switch (i) {
                case 0:
                  changeMapSizeWindow.show();
                  break;
              }
          }
        }

        i++;
      }
    }

    if (isActive && mouse.wasClicked && !isMouseOverFileMenu && activeMenuItem >= 0) {
      reset();
    }
  }

}
