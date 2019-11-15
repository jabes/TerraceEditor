private class LayerEnemy {

  final int posX;
  final int posY;

  int tileX;
  int tileY;
  int enemyX;
  int enemyY;
  int enemyType;
  int spriteWidth;
  int spriteHeight;
  int[] enemyData;
  int[] spriteData;

  // x, y, w, h
  final int[][] enemyLegend = {
    {0, 0, 45, 56},
    {0, 0, 27, 32}
  };

  final PImage[] spriteLegend = {
    resources.tileSheetGilliamKnight,
    resources.tileSheetKintot
  };

  LayerEnemy (int x, int y, int w, int h) {
    posX = x;
    posY = y;
  }

  void init () {}
  void reset () {
    init();
  }

  void iterate () {
    for (int i = 0, ii = enemies.size(); i < ii; i++) {
      // 0 = tileX
      // 1 = tileY
      // 3 = enemyType
      enemyData = (int[]) enemies.get(i);
      tileX = enemyData[0];
      tileY = enemyData[1];
      enemyType = enemyData[2];

      // 0 = spriteX
      // 1 = spriteY
      // 2 = spriteWidth
      // 3 = spriteHeight
      spriteData = enemyLegend[enemyType];
      spriteWidth = spriteData[2];
      spriteHeight = spriteData[3];

      // align bottom middle
      enemyX = (tileX * blocksLayer.tileWidth) + (blocksLayer.tileWidth / 2) - (spriteWidth / 2);
      enemyY = (tileY * blocksLayer.tileHeight) + blocksLayer.tileHeight - spriteHeight;

      PImage spriteImage = getImageSlice(
        spriteLegend[enemyType],
        spriteData[0],
        spriteData[1],
        spriteWidth,
        spriteHeight
      );

      image(
        spriteImage,
        posX + enemyX,
        posY + enemyY,
        spriteWidth,
        spriteHeight
      );
    }
  }

  int onCoord (int x, int y) {
    int[] obj;

    for (int i = 0, ii = enemies.size(); i < ii; i++) {
      obj = (int[]) enemies.get(i);

      if (obj[0] == x && obj[1] == y) {
        return i;
      }
    }

    return -1;
  }

}
