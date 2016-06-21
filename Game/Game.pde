Watershed WS;
GUI graphics;
final int sizeX = 30;    //Dimensions of the watershed in tiles
final int sizeY = 30;


void setup() {
  frameRate(30);
  size(1600, 1080);
  WS = new Watershed(sizeX, sizeY);   //Creates watershed of size 20*20
}

void draw() {  
  background(204);
  WS.update();
  graphics.render();
}


class Watershed {
  /* Contains all elements of the Game and implements the GUI. All user functions can be accessed from this class */
  Tile[][] gameMap; //2D Matrix of all grid Tiles on game map
  ArrayList<int[]> riverTiles = new ArrayList<int[]>();   //Records the coordinates of all river tiles on map;
  int factories = 0;
  int farms = 0;
  int houses = 0;
  int totalPollution;
  float totalDecayPollution;
  float totalActualProfits;
  float score;
  
  Watershed(int x, int y) {
    /* Constructor: Initializes a watershed of dimension x*y units */
    graphics = new GUI(x, y);
    initializeWithFixedForest();
    setTileVals();
  }     //<>//
  
  void initializeWithFixedForest() {
    gameMap = new Tile[sizeX][sizeY];
    for (int j=0; j<sizeY; j++) {
      for (int i=0; i<sizeX; i++) { 
         Dirt di = new Dirt();
         Tile t = new Tile(di, i, j, 0, 0); //Default zero values for slope and soil
         gameMap[i][j] = t;
        }
      }
    int[][] fCoords = { { 1 , 1 },  { 1 , 2 },  { 1 , 5 },  { 1 , 18 },  { 1 , 19 },  { 2 , 2 },  { 2 , 3 },  { 2 , 4 },  { 2 , 17 },  { 2 , 18 },  { 2 , 19 },  { 2 , 20 },  { 3 , 2 },  { 3 , 3 },  { 3 , 4 },  { 3 , 5 },  { 3 , 16 },  { 3 , 17 },  { 3 , 18 },  { 3 , 19 },  { 4 , 2 },  { 4 , 3 },  { 4 , 4 },  { 4 , 15 },  { 4 , 16 },  { 4 , 17 },  { 4 , 18 },  { 5 , 4 },  { 5 , 17 },  { 5 , 25 },  { 6 , 16 },  { 6 , 17 },  { 6 , 18 },  { 7 , 2 },  { 7 , 17 },  { 7 , 18 },  { 7 , 19 },  { 8 , 17 },  { 8 , 18 },  { 10 , 24 },  { 11 , 23 },  { 11 , 24 },  { 11 , 25 },  { 12 , 23 },  { 12 , 24 },  { 12 , 25 },  { 14 , 20 },  { 14 , 21 },  { 15 , 19 },  { 15 , 20 },  { 15 , 21 },  { 15 , 22 },  { 15 , 23 },  { 16 , 2 },  { 16 , 18 },  { 16 , 19 },  { 16 , 20 },  { 16 , 21 },  { 17 , 18 },  { 17 , 19 },  { 17 , 20 },  { 18 , 4 },  { 21 , 20 },  { 21 , 22 },  { 21 , 23 },  { 22 , 3 },  { 22 , 4 },  { 22 , 9 },  { 22 , 19 },  { 22 , 20 },  { 22 , 21 },  { 22 , 22 },  { 22 , 23 },  { 23 , 2 },  { 23 , 3 },  { 23 , 4 },  { 23 , 18 },  { 23 , 19 },  { 23 , 20 },  { 23 , 21 },  { 23 , 22 },  { 23 , 23 },  { 24 , 1 },  { 24 , 2 },  { 24 , 3 },  { 24 , 4 },  { 24 , 5 },  { 24 , 19 },  { 24 , 20 },  { 24 , 21 },  { 24 , 22 },  { 24 , 23 },  { 25 , 2 },  { 25 , 3 },  { 25 , 4 },  { 25 , 5 },  { 25 , 12 },  { 25 , 13 },  { 25 , 20 },  { 25 , 21 },  { 25 , 22 },  { 26 , 3 },  { 26 , 4 },  { 26 , 5 },  { 26 , 6 },  { 26 , 12 },  { 26 , 13 },  { 26 , 23 },  { 26 , 24 },  { 26 , 25 },  { 27 , 4 },  { 27 , 12 },  { 27 , 24 },  { 27 , 25 },  { 27 , 26 },  { 28 , 25 },  { 28 , 26 } };
    for (int[] c: fCoords) { 
      Forest fo = new Forest();
      gameMap[c[0]][c[1]].landU = fo;
    }
    initializeRiver2();    //Creates the river
  }
  
  
  void initializeWithRandomForest() {
    gameMap = new Tile[sizeX][sizeY];
    for (int j=0; j<sizeY; j++) {
      for (int i=0; i<sizeX; i++) { 
         float r = random(0,1);
         if (r > 0.9) {
           Forest fo = new Forest();
           Tile t = new Tile(fo, i, j, 0, 0); //Default zero values for slope and soil
           gameMap[i][j] = t;
         }else{
           Dirt di = new Dirt();
           Tile t = new Tile(di, i, j, 0, 0); //Default zero values for slope and soil
           gameMap[i][j] = t;
         }
      }
    }
    initializeRiver2();    //Creates the river
  }
  
