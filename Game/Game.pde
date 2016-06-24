Watershed WS;
GUI graphics;
final int SIZE_X = 30;    //Dimensions of the watershed in tiles
final int SIZE_Y = 30;
final int[][] RIVER_TILES = { { 5 , 5 },  { 5 , 19 },  { 5 , 20 },  { 5 , 21 },  { 6 , 5 },  { 6 , 21 },  { 7 , 5 },  { 7 , 6 },  { 7 , 21 },  { 8 , 6 },  { 8 , 21 },  { 8 , 22 },  { 9 , 6 },  { 9 , 22 },  { 10 , 6 },  { 10 , 7 },  { 10 , 22 },  { 11 , 6 },  { 11 , 7 },  { 11 , 8 },  { 11 , 9 },  { 11 , 14 },  { 11 , 15 },  { 11 , 16 },  { 11 , 22 },  { 12 , 7 },  { 12 , 8 },  { 12 , 9 },  { 12 , 10 },  { 12 , 11 },  { 12 , 12 },  { 12 , 13 },  { 12 , 14 },  { 12 , 15 },  { 12 , 16 },  { 12 , 17 },  { 12 , 18 },  { 12 , 19 },  { 12 , 20 },  { 12 , 21 },  { 12 , 22 },  { 13 , 9 },  { 13 , 10 },  { 13 , 11 },  { 13 , 12 },  { 13 , 13 },  { 13 , 14 },  { 13 , 16 },  { 13 , 17 },  { 13 , 18 },  { 13 , 19 },  { 13 , 20 },  { 13 , 21 },  { 13 , 22 },  { 13 , 23 },  { 13 , 24 },  { 13 , 25 },  { 14 , 7 },  { 14 , 8 },  { 14 , 9 },  { 14 , 11 },  { 14 , 12 },  { 14 , 18 },  { 14 , 19 },  { 14 , 22 },  { 14 , 23 },  { 14 , 24 },  { 14 , 25 },  { 14 , 26 },  { 14 , 27 },  { 14 , 28 },  { 14 , 29 },  { 15 , 6 },  { 15 , 11 },  { 15 , 17 },  { 15 , 18 },  { 15 , 24 },  { 15 , 25 },  { 15 , 26 },  { 15 , 27 },  { 15 , 28 },  { 15 , 29 },  { 16 , 5 },  { 16 , 11 },  { 16 , 16 },  { 16 , 17 },  { 16 , 26 },  { 16 , 27 },  { 16 , 28 },  { 16 , 29 },  { 17 , 4 },  { 17 , 10 },  { 17 , 11 },  { 17 , 16 },  { 17 , 27 },  { 17 , 28 },  { 17 , 29 },  { 18 , 9 },  { 18 , 10 },  { 18 , 16 },  { 18 , 17 },  { 19 , 8 },  { 19 , 9 },  { 20 , 7 },  { 20 , 8 },  { 21 , 7 },  { 22 , 7 },  { 23 , 6 },  { 23 , 7 },  { 23 , 8 },  { 24 , 7 },  { 24 , 8 },  { 25 , 7 } };
ArrayList<Tile> riverTiles = new ArrayList<Tile>(200);

void setup() {
  frameRate(30);
  size(1600, 1080);
  WS = new Watershed(SIZE_X, SIZE_Y);   //Creates watershed of size 20*20
  graphics = new GUI(SIZE_X, SIZE_Y);
}

void draw() {  
  background(165);
  WS.update();
  graphics.render();
}


class Watershed {
  /* Contains all elements of the Game and implements the GUI. All user functions can be accessed from this class */
  final Tile[][] GAME_MAP = new Tile[SIZE_X][SIZE_Y]; //2D Matrix of all grid Tiles on game map
  int factories = 0;
  int farms = 0;
  int houses = 0;
  int totalPollution;
  float totalDecayPollution;
  float totalActualProfits;
  float score;
  Tile[] rTiles = new Tile[113];
  
  Watershed(int x, int y) {
    /* Constructor: Initializes a watershed of dimension x*y units */
    initializeWithForest();
    setTileVals();
  }     //<>//
  
