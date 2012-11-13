public class Animation {
  
  private final int startFrame;
  private final int maxInterval;
  private final int[][] spriteTable;
  private final PImage spriteSheet;
  private final boolean allowLoop;
  
  public int frame;
  private int interval;
  
  public PImage spriteBlock;
  public int spriteX;
  public int spriteY;
  public int spriteWidth;
  public int spriteHeight;
  
  public Animation (int[][] a, PImage b, int c, int d, boolean e) {
    spriteTable = a;
    spriteSheet = b;
    startFrame = c;
    maxInterval = d;
    allowLoop = e;
    this.reset();
  }
  
  public void reset () {
    frame = startFrame;
    interval = 0;
  }
  
  public void run () {
    
    if (interval >= maxInterval) {
      frame++; // advance to next frame
      interval = 0; // reset interval
    } else interval++;
    
    if (frame >= spriteTable.length) frame = (allowLoop) ? startFrame : spriteTable.length - 1;
        
    spriteX = spriteTable[frame][0];
    spriteY = spriteTable[frame][1];
    spriteWidth = spriteTable[frame][2];
    spriteHeight = spriteTable[frame][3];

    spriteBlock = spriteSheet.get(spriteX, spriteY, spriteWidth, spriteHeight);
  
  }
  
  public void getFrame (int n) {
    spriteX = spriteTable[n][0];
    spriteY = spriteTable[n][1];
    spriteWidth = spriteTable[n][2];
    spriteHeight = spriteTable[n][3];
    spriteBlock = spriteSheet.get(spriteX, spriteY, spriteWidth, spriteHeight);
  }
  
  public void setFrame (int n) {
    frame = n;
  }

}