  void setTileVals() {
    /* Sets the pollution, ld pollution and distToRiver for each tile.
    * Called once after map is initialized */
    for (Tile[] tileRow : gameMap) {
      for (Tile t: tileRow) {
        t.pollution = t.landU.getPollution();
        t.distToR = distToRiver(t.getX(),t.getY());
        t.decayPollution = t.landU.calcDecayPollution(t.distToR);
      }
    }
  }

  //**** Methods to place rivers of various designs in map  ****//  -----------------------------------------------
  void initializeRiver2() {
    /* River for a 30*30 board.
    *Adds River Tiles at designated locations
    *River design 2 used. (See Excel sheet)*/
    int[][] rCoords = { { 5 , 5 },  { 5 , 19 },  { 5 , 20 },  { 5 , 21 },  { 6 , 5 },  { 6 , 21 },  { 7 , 5 },  { 7 , 6 },  { 7 , 21 },  { 8 , 6 },  { 8 , 21 },  { 8 , 22 },  { 9 , 6 },  { 9 , 22 },  { 10 , 6 },  { 10 , 7 },  { 10 , 22 },  { 11 , 6 },  { 11 , 7 },  { 11 , 8 },  { 11 , 9 },  { 11 , 14 },  { 11 , 15 },  { 11 , 16 },  { 11 , 22 },  { 12 , 7 },  { 12 , 8 },  { 12 , 9 },  { 12 , 10 },  { 12 , 11 },  { 12 , 12 },  { 12 , 13 },  { 12 , 14 },  { 12 , 15 },  { 12 , 16 },  { 12 , 17 },  { 12 , 18 },  { 12 , 19 },  { 12 , 20 },  { 12 , 21 },  { 12 , 22 },  { 13 , 9 },  { 13 , 10 },  { 13 , 11 },  { 13 , 12 },  { 13 , 13 },  { 13 , 14 },  { 13 , 16 },  { 13 , 17 },  { 13 , 18 },  { 13 , 19 },  { 13 , 20 },  { 13 , 21 },  { 13 , 22 },  { 13 , 23 },  { 13 , 24 },  { 13 , 25 },  { 14 , 7 },  { 14 , 8 },  { 14 , 9 },  { 14 , 11 },  { 14 , 12 },  { 14 , 18 },  { 14 , 19 },  { 14 , 22 },  { 14 , 23 },  { 14 , 24 },  { 14 , 25 },  { 14 , 26 },  { 14 , 27 },  { 14 , 28 },  { 14 , 29 },  { 15 , 6 },  { 15 , 11 },  { 15 , 17 },  { 15 , 18 },  { 15 , 24 },  { 15 , 25 },  { 15 , 26 },  { 15 , 27 },  { 15 , 28 },  { 15 , 29 },  { 16 , 5 },  { 16 , 11 },  { 16 , 16 },  { 16 , 17 },  { 16 , 26 },  { 16 , 27 },  { 16 , 28 },  { 16 , 29 },  { 17 , 4 },  { 17 , 10 },  { 17 , 11 },  { 17 , 16 },  { 17 , 27 },  { 17 , 28 },  { 17 , 29 },  { 18 , 9 },  { 18 , 10 },  { 18 , 16 },  { 18 , 17 },  { 19 , 8 },  { 19 , 9 },  { 20 , 7 },  { 20 , 8 },  { 21 , 7 },  { 22 , 7 },  { 23 , 6 },  { 23 , 7 },  { 23 , 8 },  { 24 , 7 },  { 24 , 8 },  { 25 , 7 } };
    for (int[] c: rCoords) { 
      River r = new River();
      gameMap[c[0]][c[1]].landU = r;
      riverTiles.add(c);
    }
  }
  
  void initializeRiver1() {
    /* Simple river for a 20*20 board.
    *Adds River Tiles at designated locations
    *River design 1 used. (See Excel sheet)*/
    int yp = 7;
    for (int x=1; x<=17; x++) { 
      River r = new River();
      gameMap[x][yp].landU = r;
      riverTiles.add(new int[] {x, yp});
    }
    int xp = 9;
    for (int y=7; y<sizeY; y++) {    //River auto-scales to reach bottom
      River r = new River();
      gameMap[xp][y].landU = r;
      riverTiles.add(new int[] {xp, y});
    }
  }
  
