private class LayerObject {

  final int posX;
  final int posY;

  int playerTileX;
  int playerTileY;

  // x, y, w, h
  final int[][] objectLegend = {
    {32, 30, 32, 30}, // spring weak
    {0, 30, 32, 30}, // spring strong
    {0, 60, 128, 121}, // tree
    {64, 12, 32, 48}, // sign
    {96, 28, 16, 16}, // coin
    {128, 28, 46, 32}, // rock
    {174, 12, 24, 48}, // bean stock
    {198, 38, 30, 22} // shrub
  };

  LayerObject (int x, int y, int w, int h) {
    posX = x;
    posY = y;
  }

  void init () {
    playerTileX = 0;
    playerTileY = 7;
  }

  void reset () {
    init();
  }

  void iterate () {
    int tileX;
    int tileY;
    int objectX = 0;
    int objectY = 0;
    int objectAlignment;
    int objectType;
    int spriteWidth;
    int spriteHeight;
    int[] objectData;
    int[] spriteData;

    for (int i = 0, ii = objects.size(); i < ii; i++) {
      // 0 = tileX
      // 1 = tileY
      // 2 = objectAlignment
      // 3 = objectType
      objectData = (int[]) objects.get(i);
      tileX = objectData[0];
      tileY = objectData[1];
      objectAlignment = objectData[2];
      objectType = objectData[3];
      // 0 = spriteX
      // 1 = spriteY
      // 2 = spriteWidth
      // 3 = spriteHeight
      spriteData = objectLegend[objectType];
      spriteWidth = spriteData[2];
      spriteHeight = spriteData[3];

      // 1 = top left
      // 2 = top middle
      // 3 = top right
      // 4 = middle right
      // 5 = bottom right
      // 6 = bottom middle
      // 7 = bottom left
      // 8 = middle left
      switch (objectAlignment) {
        case 1:
          objectX = tileX * blocksLayer.tileWidth;
          objectY = tileY * blocksLayer.tileHeight;
          break;

        case 2:
          objectX = (tileX * blocksLayer.tileWidth) + (blocksLayer.tileWidth / 2) - (spriteWidth / 2);
          objectY = tileY * blocksLayer.tileHeight;
          break;

        case 3:
          objectX = (tileX * blocksLayer.tileWidth) + blocksLayer.tileWidth - spriteWidth;
          objectY = tileY * blocksLayer.tileHeight;
          break;

        case 4:
          objectX = (tileX * blocksLayer.tileWidth) + blocksLayer.tileWidth - spriteWidth;
          objectY = (tileY * blocksLayer.tileHeight) + (blocksLayer.tileHeight / 2) - (spriteHeight / 2);
          break;

        case 5:
          objectX = (tileX * blocksLayer.tileWidth) + blocksLayer.tileWidth - spriteWidth;
          objectY = (tileY * blocksLayer.tileHeight) + blocksLayer.tileHeight - spriteHeight;
          break;

        case 6:
          objectX = (tileX * blocksLayer.tileWidth) + (blocksLayer.tileWidth / 2) - (spriteWidth / 2);
          objectY = (tileY * blocksLayer.tileHeight) + blocksLayer.tileHeight - spriteHeight;
          break;

        case 7:
          objectX = tileX * blocksLayer.tileWidth;
          objectY = (tileY * blocksLayer.tileHeight) + blocksLayer.tileHeight - spriteHeight;
          break;

        case 8:
          objectX = tileX * blocksLayer.tileWidth;
          objectY = (tileY * blocksLayer.tileHeight) + (blocksLayer.tileHeight / 2) - (spriteHeight / 2);
          break;
      }

      image(
        resources.tileSheetObjectLayer.get(spriteData[0], spriteData[1], spriteWidth, spriteHeight),
        posX + objectX,
        posY + objectY,
        spriteWidth,
        spriteHeight
      );
    }

    image(
      resources.playerHeadSprite,
      posX + (playerTileX * blocksLayer.tileWidth) + 21,
      posY + (playerTileY * blocksLayer.tileHeight) + 21,
      18,
      18
    );
  }

  int onCoord (int x, int y) {
    int[] obj;

    for (int i = 0, ii = objects.size(); i < ii; i++) {
      obj = (int[]) objects.get(i);

      if (obj[0] == x && obj[1] == y) {
        return i;
      }
    }

    return -1;
  }

}
