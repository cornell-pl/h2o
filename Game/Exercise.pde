boolean isDirt(LandUse lu) {
  return lu.getType() == LUType.DIRT;
}
boolean isDirt(Tile t) {
  return isDirt(t.getLandUse());
}
boolean isForest(LandUse lu) {
  return lu.getType() == LUType.FOREST;
}
boolean isForest(Tile t) {
  return isForest(t.getLandUse());
}
boolean isFactory(LandUse lu) {
  return lu.getType() == LUType.FACTORY;
}
boolean isFactory(Tile t) {
  return isFactory(t.getLandUse());
}
boolean isFarm(LandUse lu) {
  return lu.getType() == LUType.FARM;
}
boolean isFarm(Tile t) {
  return isFarm(t.getLandUse());
}
boolean isHouse(LandUse lu) {
  return lu.getType() == LUType.HOUSE;
}
boolean isHouse(Tile t) {
  return isHouse(t.getLandUse());
}

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
  if(isFactory(lu))
    return WS.factories < FACTORY_QUOTA;
  if(isFarm(lu))
    return WS.farms < FARM_QUOTA;
  if(isHouse(lu))
    return WS.houses < HOUSE_QUOTA;
  if (isForest(lu))
    return WS.totalDecayPollution > 1.0;
  return false;    
}

int dirtTiles() {
  int d = 0;
  for(Tile t : WS.getAllTiles()) {
     if(isDirt(t)) {
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
    LandUse[] landUses = { new Factory(), new Farm(), new House() };
    for(Tile t : WS.getAllTiles()) {
      if(isDirt(t)) {
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
    LandUse lu = new Forest();
    if(isDirt(t) && buildOk(lu)) {
      t.changeLandUse(lu);
      WS.update();
    }
  }
  println("Done!");
}