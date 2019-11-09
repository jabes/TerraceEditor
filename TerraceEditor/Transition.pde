public class Transition {
  
  private final float minValue;
  private final float maxValue;
  private final String easingMethod;
  
  private final int frameMaxInterval;
  private int frameOffset;
  private int frameOffsetMultiplier;
  private int frameInterval; // frameInterval cannot exceed frameMaxInterval.. duh!
  private int frameDifference;
  
  public float value;
  
  // note: set d + e to both equal 0 if no offset is desired
  public Transition (int a, float b, float c, int d, int e, String f) {
    frameMaxInterval = a;
    minValue = b;
    maxValue = c;
    frameOffset = d * e;
    frameOffsetMultiplier = e;
    easingMethod = f;
    // make sure frameOffset does not exceed frameMaxInterval
    while (frameOffset > frameMaxInterval) frameOffset -= frameMaxInterval + frameOffsetMultiplier;
  }
  
  void init () {
    frameInterval = frameMaxInterval - frameOffset;
    frameDifference = frameMaxInterval - frameInterval;
    value = easeInOutQuad(frameDifference, minValue, maxValue, frameMaxInterval);
  }
  
  void reset () {
    frameInterval = frameMaxInterval;
    frameDifference = 0;
    value = minValue;
  }
  
  // credit ~ http://gizma.com/easing/
  float easeInOutQuad (float t, float b, float c, float d) {
    t /= d / 2;
    if (t < 1) return c / 2 * t * t + b;
    t--;
    return -c / 2 * (t * (t - 2) - 1) + b;
  }  
  
  void step () { // this should be the last called method during redraw
    frameInterval--;
    frameDifference = frameMaxInterval - frameInterval;
    if (easingMethod == "easeInOutQuad") {
      if (frameInterval >= 0) value = easeInOutQuad(frameDifference, minValue, maxValue, frameMaxInterval);    
      else reset();
    }
  }
  
  
}
