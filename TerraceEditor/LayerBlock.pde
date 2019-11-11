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
    {}, // 0 - empty space
    {0, 0}, // 1 - top left corner
    {60, 0}, // 2 - top middle
    {120, 0}, // 3 - top right corner
    {0, 60}, // 4 - left wall
    {60, 60}, // 5 - solid ground
    {120, 60}, // 6 - right wall
    {180, 0}, // 7 - top shaft
    {180, 60}, // 8 - shaft
    {240, 0}, // 9 - overhang right
    {300, 0}, // 10 - overhang left
    {240, 60} // 11 - overhang both
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

  void iterate () {
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
          && !fileMenu.hasActiveMenuItem()
          && !dialog.isOpen
          && !changeMapSizeWindow.isOpen
          && mouse.overRect(tileX + floor(viewportScrubOffsetLeft), tileY, tileWidth, tileHeight)
        ) {
          pushStyle();
          fill(0, 120, 255, getAlpha(0.45));
          rect(tileX, tileY, tileWidth, tileHeight);
          popStyle();

          // REMINDER: move this somewhere more semantically correct?
          if (
            mouse.wasClicked
            && mouseX < globals.viewportWidth // prevent block placement when user has clicked outside the viewport area (such as the menu pane)
          ) {
            switch (activeMapLayer) {
              case 0:
                blocksLayer.mapData[y][x] = selectionPane.selectedTile;
                break;

              case 1:
                if (selectionPane.selectedObject == 0) {
                  int n = objectsLayer.onCoord(x, y);

                  if (n >= 0) {
                    objects.remove(n);
                  }
                } else if (selectionPane.selectedObject == 1) {
                  objectsLayer.playerTileX = x;
                  objectsLayer.playerTileY = y;
                } else {
                  int n = objectsLayer.onCoord(x, y);

                  if (n >= 0) {
                    objects.remove(n);
                  }

                  int[] a = {x, y, selectionPane.tileAlignment, selectionPane.selectedObject - 2}; // subtract 2 because the first 2 menu items are not technically interactive objects
                  objects.add(a);
                }

                break;

              case 2:
                if (selectionPane.selectedEnemy == 0) {
                  int n = enemyLayer.onCoord(x, y);

                  if (n >= 0) {
                    enemies.remove(n);
                  }
                } else {
                  int n = enemyLayer.onCoord(x, y);

                  if (n >= 0) {
                    enemies.remove(n);
                  }

                  int[] a = {x, y, selectionPane.selectedEnemy - 1}; // subtract 1 because the first menu item is not technically an enemy object
                  enemies.add(a);
                }

                break;
            }
          }
        }
      }
    }
  }
}
