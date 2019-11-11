public class Fonts {

  public PFont AndaleMono;
  private String fontsPath;

  public Fonts () {
    try {
      fontsPath = sketchPath("resources/fonts");
    } catch (NoSuchMethodError e) {
      fontsPath = "TerraceEditor/resources/fonts";
    }

    AndaleMono      = createFont(fontsPath + "/Andale-Mono.ttf", 12);
  }
}