  float distToRiver(int x, int y) {
    /* Helper: Returns the distance of location <x, y> to closest River Tile. */
    float minDist = (float) Integer.MAX_VALUE;
    for (int[] rCoords: riverTiles) {
      float d = dist(x, y, rCoords[0], rCoords[1]);
      if (d < minDist) minDist = d;
    }
    return minDist;
  }
  
  //**** Methods to calculate pollution / money according various models  ****//  -----------------------------------------------
  void sumLandUses() {
    /* Sums the number of each landUse  */
    factories = 0;
    farms = 0;
    houses = 0;
    for (Tile[] tileRow : gameMap) {
      for (Tile t: tileRow) {
        if (t.getLandU() instanceof Factory) factories ++;
        if (t.getLandU() instanceof Farm) farms++;
        if (t.getLandU() instanceof House) houses ++;
      }
    }
  }
  
  int sumPollution() {
    /* Returns simple sum of pollution generated for all Tiles */
    int totalPollution = 0;
    for (Tile[] tileRow : gameMap) {
      for (Tile t: tileRow) {
        totalPollution += t.getPollution();
      }
    }
    if (totalPollution < 0) totalPollution = 0;
    return totalPollution;
  }

  float sumDecayPollution() {
    /* Linear decay model of pollution that enters the river.
    Returns total pollution entering river from all sources according decay model defined for each LandUse*/
    float dPollutionTotal = 0.;
    for (Tile[] tileRow : gameMap) {
      for (Tile t: tileRow) {   //Calculate pollution contribution from t after linear decay
          dPollutionTotal += t.getDecayPollution();
        }
     }
     if (dPollutionTotal < 0.) dPollutionTotal = 1.;
     return dPollutionTotal;
  }
  
  float sumActualProfits() {
    /* Returns the total actual profits made from all the property on the map */
    float profit = 0;
    for (Tile[] tileRow : gameMap) {
      for (Tile t: tileRow) { 
        if (! (t.getLandU() instanceof River)){
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
    for (Tile[] tileRow : gameMap) {
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
    if (factories < factoryQuota) {
      Tile t = gameMap[x][y];
      if (! (t.getLandU() instanceof River)) {
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
    if (farms < farmQuota) {
      Tile t = gameMap[x][y];
      if (! (t.getLandU() instanceof River)) {
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
    if (houses < houseQuota) {
      Tile t = gameMap[x][y];
      if (! (t.getLandU() instanceof River)) {
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
    Tile t = gameMap[x][y];
    if (! (t.getLandU() instanceof River)) {
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
    Tile t = gameMap[x][y];
    Dirt di = new Dirt();
    t.changeLandUse(di); 
    return true;
  }
  
  boolean removeLandUse(int x, int y) {
    /* Removes LandUse at Location <x, y> on the map. (changes them to Dirt) 
    Returns true if successful. False otherwise.*/
    Tile t = gameMap[x][y];
    if (! (t.getLandU() instanceof River)) {
      LandUse olu = t.getLandU();   //Original land use
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
  
  
  //**** Heat map methods  ****//  -----------------------------------------------
  
  ArrayList<Tile> neighbors = new ArrayList<Tile>();
  void getNeighbors(Tile t) { 
    if (!(t.getLandU() instanceof Forest)) {
      String T = t.getLandU().toString();        //The String representing the name of the landUse;
      ArrayList<Tile> n = new ArrayList<Tile>();
          if(t.getX() > 0) {
            Tile left = gameMap[t.getX()-1][t.getY()];
            n.add(left);
            if (t.getY() > 0) {
              Tile topLeft = gameMap[t.getX()-1][t.getY()-1];
              n.add(topLeft);
            }
            if (t.getY() < sizeY-1) {
              Tile bottomLeft = gameMap[t.getX()-1][t.getY()+1];
              n.add(bottomLeft);
            }
          }
          if (t.getX() < sizeX -1) {
            Tile right = gameMap[t.getX()+1][t.getY()];
            n.add(right);
            if (t.getY() > 0) {
              Tile topRight = gameMap[t.getX()+1][t.getY()-1];
              n.add(topRight);
            }
            if (t.getY() < sizeY -1) {
              Tile bottomRight = gameMap[t.getX()+1][t.getY()+1];
              n.add(bottomRight);
          }
          if (t.getY() > 0) {
            Tile up = gameMap[t.getX()][t.getY()-1];
            n.add(up);
          }
          if (t.getY() < sizeY -1) {
            Tile down = gameMap[t.getX()][t.getY()+1];
            n.add(down);
          }

        for (Tile x : n) {
          if (x.getLandU().toString().equals(T) && !neighbors.contains(x)) {
            neighbors.add(x);
            getNeighbors(x);
          }
        }
       }
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
  println("Total pollution entering river after linear decay: ", WS.sumDecayPollution());
}