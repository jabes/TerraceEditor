PApplet applet;
Globals globals;
Resources resources;
Fonts fonts;
Mouse mouse;
Keyboard keyboard;
Dialog dialog;
Scrollbar viewportScroller;
SelectionPane selectionPane;
FileMenu fileMenu;
LayerBlock blocksLayer;
LayerObject objectsLayer;
LayerEnemy enemyLayer;
MapSizeWindow changeMapSizeWindow;

ArrayList enemies;
ArrayList objects;

float viewportScrubOffsetLeft;

PImage backgroundImage;

// 0 = blocks layer
// 1 = interactive objects layer
// 2 = enemies layer
int activeMapLayer;

void setup () {

  globals = new Globals();
  
  applet = this;
  applet.size(globals.viewportWidth + globals.menuPaneWidth, globals.viewportHeight + globals.viewportScrollbarHeight + globals.fileMenuHeight);
  applet.noSmooth();
  applet.noStroke();
  applet.frame.setTitle("MapEditor v" + globals.version + "+build." + getBuild());

  enemies = new ArrayList();
  objects = new ArrayList();

  activeMapLayer = 0;
  viewportScrubOffsetLeft = 0;
  
  resources = new Resources();
  fonts = new Fonts();
  mouse = new Mouse();
  keyboard = new Keyboard();
  dialog = new Dialog();
  changeMapSizeWindow = new MapSizeWindow(320, 170);
  fileMenu = new FileMenu(0, 0, globals.fileMenuWidth, globals.fileMenuHeight);
  selectionPane = new SelectionPane(globals.viewportWidth, 0, globals.menuPaneWidth, globals.menuPaneHeight);
  viewportScroller = new Scrollbar(0, globals.viewportHeight + globals.fileMenuHeight, globals.viewportScrollbarWidth, globals.viewportScrollbarHeight);
  blocksLayer = new LayerBlock(0, globals.fileMenuHeight, globals.viewportWidth, globals.viewportHeight);
  objectsLayer = new LayerObject(0, globals.fileMenuHeight, globals.viewportWidth, globals.viewportHeight);
  enemyLayer = new LayerEnemy(0, globals.fileMenuHeight, globals.viewportWidth, globals.viewportHeight);
  
  fileMenu.init();
  viewportScroller.init();
  blocksLayer.init(blocksLayer.mapDataDefault);
  objectsLayer.init();
  enemyLayer.init();
  changeMapSizeWindow.init();
  
  backgroundImage = resources.tile(applet.width, applet.height, 40, 40, resources.viewportBackground);
  
  viewportScroller.check(blocksLayer.mapWidth, globals.viewportWidth);  
  
}

void draw () {
  
  applet.background(backgroundImage);
  
  mouse.cursor = ARROW; // reset every draw (evaluated in code below)

  if (
    !viewportScroller.isDisabled
    && viewportScroller.isScrubbing
  ) viewportScrubOffsetLeft = -(viewportScroller.scrubValue * (blocksLayer.mapWidth - globals.viewportWidth));
  
  applet.translate(viewportScrubOffsetLeft, 0);

  if (activeMapLayer != 0) applet.tint(255, getAlpha(0.35));
  blocksLayer.redraw();
  applet.noTint();
  
  if (activeMapLayer != 1) applet.tint(255, getAlpha(0.35));
  objectsLayer.redraw();
  applet.noTint();
  
  if (activeMapLayer != 2) applet.tint(255, getAlpha(0.35));
  enemyLayer.redraw();
  applet.noTint();
  
  applet.translate(-viewportScrubOffsetLeft, 0);
  
  selectionPane.redraw();  
  viewportScroller.redraw();
  fileMenu.redraw();
  dialog.redraw();
  changeMapSizeWindow.redraw();
  
  cursor(mouse.cursor);
    
  if (mouse.wasClicked) mouse.reset();
  if (keyboard.wasPressed) keyboard.reset();

}

void keyPressed () {
  keyboard.pressed(keyCode);
}

void keyReleased () {
  keyboard.released(keyCode);
}

void mousePressed () {
  mouse.pressed();
}

