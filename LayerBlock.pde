private class LayerBlock {
  
  final int tileWidth;
  final int tileHeight;
  
  int mapWidth;
  int mapHeight;
  
  int posX;
  int posY;
  int sizeWidth;
  int sizeHeight;
  
  int totalTilesX;
  int totalTilesY;
  
  
  int[][] mapData;
  final int[][] mapDataDefault = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
    {5, 5, 5, 5, 5, 5, 5, 5, 5, 5}
  };
  
  final int[][] mapLegend = {
    {}, // 0
    {0, 0}, // 1
    {60, 0}, // 2
    {120, 0}, // 3
    {0, 60}, // 4
    {60, 60}, // 5
    {120, 60}, // 6
    {180, 0}, // 7
    {180, 60}, // 8
    {240, 60} // 9
  };
  
  LayerBlock (int x, int y, int w, int h) {
    tileWidth = 60;
    tileHeight = 60;
    posX = x;
    posY = y;
  }
  
  void init (int[][] newMapData) {
    mapData = new int[newMapData.length][newMapData[0].length];
    arrayCopy(newMapData, mapData);
    totalTilesX = mapData[0].length;
    totalTilesY = mapData.length;
    mapWidth = tileWidth * totalTilesX;
    mapHeight = tileHeight * totalTilesY;
  }
  
  void reset (int[][] newMapData) {
    init(newMapData);
  }
  
  void redraw () {
    for (int y = 0; y < totalTilesY; y++) {
      for (int x = 0; x < totalTilesX; x++) { 
        int tileType = mapData[y][x];
        int tileX = posX + (x * tileWidth);
        int tileY = posY + (y * tileHeight);
        if (tileType > 0) {
          image(
            resources.tileSheetBlockLayer.get(mapLegend[tileType][0], mapLegend[tileType][1], tileWidth, tileHeight),
            tileX, 
            tileY, 
            tileWidth, 
            tileHeight
          );
        }
        if (
          !viewportScroller.isScrubbing 
          && fileMenu.activeMenuItem < 0
          && !dialog.isOpen
          && !changeMapSizeWindow.isOpen
          && mouse.overRect(tileX + floor(viewportScrubOffsetLeft), tileY, tileWidth, tileHeight)
        ) {
          
          pushStyle();
          fill(0, 120, 255, getAlpha(0.45));
          rect(tileX, tileY, tileWidth, tileHeight);
          popStyle();
          
          if (
            mouse.wasClicked 
            && mouseX < globals.viewportWidth // prevent block placement when user has clicked outside the viewport area (such as the menu pane)
          ){
            switch (activeMapLayer) {
            case 0: 
              mapData[y][x] = selectionPane.selectedTile;
              break;
            case 1:
              if (selectionPane.selectedObject == 0) {
                int n = objectsLayer.onCoord(x, y);
                if (n >= 0) objects.remove(n);
              } else if (selectionPane.selectedObject == 1) {
                objectsLayer.playerTileX = x;
                objectsLayer.playerTileY = y;
              } else {
                int n = objectsLayer.onCoord(x, y);
                if (n >= 0) objects.remove(n);
                int[] a = {x, y, selectionPane.tileAlignment, selectionPane.selectedObject - 2}; // subtract 2 because the first 2 menu items are not technically interactive objects
                objects.add(a);
              }
              break;
            }
          }
        }   
      }
    } 
  }
  
}
