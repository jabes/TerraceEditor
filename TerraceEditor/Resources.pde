public class Resources {

  final PImage tileSheetBlockLayer;
  final PImage tileSheetObjectLayer;
  final PImage tileSheetGilliamKnight;
  final PImage tileSheetKintot;
  final PImage playerHeadSprite;
  final PImage eraserSprite;
  final PImage globeIcon;
  final PImage homeIcon;
  final PImage birdIcon;
  final PImage alignmentSprite;
  final PImage srubberSprite;
  final PImage viewportBackground;
  
  Resources () {
    tileSheetBlockLayer      = loadImage("TerraceEditor/resources/graphics/world-tileset.png");
    tileSheetObjectLayer     = loadImage("TerraceEditor/resources/graphics/objects-tileset.gif");
    tileSheetGilliamKnight   = loadImage("TerraceEditor/resources/graphics/enemy-sprite-gilliam-knight.gif");
    tileSheetKintot          = loadImage("TerraceEditor/resources/graphics/enemy-sprite-kintot.gif");
    playerHeadSprite         = loadImage("TerraceEditor/resources/graphics/player-head.gif");
    eraserSprite             = loadImage("TerraceEditor/resources/graphics/eraser.png");
    globeIcon                = loadImage("TerraceEditor/resources/graphics/globe.png");
    homeIcon                 = loadImage("TerraceEditor/resources/graphics/home.png");
    birdIcon                 = loadImage("TerraceEditor/resources/graphics/bird.png");
    alignmentSprite          = loadImage("TerraceEditor/resources/graphics/alignment.gif");
    srubberSprite            = loadImage("TerraceEditor/resources/graphics/srubber.gif");
    viewportBackground       = loadImage("TerraceEditor/resources/graphics/viewport-background-tile.gif");
  }
  
  PImage tile (int sizeWidth, int sizeHeight, int tileWidth, int tileHeight, PImage imageSrc) {
    PImage tileImage = createImage(sizeWidth, sizeHeight, RGB);
    int totalX = ceil(sizeWidth / (float) tileWidth);
    int totalY = ceil(sizeHeight / (float) tileHeight);
    for (int y = 0; y < totalY; y++) {
      for (int x = 0; x < totalX; x++) {
        tileImage.copy(imageSrc, 0, 0, tileWidth, tileHeight, x * tileWidth, y * tileHeight, tileWidth, tileHeight);
      }
    }
    return tileImage;
  }
  
  /*
  PImage get (PImage img, int x, int y, int w, int h) {
    return img.get(x, y, w, h);
  }
  */

}