void mouseReleased () {
  mouse.released();
}

void exportMap () {
  String[] data = {};
  String fileName = "maps/mapdatafile-" + getTimestamp() + ".txt";
  data = append(data, globals.groupDelimiter + "PLAYER");
  data = append(data, str(objectsLayer.playerTileX) + globals.inlineDelimiter + str(objectsLayer.playerTileY));
  data = append(data, globals.groupDelimiter + "BLOCKS");
  //for (int i = 0; i < blocksLayer.mapData.length; i++) data = concat(i > 0 ? append(data, globals.groupDelimiter) : data, str(blocksLayer.mapData[i]));
  for (int y = 0; y < blocksLayer.mapData.length; y++) data = append(data, join(nf(blocksLayer.mapData[y], 0), globals.inlineDelimiter));
  data = append(data, globals.groupDelimiter + "OBJECTS");
  //for (int i = 0, ii = objects.size(); i < ii; i++) data = concat(i > 0 ? append(data, globals.groupDelimiter) : data, str((int[])objects.get(i)));
  for (int i = 0, ii = objects.size(); i < ii; i++) data = append(data, join(nf((int[])objects.get(i), 0), globals.inlineDelimiter));
  saveStrings(fileName, data);
  fileMenu.reset();
  dialog.showMessage("Map was saved as: " + fileName);
}

void requestMapImport () {
  String[] data = loadStrings(selectInput("Load Map File..."));
  HashMap args = new HashMap();
  args.put("mapdata", data);
  fileMenu.reset();
  if (data != null) dialog.askQuestion(applet, "Are you sure you want to load a new map?" + globals.EOL + "All un-saved progress will be lost.", "importMap", args);
}

void importMap (HashMap params) {
  String dataType = "";
  String[] data = (String[]) params.get("mapdata");
  int lineCount = 0;
  int delimitCount = 0;
  int[] interativeObject = new int[4];
  int[][] newMapData = new int[10][1];
  if (data == null) fileMenu.reset();
  else {
    objects.clear();
    for (int i = 0; i < data.length; i++) {
      if (data[i].substring(0, 1).equals(globals.groupDelimiter)) {
        String d = data[i].substring(1); // second char
        if (!d.equals("")) { // determine if delimiter is succeeded by characters
          dataType = d; // player, blocks, objects?
          delimitCount = 0;
        } else { // map data delimiters (have no succeeding chars)
          delimitCount++;
        }
        lineCount = 0;
      } else {
        int n = int(data[i]);
        if (dataType.equals("PLAYER")) {
          switch (lineCount) {
            case 0: objectsLayer.playerTileX = n; break;
            case 1: objectsLayer.playerTileY = n; break;
          }
        } else if (dataType.equals("BLOCKS")) {
          if (newMapData[0].length < lineCount + 1)
            for (int y = 0; y < newMapData.length; y++) 
              newMapData[y] = expand(newMapData[y], newMapData[y].length + 1); // expand each inner array by 1 slot
          newMapData[delimitCount][lineCount] = n;
        } else if (dataType.equals("OBJECTS")) {
          interativeObject[lineCount] = n;
          if (lineCount + 1 == interativeObject.length) 
            objects.add(subset(interativeObject, 0)); // subset = fast array copy?
        }
        lineCount++;
      }
      if (i == data.length - 1) {
        blocksLayer.reset(newMapData);
        viewportScroller.check(blocksLayer.mapWidth, globals.viewportWidth);  
        dialog.showMessage("Map was successfully loaded.");
      }
    }
  }
}
  
static float getAlpha (float i) { return i * 255; }
String getTimestamp () { return year() + "." + nf(month(), 2) + "." + nf(day(), 2) + "." + nf(hour(), 2) + "." + nf(minute(), 2) + "." + millis(); }
String getBuild () {
  int[] datePieces = int(split(globals.dateCreated, "/"));
  int totalMonths = month() - datePieces[1];
  int i = year();
  while (i > datePieces[0]) {
    totalMonths += 12;
    i--;
  }
  return nf(totalMonths, 2) + nf(day(), 2);
}

