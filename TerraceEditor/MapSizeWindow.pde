private class MapSizeWindow extends Window {
  
  int newTotalTilesX;
  int newTotalTilesY;
  int inputFocus;
  
  MapSizeWindow (int w, int h) {
    super(w, h);
  }
  
  void init () {
    super.init();
    newTotalTilesX = blocksLayer.mapData[0].length;
    newTotalTilesY = blocksLayer.mapData.length;
    inputFocus = 0;
  }
  
  void reset () {
    init();
  }
  
  void destroy () {
    reset();
  }
  
  void iterate () {
    
    int value = -1;
    super.resetOffsets();

    if (super.isOpen) {
      
      super.drawModalBox("Change Map Size");

      switch (inputFocus) {
        case 1: value = newTotalTilesX; break;
        case 2: value = newTotalTilesY; break;
      }
      
      if (keyboard.wasPressed && value >= 0) {
        if (keyboard.keyDel || keyboard.keyBack) {
          value = value / 10;
        } else if (
          Character.isDigit(keyboard.currentKeyCode) 
          && value < 100000000 // do not allow the int to exceed 9 digits
        ) {
          value = value * 10 + Character.getNumericValue(keyboard.currentKeyCode);
        } else if (
          keyboard.currentKeyCode >= 96 
          && keyboard.currentKeyCode <= 105
          && value < 100000000 // do not allow the int to exceed 9 digits
        ) {
          switch (keyboard.currentKeyCode) {
            case 96: value = value * 10 + 0; break;
            case 97: value = value * 10 + 1; break;
            case 98: value = value * 10 + 2; break;
            case 99: value = value * 10 + 3; break;
            case 100: value = value * 10 + 4; break;
            case 101: value = value * 10 + 5; break;
            case 102: value = value * 10 + 6; break;
            case 103: value = value * 10 + 7; break;
            case 104: value = value * 10 + 8; break;
            case 105: value = value * 10 + 9; break;
          }
        }
        switch (inputFocus) {
          case 1: newTotalTilesX = value; break;
          case 2: newTotalTilesY = value; break;
        }
      }
      
      if (super.drawNumberField(200, "# of tiles X: ", newTotalTilesX, (inputFocus == 1)) && mouse.wasClicked) { inputFocus = 1; newTotalTilesX = 0; }
      if (super.drawNumberField(200, "# of tiles Y: ", newTotalTilesY, (inputFocus == 2)) && mouse.wasClicked) { inputFocus = 2; newTotalTilesY= 0; }
      
      if (super.drawModalButton("Close") == true && mouse.wasClicked) hide();
      if (super.drawModalButton("Apply & Close") == true && mouse.wasClicked) {
        if (newTotalTilesX > 9 && newTotalTilesY > 9) {
          int[][] newMapData = new int[newTotalTilesY][newTotalTilesX];
          for (int y = 0; y < newTotalTilesY; y++) {
            for (int x = 0; x < newTotalTilesX; x++) { 
              try { newMapData[y][x] = blocksLayer.mapData[y][x];
              } catch (ArrayIndexOutOfBoundsException e) { newMapData[y][x] = 0;
              }
            }
          }
          blocksLayer.reset(newMapData);
          viewportScrubOffsetLeft = 0;
          viewportScroller.check(blocksLayer.mapWidth, globals.viewportWidth);
          hide();
        } else error("The map requires at least ten or more tiles to be valid.");
      }
      
    }
  }
  
  void show () { reset(); super.isOpen = true; fileMenu.reset(); fileMenu.deactivate(); }
  void hide () { reset(); super.isOpen = false; fileMenu.activate(); }
  void error (String msg) { hide(); dialog.error(msg); }
 
}
