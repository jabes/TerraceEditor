public class Fonts {

  public PFont OpenSansRegular;
  private String fontsPath;

  public Fonts () {
    try {
      fontsPath = sketchPath("resources/fonts");
    } catch (NoSuchMethodError e) {
      fontsPath = "TerraceEditor/resources/fonts";
    }

    OpenSansRegular = createFont(fontsPath + "/OpenSans-Regular.ttf", 12);
  }
}