  void initializeWithForest() {
    for (int j=0; j<SIZE_Y; j++) {
      for (int i=0; i<SIZE_X; i++) { 
         Dirt di = new Dirt();
         Tile t = new Tile(di, i, j);
         GAME_MAP[i][j] = t;
        }
      }
    int[][] fCoords = { { 1 , 1 },  { 1 , 2 },  { 1 , 5 },  { 1 , 18 },  { 1 , 19 },  { 2 , 2 },  { 2 , 3 },  { 2 , 4 },  { 2 , 17 },  { 2 , 18 },  { 2 , 19 },  { 2 , 20 },  { 3 , 2 },  { 3 , 3 },  { 3 , 4 },  { 3 , 5 },  { 3 , 16 },  { 3 , 17 },  { 3 , 18 },  { 3 , 19 },  { 4 , 2 },  { 4 , 3 },  { 4 , 4 },  { 4 , 15 },  { 4 , 16 },  { 4 , 17 },  { 4 , 18 },  { 5 , 4 },  { 5 , 17 },  { 5 , 25 },  { 6 , 16 },  { 6 , 17 },  { 6 , 18 },  { 7 , 2 },  { 7 , 17 },  { 7 , 18 },  { 7 , 19 },  { 8 , 17 },  { 8 , 18 },  { 10 , 24 },  { 11 , 23 },  { 11 , 24 },  { 11 , 25 },  { 12 , 23 },  { 12 , 24 },  { 12 , 25 },  { 14 , 20 },  { 14 , 21 },  { 15 , 19 },  { 15 , 20 },  { 15 , 21 },  { 15 , 22 },  { 15 , 23 },  { 16 , 2 },  { 16 , 18 },  { 16 , 19 },  { 16 , 20 },  { 16 , 21 },  { 17 , 18 },  { 17 , 19 },  { 17 , 20 },  { 18 , 4 },  { 21 , 20 },  { 21 , 22 },  { 21 , 23 },  { 22 , 3 },  { 22 , 4 },  { 22 , 9 },  { 22 , 19 },  { 22 , 20 },  { 22 , 21 },  { 22 , 22 },  { 22 , 23 },  { 23 , 2 },  { 23 , 3 },  { 23 , 4 },  { 23 , 18 },  { 23 , 19 },  { 23 , 20 },  { 23 , 21 },  { 23 , 22 },  { 23 , 23 },  { 24 , 1 },  { 24 , 2 },  { 24 , 3 },  { 24 , 4 },  { 24 , 5 },  { 24 , 19 },  { 24 , 20 },  { 24 , 21 },  { 24 , 22 },  { 24 , 23 },  { 25 , 2 },  { 25 , 3 },  { 25 , 4 },  { 25 , 5 },  { 25 , 12 },  { 25 , 13 },  { 25 , 20 },  { 25 , 21 },  { 25 , 22 },  { 26 , 3 },  { 26 , 4 },  { 26 , 5 },  { 26 , 6 },  { 26 , 12 },  { 26 , 13 },  { 26 , 23 },  { 26 , 24 },  { 26 , 25 },  { 27 , 4 },  { 27 , 12 },  { 27 , 24 },  { 27 , 25 },  { 27 , 26 },  { 28 , 25 },  { 28 , 26 } };
    for (int[] c: fCoords) { 
      Forest fo = new Forest();
      GAME_MAP[c[0]][c[1]].landU = fo;
    }
    initializeRiver2();    //Creates the river
  }
  
  void setTileVals() {
    /* Sets the pollution, ld pollution and distToRiver for each tile.
    * Called once after map is initialized */
    for (Tile[] tileRow : GAME_MAP) {
      for (Tile t: tileRow) {
        t.pollution = getPollution(t.getLandUse());
        t.distToRiver = distToRiver(t.getX(),t.getY());
        t.decayPollution = calcDecayPollution(t.pollution, t.distToRiver);
      }
    }
  }

  //**** Methods to place rivers of various designs in map  ****//  -----------------------------------------------
  void initializeRiver2() {
    /* River for a 30*30 board.
    *Adds River Tiles at designated locations
    *River design 2 used. (See Excel sheet)*/
    for (int[] c: RIVER_TILES) { 
      River r = new River();
      GAME_MAP[c[0]][c[1]].landU = r;
      riverTiles.add(GAME_MAP[c[0]][c[1]]);
    }
  }
  
  //**** Methods to calculate pollution / money according various models  ****//  -----------------------------------------------
  Tile[] getAllTiles(){
    Tile[] allTiles = new Tile[(SIZE_X)*(SIZE_Y)];
    int i = 0;
    for (Tile[] tileRow : GAME_MAP) {
      for (Tile t: tileRow) {
        allTiles[i] = t;
        i++;
      }
    }
    return allTiles;
  }
  
  
  void sumLandUses() {
    /* Sums the number of each landUse  */
    factories = 0;
    farms = 0;
    houses = 0;
    for (Tile[] tileRow : GAME_MAP) {
      for (Tile t: tileRow) {
        if (t.getLandUse() instanceof Factory) factories ++;
        if (t.getLandUse() instanceof Farm) farms++;
        if (t.getLandUse() instanceof House) houses ++;
      }
    }
  }
  
