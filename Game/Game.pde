Watershed WS;
GUI graphics;
final int sizeX = 30;    //Dimensions of the watershed in tiles
final int sizeY = 30;
  
/* ###  PROBLEMS  ###: 
*  
* ###  TODO  ###:
*  Add a bang button to activate methods.
*  Fonts look kinda shitty
*/

void setup() {
  frameRate(30);
  size(1050, 800);
  WS = new Watershed(sizeX, sizeY);   //Creates watershed of size 20*20
}

void draw() {  
  background(204);
  graphics.render();
  //println("Simple sum of all pollution: ", WS.sumPollution());
  //println("Total pollution entering river after linear decay: ", WS.linearDecayPollution()); println("");
}


class Watershed {
  /* Contains all elements of the Game and implements the GUI. All user functions can be accessed from this class */
  Tile[][] gameMap; //2D Matrix of all grid Tiles on game map
  ArrayList<int[]> riverTiles = new ArrayList<int[]>(); //Records the coordinates of all river tiles on map;
  
  Watershed(int x, int y) {
    /* Constructor: Initializes a watershed of dimension x*y units */
    graphics = new GUI(x, y);
    initialize();    //Creates the Tile array for the watershed
    initializeRiver1();    //Creates the river
  }

  void initialize() { //<>//
    /*Initializes a game with square game map of dimension sizeX*sizeY units 
    All Tiles are initialized with GreenFields*/
    gameMap = new Tile[sizeX][sizeY];
    for (int y=0; y<sizeY; y++) {
      for (int x=0; x<sizeX; x++) {
       GreenField gf = new GreenField();
       Tile t = new Tile(gf, x, y, 0, 0); //Default zero values for slope and soil
       gameMap[x][y] = t;
       }
    }
  }

  //**** Methods to place rivers of various designs in map  ****//  -----------------------------------------------
  void initializeRiver1() {
    /* Simple river for a 20*20 board.
    *Adds River Tiles at designated locations
    *River design 1 used. (See Excel sheet)*/
    int yp = 7;
    for (int x=1; x<=17; x++) { 
      River r = new River();
      Tile rTile = new Tile(r, x, yp, 0, 0);    //River Tiles have no (zero) slope and soil values.
      gameMap[x][yp] = rTile;
      riverTiles.add(new int[] {x, yp});
    }
    int xp = 9;
    for (int y=7; y<sizeY; y++) {    //River auto-scales to reach bottom
      River r = new River();
      Tile rTile = new Tile(r, xp, y, 0, 0);
      gameMap[xp][y] = rTile;
      riverTiles.add(new int[] {xp, y});
    }
  }
  
  //**** Methods to calculate pollution according various models  ****//  -----------------------------------------------
  int sumPollution() {
    /* Returns simple sum of pollution generated for all Tiles */
    int totalPollution = 0;
    for (Tile[] tileRow : gameMap) {
      for (Tile t: tileRow) {
        totalPollution += t.getPollution();
      }
    }
    return totalPollution;
  }

  float linearDecayPollution() {
    /* Linear decay model of pollution that enters the river.
    Pollution entering river = source pollution / dist to river
    Returns total pollution entering river from all sources according this model*/
    float ldPollutionTotal = 0.;
    for (Tile[] tileRow : gameMap) {
      for (Tile t: tileRow) {   //Calculate pollution contribution from t after linear decay
        if (t.getPollution() != 0) {
          float ldPollution = t.getPollution()/t.distToRiver;
          ldPollutionTotal += ldPollution;
        }
     }
   }
    return ldPollutionTotal;
  }
  
  
  
  //**** Methods to add, change and remove land uses  ****//  -----------------------------------------------
  float distToRiver(int x, int y) {
    /* Helper: Returns the distance for <x, y> to closest River Tile. */
    float minDist = (float) Integer.MAX_VALUE;
    for (int[] rCoords: riverTiles) {
      float d = dist(x, y, rCoords[0], rCoords[1]);
      if (d < minDist) minDist = d;
    }
    return minDist;
  }
    
  void addFactory(int x, int y) {
    /* Places a new Factory at Location <x, y> on the map. */
    Tile t = gameMap[x][y];
    if (! (t.getLandT() instanceof River)) {
      Factory fc = new Factory();
      t.changeLandUse(fc);
      t.distToRiver = distToRiver(x, y);
      message2 = "Added Factory at " + t;
      println("Added Factory at", t);
      
    }else {
      message2 = "Cannot built factory in river. Nothing is added.";
      println("Cannot built factory in river. Nothing is added");
    }
  }
  
  void addFarm(int x, int y) {
    /* Places a new Farm at Location <x, y> on the map. */
    Tile t = gameMap[x][y];
    if (! (t.getLandT() instanceof River)) {
      Farm fm = new Farm();
      t.changeLandUse(fm); 
      t.distToRiver = distToRiver(x, y);
      message2 = "Added Farm at " + t;
      println("Added Farm at", t);
    }else {
      message2 = "Cannot built farm in river. Nothing is added.";
      println("Cannot built farm in river. Nothing is added.");
    }
  }
  
  void removeLandUse(int x, int y) {
    /* Removes LandUse at Location <x, y> on the map. (changes them to GreenFields) */
    Tile t = gameMap[x][y];
    if (! (t.getLandT() instanceof River)) {
      GreenField gf= new GreenField();
      t.changeLandUse(gf);
      graphics.drawTile(x, y, gf.getIcon());
      message2 = "Removed land use at " + t;
      println("Removed land use at", t);
    }else {
      message2 = "River cannot be removed.";
      println("River cannot be removed.");
    }
  }
}
  
void trialRun1() {
  /* Trial run of game for testing. Factory added at <14, 2> and <0, 7>, 
  Farm added at <11, 5>; includes test of removeLandUse() */
  WS = new Watershed(20, 20);
  WS.addFactory(14, 2);
  WS.addFactory(0, 7);
  WS.addFarm(11, 5);
  WS.addFactory(5, 2);
  WS.removeLandUse(5, 2);
  
  println("Simple sum of all pollution: ", WS.sumPollution());
  println("Total pollution entering river after linear decay: ", WS.linearDecayPollution());
}