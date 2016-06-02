void setup() {
  size(600, 600);
  initialize(20);
  initalizeRiver1();
  trialRun1();
}

void draw() {
}

Location[][] gameMap; //2D Matrix of all grid Locations on game map
ArrayList<Location> luLocs = new ArrayList<Location>(); //List of all LandUse (excluding GreenFields) Locations on game map
ArrayList<Location> riverLocs = new ArrayList<Location>(); //List of all River Locations on game map

void initialize(int s) {
  /*Initializes a game with square gameboard of linear dimension s 
  All locations are initialized with GreenFields*/
  gameMap = new Location[s][s];
   for (int y=0; y<s; y++) {
     for (int x=0; x<s; x++) {
       GreenField gf = new GreenField();
       Tile t = new Tile(gf, 0, 0); //Default zero values for slope and soil
       Location l = new Location(x, y, t);
       gameMap[y][x] = l;
     }
   }
}

//TO-DO
void initialize(int x, int y) {
  /*Initializes a game with gameboard of dimension x*y
  All locations are initialized with GreenFields*/
}

void initalizeRiver1() {
  /* Adds River Tiles at designated Locations
  River design 1 used. (See Excel sheet)*/
  for (int x=1; x<=17; x++) { 
    River r = new River();
    Tile t = new Tile(r);    //River Tiles have no (zero) slope and soil values.
    Location loc = gameMap[7][x];
    loc.changeTile(t);
    riverLocs.add(loc);
  }
  for (int y=7; y<=19; y++) { 
    River r = new River();
    Tile t = new Tile(r);
    Location loc = gameMap[y][9];
    loc.changeTile(t);
    riverLocs.add(loc);
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

//TODO: add functions for all landuses. To take in a set of coordinates as argument
void addFactory() {
}

void trialRun1() {
  /* Trial run of game for testing. Factory added at <14, 2> and <0, 7>, Farm added at <11, 5> */
  Factory fc1 = new Factory();
  Location loc1 = gameMap[2][14];
  loc1.changeLandUse(fc1);
  luLocs.add(loc1);
  
  Factory fc2 = new Factory();
  Location loc2 = gameMap[7][0];
  loc2.changeLandUse(fc2);
  luLocs.add(loc2);
  
  Farm fm1 = new Farm();
  Location loc3 = gameMap[5][11];
  loc3.changeLandUse(fm1);
  luLocs.add(loc3);
  
  println("Simple sum of all pollution: ", sumPollution());
  println("Total pollution entering river after linear decay: ", linearDecayPollution());
}