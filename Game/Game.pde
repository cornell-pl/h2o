Watershed WS;
GUI graphics;
ControlP5 cp5;
  
/* ###  PROBLEMS  ###: 
*  
* ###  TODO  ###:
*  Add a bang button to activate methods.
*  Fonts look kinda shitty
*/

void setup() {
  frameRate(15);
  size(1050, 800);
  cp5 = new ControlP5(this);
  WS = new Watershed(20, 20);   //Creates watershed of size 20*20
}

void draw() {  
  if (keyPressed && key == '\n'){ 
    graphics.grabCommands();
    String command = graphics.getCommand();
    int locX =graphics.getLocX();
    int locY = graphics.getLocY();
    if (locX >= 0 && locY >= 0 && locX < WS.sizeX && locY < WS.sizeY) {
      if (command.equals("FC")){    //Factory command
        WS.addFactory(locX, locY);
      }else if (command.equals("FM")){    //Farm command
        WS.addFarm(locX, locY);
      }else if (command.equals("RM")){    //Remove command
        WS.removeLandUse(locX, locY);
      } else println("Bad command. Nothing happened.");
    }
     println("Simple sum of all pollution: ", WS.sumPollution());
     println("Total pollution entering river after linear decay: ", WS.linearDecayPollution()); println("");
  }
}

class Watershed {
  /* Contains all elements of the Game and implements the GUI. All user functions can be accessed from this class */
  Location[][] gameMap; //2D Matrix of all grid Locations on game map
  ArrayList<Location> luLocs = new ArrayList<Location>(); //List of all LandUse (excluding GreenFields) Locations on game map
  ArrayList<Location> riverLocs = new ArrayList<Location>(); //List of all River Locations on game map
  boolean isSquare;
  int sizeX;
  int sizeY;
  
  Watershed(int x, int y) {
    /* Constructor: Initializes a watershed of dimension x*y units */
    isSquare = true;
    sizeX = x; sizeY = y;
    graphics = new GUI(x, y);
    graphics.drawGrid();      //Draws the grid
    initialize();    //Creates the Location array for the watershed
    initializeRiver1();    //Creates the river
  }

  void initialize() { //<>//
    /*Initializes a game with square game map of dimension sizeX*sizeY units 
    All locations are initialized with GreenFields*/
    gameMap = new Location[sizeY][sizeX];
    for (int y=0; y<sizeY; y++) {
      for (int x=0; x<sizeX; x++) {
       GreenField gf = new GreenField();
       Tile t = new Tile(gf, 0, 0); //Default zero values for slope and soil
       Location l = new Location(x, y, t);
       gameMap[y][x] = l;
       graphics.drawTile(x, y, gf.getIcon());
       }
    }
  }

  //**** Methods to place rivers of various designs in map  ****//  -----------------------------------------------
  void initializeRiver1() {
    /* Simple river for a 20*20 board.
    *Adds River Tiles at designated Locations
    *River design 1 used. (See Excel sheet)*/
    for (int x=1; x<=17; x++) { 
      River r = new River();
      Tile t = new Tile(r);    //River Tiles have no (zero) slope and soil values.
      Location loc = gameMap[7][x];
      loc.changeTile(t);
      riverLocs.add(loc);
      graphics.drawTile(x, 7, r.getIcon());
    }
    for (int y=7; y<sizeY; y++) {    //River auto-scales to reach bottom
      River r = new River();
      Tile t = new Tile(r);
      Location loc = gameMap[y][9];
      loc.changeTile(t);
      riverLocs.add(loc);
      graphics.drawTile(9, y, r.getIcon());
    }
  }
  
  //**** Methods to calculate pollution according various models  ****//  -----------------------------------------------
  int sumPollution() {
    /* Returns simple sum of pollution generated for all locations */
    int totalPollution = 0;
    for (Location l : luLocs) {
      totalPollution += l.getPollution();
    }
    return totalPollution;
  }

  float linearDecayPollution() {
    /* Linear decay model of pollution that enters the river.
    Pollution decreases from source value by 0.1 units per unit distance of source
    to its nearest river tile. Pollution after decay is at least 0.
    Returns total pollution entering river from all sources according this model*/
    float ldPollutionTotal = 0.;
    for (Location l : luLocs) {
      //get distance of l to nearest River Location
      float minDist = Integer.MAX_VALUE;
      for (Location rl: riverLocs) {
        float d = l.distFrom(rl);
        if (d < minDist) minDist = d;
      }
      //Calculate pollution contribution from l after linear decay
      float ldPollution = l.getPollution() - 0.1 * minDist;
      if (ldPollution < 0) ldPollution = 0;
      ldPollutionTotal += ldPollution;
    }
    return ldPollutionTotal;
  }
  
  //**** Methods to add, change and remove land uses  ****//  -----------------------------------------------
  void addFactory(int x, int y) {
    /* Places a new Factory at Location <x, y> on the map. */
    Location loc = gameMap[y][x];
    if (!riverLocs.contains(loc)) {
      Factory fc = new Factory();
      loc.changeLandUse(fc);
      if (!luLocs.contains(loc)) luLocs.add(loc);
      graphics.drawTile(x, y, fc.getIcon());
      println("Added Factory at", loc);
    }else {
      println("Cannot built factory in river. Nothing is added");
    }
  }
  
  void addFarm(int x, int y) {
    /* Places a new Farm at Location <x, y> on the map. */
    Location loc = gameMap[y][x];
    if (!riverLocs.contains(loc)) {
      Farm fm = new Farm();
      loc.changeLandUse(fm);
      if (!luLocs.contains(loc)) luLocs.add(loc);  
      graphics.drawTile(x, y, fm.getIcon());  
      println("Added Farm at", loc);
    }else {
      println("Cannot built farm in river. Nothing is added.");
    }
  }
  
  void removeLandUse(int x, int y) {
    /* Removes LandUse at Location <x, y> on the map. (changes them to GreenFields) */
    
    Location loc = gameMap[y][x];
    if (!riverLocs.contains(loc)) {
      GreenField gf= new GreenField();
      loc.changeLandUse(gf);
      if (luLocs.contains(loc)) luLocs.remove(loc);  //Conditional allows this method to be used on GreenField Tile
      graphics.drawTile(x, y, gf.getIcon());
      println("Removed land use at", loc);
    }else {
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