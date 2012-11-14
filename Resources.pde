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
    tileSheetBlockLayer = loadImage("resources/world-tileset.png");
    tileSheetObjectLayer = loadImage("resources/objects-tileset.gif");
    tileSheetGilliamKnight = loadImage("resources/enemy-sprite-gilliam-knight.gif");
    tileSheetKintot = loadImage("resources/enemy-sprite-kintot.gif");
    playerHeadSprite = loadImage("resources/player-head.gif");
    eraserSprite = loadImage("resources/eraser.png");
    globeIcon = loadImage("resources/globe.png");
    homeIcon = loadImage("resources/home.png");
    birdIcon = loadImage("resources/bird.png");
    alignmentSprite = loadImage("resources/alignment.gif");
    srubberSprite = loadImage("resources/srubber.gif");
    viewportBackground = loadImage("resources/viewport-background-tile.gif");
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
