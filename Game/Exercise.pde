public enum LUType {FACTORY, FOREST, FARM, HOUSE, DIRT, RIVER};

float profit(LandUse lu, float dist) {
  return lu.calcActualProfit(dist);
}

float pollution(LandUse lu, float dist) {
  return calcDecayPollution(getPollution(lu), dist);
}

boolean fullyBuilt() {
  return (WS.factories == FACTORY_QUOTA &&
          WS.farms == FARM_QUOTA &&
          WS.houses == HOUSE_QUOTA);
}

boolean buildOk(LandUse lu) {
  if(lu.isFactory())
    return WS.factories < FACTORY_QUOTA;
  if(lu.isFarm())
    return WS.farms < FARM_QUOTA;
  if(lu.isHouse())
    return WS.houses < HOUSE_QUOTA;
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