  int sumPollution() {
    /* Returns simple sum of pollution generated for all Tiles */
    int totalPollution = 0;
    for (Tile[] tileRow : GAME_MAP) {
      for (Tile t: tileRow) {
         totalPollution += t.getTilePollution();
      }
    }
    //if (totalPollution < 0) totalPollution = 0;
    return totalPollution;
  }
  
  float sumActualProfits() {
    /* Returns the total actual profits made from all the property on the map */
    float profit = 0;
    for (Tile[] tileRow : GAME_MAP) {
      for (Tile t: tileRow) { 
        if (! (t.getLandUse() instanceof River)){
        profit += t.getActualProfit();
        }
      }
    }
    return profit;
  }
  
  float calcScore() {
    /* Returns the player's score */
    return totalActualProfits/totalDecayPollution;
  }
  
  void updatePol() {
    for (Tile[] tileRow : GAME_MAP) {
      for (Tile t: tileRow) { 
        t.update();
      }
    }
  }
        
  
  void update() {
    /* Updates the totalPollution and totalDecayPollution and totalActualProfit variables.
    * To be called in each frame */
    sumLandUses();
    updatePol();
    totalPollution = sumPollution();
    totalDecayPollution = sumDecayPollution();
    totalActualProfits = sumActualProfits();
    score = calcScore();
  }
  

  //**** Methods to add, change and remove land uses  ****//  -----------------------------------------------
    
  boolean addFactory(int x, int y) {
    /* Places a new Factory at Location <x, y> on the map. 
    Returns true if successful. False otherwise.  */
    if (factories < FACTORY_QUOTA) {
      Tile t = GAME_MAP[x][y];
      if (! (t.getLandUse() instanceof River)) {
        Factory fc = new Factory();
        t.changeLandUse(fc);
        message2 = "Added a Factory at " + t;
        println("Added a Factory at", t);
        sumLandUses();
        return true;      
      }else {
        message2 = "Cannot built factory in river. Nothing is added.";
        println("Cannot built factory in river. Nothing is added");
        return false;
      }
    } else return false;
  }
  
  boolean addFarm(int x, int y) {
    /* Places a new Farm at Location <x, y> on the map. 
    Returns true if successful. False otherwise. */
    if (farms < FARM_QUOTA) {
      Tile t = GAME_MAP[x][y];
      if (! (t.getLandUse() instanceof River)) {
        Farm fm = new Farm();
        t.changeLandUse(fm); 
        message2 = "Added a Farm at " + t;
        println("Added a Farm at", t);
        sumLandUses();
        return true;
      }else {
        message2 = "Cannot built farm in river. Nothing is added.";
        println("Cannot built farm in river. Nothing is added.");
        return false;
      }
    } else return false;
  }
  
  boolean addHouse(int x, int y) {
    /* Places a new House at Location <x, y> on the map. 
    Returns true if successful. False otherwise. */
    if (houses < HOUSE_QUOTA) {
      Tile t = GAME_MAP[x][y];
      if (! (t.getLandUse() instanceof River)) {
        House hs = new House();
        t.changeLandUse(hs); 
        message2 = "Added a House at " + t;
        println("Added a House at", t);
        sumLandUses();
        return true;
      }else {
        message2 = "Cannot built house in river. Nothing is added.";
        println("Cannot built house in river. Nothing is added.");
        return false;
      }
    } else return false;
  } 
  
  boolean addForest(int x, int y) {
    /* Places a new Forest at Location <x, y> on the map. 
    Returns true if successful. False otherwise.  */
    Tile t = GAME_MAP[x][y];
    if (! (t.getLandUse() instanceof River)) {
      Forest fo = new Forest();
      t.changeLandUse(fo); 
      message2 = "Added a Forest at " + t;
      println("Added a Forest at", t);
      return true;
    }else {
      message2 = "Cannot plant trees in river. Nothing is added.";
      println("Cannot plant trees in river. Nothing is added.");
      return false;
    }
  }
  
  boolean addDirt(int x, int y) {
    /* Places a new Dirt at Location <x, y> on the map. */
    Tile t = GAME_MAP[x][y];
    Dirt di = new Dirt();
    t.changeLandUse(di); 
    return true;
  }
  
  boolean removeLandUse(int x, int y) {
    /* Removes LandUse at Location <x, y> on the map. (changes them to Dirt) 
    Returns true if successful. False otherwise.*/
    Tile t = GAME_MAP[x][y];
    if (! (t.getLandUse() instanceof River)) {
      LandUse olu = t.getLandUse();   //Original land use
      if (olu instanceof Dirt) {
        message2 = "Nothing to remove";
        return false;
      }
      addDirt(x,y);
      message2 = "Removed " + olu.toString() + " at " + t;
      println("Removed land use at", t);
      return true;
    }else {
      message2 = "River cannot be removed.";
      println("River cannot be removed.");
      return false;
    }
  }
}