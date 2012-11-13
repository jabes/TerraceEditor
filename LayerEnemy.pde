private class LayerEnemy {
  
  final int posX;
  final int posY;
  
  final int[][] enemyLegend = {
    {0, 30, 32, 30}, // strong spring
    {32, 30, 32, 30}, // weak spring
    {64, 12, 32, 48}, // sign
    {96, 28, 16, 16}, // coin
    {0, 60, 128, 121}, // tree
  };
  
  LayerEnemy (int x, int y, int w, int h) {
    posX = x;
    posY = y;
  }
  
  void init () {}
  void reset () { init(); }
  void redraw () {}
  
}
