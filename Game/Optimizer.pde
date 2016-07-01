public enum LUType {FACTORY, FOREST, FARM, HOUSE, DIRT, RIVER};

float profit(LandUse lu, float dist) {
  return lu.calcActualProfit(dist);
}

float pollution(LandUse lu, float dist) {
  return calcDecayPollution(getPollution(lu), dist);
}

boolean fullyBuilt() {
  return (WS.countFactories() == FACTORY_QUOTA &&
          WS.countFarms() == FARM_QUOTA &&
          WS.countHouses() == HOUSE_QUOTA);
}

boolean buildOk(LandUse lu) {
  if(lu.isFactory())
    return WS.countFactories() < FACTORY_QUOTA;
  if(lu.isFarm())
    return WS.countFarms() < FARM_QUOTA;
  if(lu.isHouse())
    return WS.countHouses() < HOUSE_QUOTA;
  if (lu.isForest())
    return WS.totalDecayPollution > 1.0;
  return false;    
}

int dirtTiles() {
  int d = 0;
  for(Tile t : WS.getAllTiles()) {
     if(t.isDirt()){
       d++;
     }    
   }
   return d;
}

void optimize() {
  println("Starting optimization..."); 
  while(!fullyBuilt()) {
    float bestScore = 0.0;
    Tile bestTile = null;
    LandUse bestLandUse = null;
    LandUse[] landUses = { FACTORY, FARM, HOUSE };
    for(Tile t : WS.getAllTiles()) {
      if(t.isDirt()) {
        float dist = t.distToRiver;
        for(LandUse lu : landUses) {
          if(buildOk(lu)) {
            float luProfit = profit(lu, dist);
            float luPollution = pollution(lu, dist); 
            float luScore = luProfit / max(1.0, luPollution - 6.75);
            if(luScore > bestScore) {
              bestTile = t;
              bestLandUse = lu;
              bestScore = luScore;
            }
          } // if allowed to build this land use type
        } // for each land use
      } // if legal to build here
    } // for each tile
    println("Changing " + bestTile + " to " + bestLandUse);
    bestTile.changeLandUse(bestLandUse); //<>//
    WS.update();
  } // while not fully built
  for(Tile t : WS.getAllTiles()) {
    LandUse lu = FOREST;
    if(t.isDirt() && buildOk(lu)) {
      t.changeLandUse(lu);
      WS.update();
    }
  }
  println("Done!");
}

int getPollution(LandUse lu) {
    /*Returns the default pollution value of each landUse 
    *This method is used to set the default pollution values when game is initialized*/
    if (lu.isFactory()) return FACTORY_POLLUTION;     //Processing doesn't handle enums well. can only be used as enum.THING
    else if (lu.isFarm()) return FARM_POLLUTION;
    else if (lu.isHouse()) return HOUSE_POLLUTION;
    else if (lu.isForest()) return FOREST_POLLUTION;
    else if (lu.isDirt()) return DIRT_POLLUTION;
    else return 0;
}

float calcDecayPollution(float pollution, float distToRiver) {
   /* Returns the pollution entering river of Tile t according to distance decay model.  */
     float decayPollution = pollution/(distToRiver/2+0.5);
     return decayPollution;
}

float distToRiver(int x, int y) {
    /* Helper: Returns the distance of location <x, y> to closest River Tile. */
    float minDist = Float.MAX_VALUE;
    for (Tile t: riverTiles) {
      float d = dist(x, y, t.getX(), t.getY());
      if (d < minDist) minDist = d;
   }
   return minDist;
}

float rawSumDecayPollution() {
  /* Linear decay model of pollution that enters the river.
  Returns total pollution entering river from all sources according decay model defined for each LandUse*/
  float dPollutionTotal = 0.;
  for (Tile t: WS.getAllTiles()) {   //Calculate pollution contribution from t after linear decay
     dPollutionTotal += t.getDecayPollution();
  }
  return dPollutionTotal;  
}

float sumDecayPollution() {
  return max(1.0,rawSumDecayPollution());
}