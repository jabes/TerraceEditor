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
  final PImage srubberHorizontal;
  final PImage srubberVertical;
  final PImage viewportBackground;

  private String graphicsPath;

  Resources () {
    try {
      graphicsPath = sketchPath("resources/graphics");
    } catch (NoSuchMethodError e) {
      graphicsPath = "TerraceEditor/resources/graphics";
    }

    tileSheetBlockLayer    = loadImage(graphicsPath + "/world-tileset.png");
    tileSheetObjectLayer   = loadImage(graphicsPath + "/objects-tileset.gif");
    tileSheetGilliamKnight = loadImage(graphicsPath + "/enemy-sprite-gilliam-knight.gif");
    tileSheetKintot        = loadImage(graphicsPath + "/enemy-sprite-kintot.gif");
    playerHeadSprite       = loadImage(graphicsPath + "/player-head.gif");
    eraserSprite           = loadImage(graphicsPath + "/eraser.png");
    globeIcon              = loadImage(graphicsPath + "/globe.png");
    homeIcon               = loadImage(graphicsPath + "/home.png");
    birdIcon               = loadImage(graphicsPath + "/bird.png");
    alignmentSprite        = loadImage(graphicsPath + "/alignment.gif");
    srubberHorizontal      = loadImage(graphicsPath + "/srubber-horizontal.gif");
    srubberVertical        = loadImage(graphicsPath + "/srubber-vertical.gif");
    viewportBackground     = loadImage(graphicsPath + "/viewport-background.gif");
  }

}
