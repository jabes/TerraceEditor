private class FileMenu {
  
  final int posX;
  final int posY;
  final int sizeWidth;
  final int sizeHeight;
  
  int buttonWidth;
  final int buttonHeight;
  final int buttonPadding;
  
  final int submenuWidth;
  int submenuHeight;
  final int submenuButtonWidth;
  final int submenuButtonHeight;
  final int submenuButtonPadding;
  
  final String[] menuItems;
  
  String[] activeSubMenu;
  String[] subMenuFile;
  String[] subMenuOptions;
  
  int activeMenuItem;
  int activeSubMenuOffsetLeft;
  final int activeSubMenuOffsetTop;
  
  boolean isMouseOverFileMenu; 
  boolean isActive;
  
  FileMenu (int x, int y, int w, int h) {
    
    posX = x;
    posY = y;
    sizeWidth = w;
    sizeHeight = h;
    
    buttonPadding = 3;
    //buttonWidth = 80;
    buttonHeight = sizeHeight - (buttonPadding * 2) - 1; // the final subtraction of 1 is to compensate for the bottom border
    
    submenuWidth = 140;
    submenuButtonPadding = 3;
    submenuButtonWidth = submenuWidth - (submenuButtonPadding * 2);
    submenuButtonHeight = 24;
    
    menuItems = new String[]{"File", "Options"};
    subMenuFile = new String[]{"Save..", "Load..", "Close"};
    subMenuOptions = new String[]{"Change Map Size"};
    
    activeSubMenuOffsetTop = posY + sizeHeight;
 
  }
  
  void init () {
    activeSubMenu = null;
    buttonWidth = 0;
    submenuHeight = 0;
    activeSubMenuOffsetLeft = 0;
    activeMenuItem = -1;
    isMouseOverFileMenu = false;
    isActive = true;
    System.out.println("init");
  } 
  
  void reset () {
    init();
    // mouse coords are not updated when the sketch has lost focus, so temporarily spoof them so they don't play havoc on the UI
    //applet.mouseX = applet.mouseY = 0;
  }

  void deactivate () { reset(); isActive = false; System.out.println("deactivate"); }  
  void activate () { isActive = true; }
  
  void redraw () {
    
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
      if (isMouseOverButton || activeMenuItem == i) fill(200, 121, 214);
      else fill(100);
      rect(buttonX, buttonY, buttonWidth, buttonHeight);
      popStyle();
      
      pushStyle();
      if (isMouseOverButton || activeMenuItem == i) fill(40);
      else fill(200);
      textFont(fonts.TheSans);
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
      while(activeSubMenu != null && i < activeSubMenu.length) {
        
        submenuButtonX = activeSubMenuOffsetLeft + buttonPadding;
        submenuButtonY = activeSubMenuOffsetTop + buttonPadding + ((submenuButtonHeight + buttonPadding) * i);
        
        boolean isMouseOverButton = mouse.overRect(submenuButtonX, submenuButtonY, submenuButtonWidth, submenuButtonHeight);
        
        pushStyle();
        if (isMouseOverButton) {
          fill(180);
          isMouseOverFileMenu = true;
          mouse.cursor = HAND;
        } else fill(160);
        rect(submenuButtonX, submenuButtonY, submenuButtonWidth, submenuButtonHeight);
        popStyle();
        
        pushStyle();
        fill(80);
        textFont(fonts.TheSans);
        textAlign(LEFT, CENTER);
        text(activeSubMenu[i], submenuButtonX + 8, submenuButtonY + (submenuButtonHeight / 2));
        popStyle();
        
        if (isMouseOverButton && mouse.wasClicked) {
          switch (activeMenuItem) {
          case 0: 
            switch (i) {
              case 0: exportMap(); break;
              case 1: requestMapImport(); break;
              case 2: exit(); break; 
            }
            break;
          case 1: 
            switch (i) {
              case 0: changeMapSizeWindow.show(); break;
            }
          }
        }
        
        i++;

      } 
    }
  
    if (isActive && mouse.wasClicked && !isMouseOverFileMenu) reset();
      
  }
  
}
