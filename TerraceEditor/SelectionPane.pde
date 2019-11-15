public class SelectionPane {

  final int buttonSpacing = 5;
  final int menuContentOffsetTop = 40;

  final int posX;
  final int posY;
  final int sizeWidth;
  final int sizeHeight;

  int selectedTab;
  int selectedTile;
  int selectedObject;
  int selectedEnemy;
  int buttonRowCount;
  int buttonCount;
  int tileAlignment;

  // sprite x, sprite y, sprite width, sprite height, alignment value
  final int[][] alignmentButtonData = {
    {0, 0, 13, 13, 1}, // top left
    {13, 0, 13, 13, 2}, // top middle
    {26, 0, 13, 13, 3}, // top right
    {0, 13, 13, 13, 8}, // middle left
    {26, 13, 13, 13, 4}, // middle right
    {0, 26, 13, 13, 7}, // bottom left
    {13, 26, 13, 13, 6}, // bottom middle
    {26, 26, 13, 13, 5} // bottom right
  };

  SelectionPane (int x, int y, int w, int h) {
    posX = x;
    posY = y;
    sizeWidth = w;
    sizeHeight = h;
    init();
  }

  void init () {
    tileAlignment = 6;
    buttonRowCount = 0;
    buttonCount = 0;
    selectedTab = 0;
    selectedTile = 0;
    selectedObject = 0;
    selectedEnemy = 0;
  }

  void iterate () {
    pushStyle();
    fill(255);
    rect(posX, posY, sizeWidth, sizeHeight);
    popStyle();

    buttonRowCount = 0;
    buttonCount = 0;

    drawTab(0, resources.globeIcon);
    drawTab(1, resources.homeIcon);
    drawTab(2, resources.birdIcon);

    switch (selectedTab) {
      case 0: drawTilePane(); break;
      case 1: drawObjectPane(); break;
      case 2: drawEnemyPane(); break;
    }
  }

  private void drawTilePane () {
    drawButton(
      0, 0, 32, 32,
      resources.eraserSprite,
      color(220)
    );

    // note: start increment at 1 NOT 0 because the first record is null
    for (int i = 1; i < blocksLayer.mapLegend.length; i++) {
      drawButton(
        blocksLayer.mapLegend[i][0],
        blocksLayer.mapLegend[i][1],
        blocksLayer.tileWidth,
        blocksLayer.tileHeight,
        resources.tileSheetBlockLayer,
        color(255)
      );
    }
  }

  private void drawObjectPane () {
    drawButton(
      0, 0, 32, 32,
      resources.eraserSprite,
      color(220)
    );

    drawButton(
      0, 0, 18, 18,
      resources.playerHeadSprite,
      color(220)
    );

    for (int i = 0; i < objectsLayer.objectLegend.length; i++) {
      drawButton(
        objectsLayer.objectLegend[i][0],
        objectsLayer.objectLegend[i][1],
        // do not allow sprite dimensions to exceed the bounding button
        (objectsLayer.objectLegend[i][2] <= 60 ) ? objectsLayer.objectLegend[i][2] : 60,
        (objectsLayer.objectLegend[i][3] <= 60 ) ? objectsLayer.objectLegend[i][3] : 60,
        resources.tileSheetObjectLayer,
        color(220)
      );
    }

    drawAlignmentPad();
  }

  private void drawEnemyPane () {
    drawButton(
      0, 0, 32, 32,
      resources.eraserSprite,
      color(220)
    );

    for (int i = 0; i < enemyLayer.enemyLegend.length; i++) {
      drawButton(
        enemyLayer.enemyLegend[i][0],
        enemyLayer.enemyLegend[i][1],
        // do not allow sprite dimensions to exceed the bounding button
        (enemyLayer.enemyLegend[i][2] <= 60 ) ? enemyLayer.enemyLegend[i][2] : 60,
        (enemyLayer.enemyLegend[i][3] <= 60 ) ? enemyLayer.enemyLegend[i][3] : 60,
        enemyLayer.spriteLegend[i],
        color(220)
      );
    }
  }

  private void drawAlignmentPad () {
    int alignPadX = posX + 10;
    int alignPadY = posY + sizeHeight - (13*3) - 10;

    for (int i = 0; i < alignmentButtonData.length; i++) {
      int[] button = alignmentButtonData[i];

      if (
        !dialog.isOpen
        && !changeMapSizeWindow.isOpen
        && mouse.overRect(
          alignPadX + button[0],
          alignPadY + button[1],
          button[2],
          button[3]
        )
      ) {
        mouse.cursor = HAND;
        if (mouse.wasClicked) {
          tileAlignment = button[4];
        }
      }

      pushStyle();

      if (button[4] == tileAlignment) {
        fill(200, 121, 214);
      } else {
        fill(200);
      }

      rect(
        alignPadX + button[0],
        alignPadY + button[1],
        button[2],
        button[3]
      );

      popStyle();
    }

    image(resources.alignmentSprite, alignPadX, alignPadY, 39, 39);
  }

  private void drawButton (int x, int y, int w, int h, PImage gfx, color c) {
    int tileX = posX;
    int tileY = posY + menuContentOffsetTop + buttonSpacing + buttonRowCount * (blocksLayer.tileHeight + buttonSpacing);

    if (buttonCount % 2 == 0) {
      tileX += buttonSpacing;
    } else {
      tileX += blocksLayer.tileWidth + (buttonSpacing * 2);
      buttonRowCount++;
    }

    checkTile(tileX, tileY, blocksLayer.tileWidth, blocksLayer.tileHeight, buttonCount);

    if (c < -1) { // color white equates to -1
      pushStyle();
      fill(c);
      rect(tileX, tileY, blocksLayer.tileWidth, blocksLayer.tileHeight);
      popStyle();
    }

    PImage sprite = getImageSlice(gfx, x, y, w, h);
    image(
      sprite,
      tileX + (blocksLayer.tileWidth / 2) - (w / 2),
      tileY + (blocksLayer.tileHeight / 2) - (h / 2),
      w,
      h
    );

    buttonCount++;
  }

  private void drawTab (int i, PImage tabIcon) {
    int tabWidth = 45;
    int tabHeight = 30;
    int tabX = posX + (tabWidth * i);
    int tabY = posY;

    boolean isMouseOver = mouse.overRect(tabX, tabY, tabWidth, tabHeight);
    pushStyle();

    if (selectedTab == i) {
      fill(255);
    } else if (isMouseOver && !dialog.isOpen && !changeMapSizeWindow.isOpen) {
      fill(220);
    } else {
      fill(200);
    }

    rect(tabX, tabY, tabWidth, tabHeight);
    popStyle();
    image(tabIcon, tabX + 10, tabY + 3, 24, 24);

    if (selectedTab != i) {
      pushStyle();
      stroke(100);
      line(tabX, tabY + tabHeight - 1, tabX + tabWidth - 1, tabY + tabHeight - 1);
      popStyle();

      if (i < 2) {
        pushStyle();
        stroke(175);
        line(tabX + tabWidth - 1, tabY, tabX + tabWidth - 1, tabY + tabHeight - 2);
        popStyle();
      }
    } else {
      pushStyle();
      stroke(100);

      if (i > 0) {
        line(tabX - 1, tabY, tabX - 1, tabY + tabHeight - 1);
      }

      if (i < 2) {
        line(tabX + tabWidth - 1, tabY, tabX + tabWidth - 1, tabY + tabHeight - 1);
      }

      popStyle();
    }

    if (isMouseOver && !dialog.isOpen && !changeMapSizeWindow.isOpen) {
      mouse.cursor = HAND;

      if (mouse.wasClicked) {
        selectedTab = i;
        activeMapLayer = i;
      }
    }
  }

  private void checkTile (int x, int y, int w, int h, int i) {
    boolean isMouseOver = mouse.overRect(x, y, w, h);
    boolean isTileSelected = false;
    int sel = 0;

    if (
      isMouseOver
      && !dialog.isOpen
      && !changeMapSizeWindow.isOpen
      && !viewportScroller.isScrubbing()
      && !fileMenu.hasActiveMenuItem()
    ) {
      mouse.cursor = HAND;
      if (mouse.wasClicked) {
        switch (selectedTab) {
          case 0: selectedTile = i; break;
          case 1: selectedObject = i; break;
          case 2: selectedEnemy = i; break;
        }
      }
    }

    switch (selectedTab) {
      case 0: sel = selectedTile; break;
      case 1: sel = selectedObject; break;
      case 2: sel = selectedEnemy; break;
    }

    // draw active/hover borders
    isTileSelected = sel == i;
    if (
      (isTileSelected || isMouseOver)
      && !dialog.isOpen
      && !changeMapSizeWindow.isOpen
      && !viewportScroller.isScrubbing()
      && !fileMenu.hasActiveMenuItem()
    ) {
      pushStyle();
      fill(0, 120, 255);
      rect(x - 2, y - 2, w + 4, w + 4);
      popStyle();
    }
  }
}
