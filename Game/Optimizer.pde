

float profit(LandUse lu, float dist) {
  return lu.calcActualProfit(dist);
}

float pollution(LandUse lu, float dist) {
  return lu.calcDecayPollution(dist);
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
    return WS.sumDecayPollution() > 1.0;
  return false;    
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
    bestTile.changeLandUse(bestLandUse);
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
    if (lu.isFactory()) return DEFAULT_FACTORY_POLLUTION;     //Processing doesn't handle enums well. can only be used as enum.THING
    else if (lu.isFarm()) return DEFAULT_FARM_POLLUTION;
    else if (lu.isHouse()) return DEFAULT_HOUSE_POLLUTION;
    else if (lu.isForest()) return DEFAULT_FOREST_POLLUTION;
    else if (lu.isDirt()) return DEFAULT_DIRT_POLLUTION;
    else return 0;
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