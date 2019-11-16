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

float viewportScrubOffsetX;
float viewportScrubOffsetY;

PImage backgroundImage;

// 0 = blocks layer
// 1 = interactive objects layer
// 2 = enemies layer
int activeMapLayer;

void setup () {
  applet = this;

  frameRate(15);
  size(755, 650);
  noSmooth();
  noStroke();

  enemies = new ArrayList();
  objects = new ArrayList();

  activeMapLayer = 0;
  viewportScrubOffsetX = 0;
  viewportScrubOffsetY = 0;

  globals = new Globals();
  resources = new Resources();
  fonts = new Fonts();
  mouse = new Mouse();
  keyboard = new Keyboard();
  dialog = new Dialog();
  changeMapSizeWindow = new MapSizeWindow(320, 170);
  fileMenu = new FileMenu(0, 0, globals.fileMenuWidth + globals.viewportScrollbarThickness, globals.fileMenuHeight);
  selectionPane = new SelectionPane(globals.viewportWidth + globals.viewportScrollbarThickness, 0, globals.menuPaneWidth, globals.menuPaneHeight);
  viewportScroller = new Scrollbar();
  blocksLayer = new LayerBlock(globals.viewportX, globals.viewportY, globals.viewportWidth, globals.viewportHeight);
  objectsLayer = new LayerObject(globals.viewportX, globals.viewportY, globals.viewportWidth, globals.viewportHeight);
  enemyLayer = new LayerEnemy(globals.viewportX, globals.viewportY, globals.viewportWidth, globals.viewportHeight);
  
  fileMenu.init();
  viewportScroller.init();
  blocksLayer.init(blocksLayer.mapDataDefault);
  objectsLayer.init();
  enemyLayer.init();
  changeMapSizeWindow.init();
  viewportScroller.checkHorizontal(blocksLayer.mapWidth, globals.viewportWidth);
  viewportScroller.checkVertical(blocksLayer.mapHeight, globals.viewportHeight);
  fileMenu.activate();
}

void draw () {
  applet.background(200);
  image(resources.viewportBackground, globals.viewportX, globals.viewportY, globals.viewportWidth, globals.viewportHeight);
  mouse.cursor = ARROW; // reset every draw (evaluated in code below)

  viewportScrubOffsetX = -(viewportScroller.scrubValueX * (blocksLayer.mapWidth - globals.viewportWidth));
  viewportScrubOffsetY = -(viewportScroller.scrubValueY * (blocksLayer.mapHeight - globals.viewportHeight));
  applet.translate(viewportScrubOffsetX, viewportScrubOffsetY);

  if (activeMapLayer != 0) {
    applet.tint(255, 100);
  }

  blocksLayer.iterate();
  applet.noTint();

  if (activeMapLayer != 1) {
    applet.tint(255, 100);
  }

  objectsLayer.iterate();
  applet.noTint();

  if (activeMapLayer != 2) {
    applet.tint(255, 100);
  }

  enemyLayer.iterate();
  applet.noTint();

  applet.translate(-viewportScrubOffsetX, -viewportScrubOffsetY);
  selectionPane.iterate();
  viewportScroller.iterate();
  fileMenu.iterate();
  dialog.iterate();
  changeMapSizeWindow.iterate();

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

  for (int y = 0; y < blocksLayer.mapData.length; y++) {
    data = append(data, join(nf(blocksLayer.mapData[y], 0), globals.inlineDelimiter));
  }

  int[] objectData;
  data = append(data, globals.groupDelimiter + "OBJECTS");

  for (int i = 0, ii = objects.size(); i < ii; i++) {
    objectData = new int[4];
    arrayCopy((int[])objects.get(i), objectData);
    objectData[3] += 1; // the game engine indexes at 1 not 0
    data = append(data, join(nf(objectData, 0), globals.inlineDelimiter));
  }

  int[] enemyData;
  data = append(data, globals.groupDelimiter + "ENEMIES");

  for (int i = 0, ii = enemies.size(); i < ii; i++) {
    enemyData = new int[3];
    arrayCopy((int[])enemies.get(i), enemyData);
    enemyData[2] += 1; // the game engine indexes at 1 not 0
    data = append(data, join(nf(enemyData, 0), globals.inlineDelimiter));
  }

  saveStrings(fileName, data);
  dialog.showMessage("Map was saved as: " + fileName);
}

void requestMapImport () {
  selectInput("Load Map File...", "mapFileSelected");
}

void mapFileSelected (File selection) {
  if (selection == null) {
    // Window was closed or the user hit cancel
  } else {
    String[] data = loadStrings(selection);
    if (data != null) {
      HashMap args = new HashMap();
      args.put("mapdata", data);
      dialog.askQuestion(applet, "Are you sure you want to load a new map? All un-saved progress will be lost.", "importMap", args);
    }
  }
}

void importMap (HashMap params) {
  String[] data = (String[]) params.get("mapdata");
  String dataType = "";
  int lineCount = 0;
  int[][] newMapData = new int[10][1];

  if (data == null) {
    fileMenu.reset();
  } else {
    objects.clear();
    enemies.clear();

    for (int i = 0; i < data.length; i++) {
      if (data[i].substring(0, 1).equals(globals.groupDelimiter)) {
        // determine if delimiter is succeeded by characters
        if (!data[i].substring(1).equals("")) {
          dataType = data[i].substring(1);
        }

        lineCount = 0;
      } else {
        int[] rowData = int(split(data[i], globals.inlineDelimiter));

        if (dataType.equals("PLAYER")) {
          objectsLayer.playerTileX = rowData[0];
          objectsLayer.playerTileY = rowData[1];
        } else if (dataType.equals("BLOCKS")) {
          newMapData[lineCount] = expand(newMapData[lineCount], rowData.length);
          arrayCopy(rowData, newMapData[lineCount]);
        } else if (dataType.equals("OBJECTS")) {
          rowData[3] -= 1; // the game engine indexes at 1 not 0
          objects.add(rowData);
        } else if (dataType.equals("ENEMIES")) {
          rowData[2] -= 1; // the game engine indexes at 1 not 0
          enemies.add(rowData);
        }

        lineCount++;
      }
    }

    blocksLayer.reset(newMapData);
    viewportScroller.checkHorizontal(blocksLayer.mapWidth, globals.viewportWidth);
    viewportScroller.checkVertical(blocksLayer.mapHeight, globals.viewportHeight);
    dialog.showMessage("Map was successfully loaded.");
  }
}

String getTimestamp () {
  return year() + "." + nf(month(), 2) + "." + nf(day(), 2) + "." + nf(hour(), 2) + "." + nf(minute(), 2) + "." + millis();
}

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

PImage getImageSlice (PImage srcImage, int spriteX, int spriteY, int spriteW, int spriteH) {
  int p1 = 0;
  int p2 = 0;
  boolean grabX = false;
  boolean grabY = false;

  if (spriteW == srcImage.width && spriteH == srcImage.height) {
    return srcImage;
  }

  PImage img = createImage(spriteW, spriteH, ARGB);
  img.loadPixels();

  for (int h = 0; h < srcImage.height; h++) {
    if (h >= spriteY && h < spriteY + spriteH) grabY = true;
    for (int w = 0; w < srcImage.width; w++) {
      if (w >= spriteX && w < spriteX + spriteW) grabX = true;
      if (grabX && grabY) {
        img.pixels[p1] = srcImage.pixels[p2];
        p1++;
      }
      p2++;
      grabX = false;
    }
    grabY = false;
  }

  img.updatePixels();
  return img;
}
