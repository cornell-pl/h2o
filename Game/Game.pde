Watershed WS;
  
void setup() {
  size(700, 700);
  trialRun1();
  commandBox();
}

void draw() {
  if (key == CODED && keyCode == ENTER) {
    command = cp5.get(Textfield.class,"input command").getText();
    locX = Integer.parseInt(cp5.get(Textfield.class,"Location X").getText());
    locY = Integer.parseInt(cp5.get(Textfield.class,"LocationY").getText());
    println(command, locX, locY);
    
    if (command == "FC") {
      WS.addFactory(locX, locY);
      println("added Factory");
    }
  }
}

class Watershed {
  Location[][] gameMap; //2D Matrix of all grid Locations on game map
  ArrayList<Location> luLocs = new ArrayList<Location>(); //List of all LandUse (excluding GreenFields) Locations on game map
  ArrayList<Location> riverLocs = new ArrayList<Location>(); //List of all River Locations on game map
  boolean isSquare;
  int size;
  int[] sizeXY = new int[2];
  
  Watershed(int s) {
    /* Constructor 1: Initializes a square watershed of linear dimension s units */
    isSquare = true;
    size = s;
    drawGrid(s);      //Draws the grid
    initialize(s);    //Creates the Location array for the watershed
    initializeRiver1();    //Creates the river
  }
  
  Watershed(int x, int y) {
    /* Constructor 2: Initializes a watershed of dimension x*y units */
    isSquare = false;
    sizeXY[0] = x; sizeXY[1] = y;
    initialize(x, y);
    drawGrid(x,y);
  }

  void initialize(int s) { //<>//
    /*Initializes a game with square game map of linear dimension s units 
    All locations are initialized with GreenFields*/
    gameMap = new Location[s][s];
     for (int y=0; y<s; y++) {
       for (int x=0; x<s; x++) {
         GreenField gf = new GreenField();
         Tile t = new Tile(gf, 0, 0); //Default zero values for slope and soil
         Location l = new Location(x, y, t);
         gameMap[y][x] = l;
         drawTile(x, y, gf.getIcon());
       }
     }
  }

  void initialize(int w, int h) {
    /*Initializes a game with game map of dimension w*h units
    All locations are initialized with GreenFields*/
    gameMap = new Location[h][w];
       for (int y=0; y<h; y++) {
         for (int x=0; x<w; x++) {
           GreenField gf = new GreenField();
           Tile t = new Tile(gf, 0, 0); //Default zero values for slope and soil
           Location l = new Location(x, y, t);
           gameMap[y][x] = l;
           drawTile(x, y, gf.getIcon());
         }
       }
   }

  void initializeRiver1() {
    /* Adds River Tiles at designated Locations
    River design 1 used. (See Excel sheet)*/
    for (int x=1; x<=17; x++) { 
      River r = new River();
      Tile t = new Tile(r);    //River Tiles have no (zero) slope and soil values.
      Location loc = gameMap[7][x];
      loc.changeTile(t);
      riverLocs.add(loc);
      drawTile(x, 7, r.getIcon());
    }
    for (int y=7; y<=19; y++) { 
      River r = new River();
      Tile t = new Tile(r);
      Location loc = gameMap[y][9];
      loc.changeTile(t);
      riverLocs.add(loc);
      drawTile(9, y, r.getIcon());
    }
  }
  
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
  
  void addFactory(int x, int y) {
    /* Places a new Factory at Location <x, y> on the map. */
    Factory fc = new Factory();
    Location loc = gameMap[y][x];
    loc.changeLandUse(fc);
    if (!luLocs.contains(loc)) luLocs.add(loc);
    drawTile(x, y, fc.getIcon());
  }
  
  void addFarm(int x, int y) {
    /* Places a new Farm at Location <x, y> on the map. */
    Farm fm = new Farm();
    Location loc = gameMap[y][x];
    loc.changeLandUse(fm);
    if (!luLocs.contains(loc)) luLocs.add(loc);
    drawTile(x, y, fm.getIcon());    //!!!! x*20, y*20 is bad implementation. TO BE FIXED
  }
  
  void removeLandUse(int x, int y) {
    /* Removes LandUse at Location <x, y> on the map. (changes them to GreenFields) */
    GreenField gf= new GreenField();
    Location loc = gameMap[y][x];
    loc.changeLandUse(gf);
    if (luLocs.contains(loc)) luLocs.remove(loc);  //Conditional allows this method to be used on GreenField Tile
    drawTile(x, y, gf.getIcon());
  }
}
  

void trialRun1() {
  /* Trial run of game for testing. Factory added at <14, 2> and <0, 7>, 
  Farm added at <11, 5>; includes test of removeLandUse() */
  WS = new Watershed(20);
  WS.addFactory(14, 2);
  WS.addFactory(0, 7);
  WS.addFarm(11, 5);
  WS.addFactory(5, 2);
  WS.removeLandUse(5, 2);
  
  println("Simple sum of all pollution: ", WS.sumPollution());
  println("Total pollution entering river after linear decay: ", WS.linearDecayPollution());
}