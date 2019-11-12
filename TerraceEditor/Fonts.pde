public class Fonts {

  public PFont VcrOsdMono;

  private String fontsPath;

  public Fonts () {
    try {
      fontsPath = sketchPath("resources/fonts");
    } catch (NoSuchMethodError e) {
      fontsPath = "TerraceEditor/resources/fonts";
    }

    VcrOsdMono = createFont(fontsPath + "/VCR-OSD-Mono.ttf", 13);
  }
}
