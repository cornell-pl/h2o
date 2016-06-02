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
       gameMap[y][x] = l; //helloooooo
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

void addFactory(int x, int y) {
  /* Places a new Factory at coordinate <x, y> on the map. */
  Factory fc = new Factory();
  Location loc = gameMap[y][x];
  loc.changeLandUse(fc);
  if (!luLocs.contains(loc)) luLocs.add(loc);
}

void addFarm(int x, int y) {
  /* Places a new Factory at coordinate <x, y> on the map. */
  Farm fm = new Farm();
  Location loc = gameMap[y][x];
  loc.changeLandUse(fm);
  if (!luLocs.contains(loc)) luLocs.add(loc);
}

void removeLandUse(int x, int y) {
  /* Removes LandUse at coordinate <x, y> on the map. (changes them to GreenFields) */
  GreenField gf= new GreenField();
  Location loc = gameMap[y][x];
  loc.changeLandUse(gf);
  if (luLocs.contains(loc)) luLocs.remove(loc);  //Conditional allows this method to be used on GreenField Tile
}

void trialRun1() {
  /* Trial run of game for testing. Factory added at <14, 2> and <0, 7>, Farm added at <11, 5> */
  addFactory(14, 2);
  addFactory(0, 7);
  addFarm(11, 5);
  
  println("Simple sum of all pollution: ", sumPollution());
  println("Total pollution entering river after linear decay: ", linearDecayPollution());
}