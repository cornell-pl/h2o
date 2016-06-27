//Defining pollution as global variables
//final int FACTORY_POLLUTION = 20;
//final int FARM_POLLUTION = 12;
//final int HOUSE_POLLUTION = 4;
//final int FOREST_POLLUTION = -2;
//final int DIRT_POLLUTION = 0;

int FACTORY_POLLUTION = 0;
int FARM_POLLUTION = 0;
int HOUSE_POLLUTION = 0;
int FOREST_POLLUTION = 0;
int DIRT_POLLUTION = 0;

int getPollution(LandUse lu) {
    /*Returns the default pollution value of each landUse 
    *This method is used to set the default pollution values when game is initialized*/
    if (lu.getType() == LUType.FACTORY) return FACTORY_POLLUTION;     //Processing doesn't handle enums well. can only be used as enum.THING
    else if (lu.getType() == LUType.FARM) return FARM_POLLUTION;
    else if (lu.getType() == LUType.HOUSE) return HOUSE_POLLUTION;
    else if (lu.getType() == LUType.FOREST) return FOREST_POLLUTION;
    else if (lu.getType() == LUType.DIRT) return DIRT_POLLUTION;
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

float sumDecayPollution() {
  /* Linear decay model of pollution that enters the river.
  Returns total pollution entering river from all sources according decay model defined for each LandUse*/
  float dPollutionTotal = 0.;
  Tile[] allTiles = WS.getAllTiles();
  for (Tile t: allTiles) {   //Calculate pollution contribution from t after linear decay
     dPollutionTotal += t.getDecayPollution();
  }
   //if (dPollutionTotal < 0.) dPollutionTotal = 1.;
   return dPollutionTotal;
}

void pollutionIterator(float targetPollution, float precision) {
  /*CALIBRATION TASK: Iterate through ranges of values for the pollution of each land use type (FACTORY, FARM, HOUSE, FOREST)
  * Print out all possible solutions) */
  int i = 0;
  println("Iterating...");
  for (FACTORY_POLLUTION = 0; FACTORY_POLLUTION <=20; FACTORY_POLLUTION ++){
    for (FARM_POLLUTION = 0; FARM_POLLUTION <= 20; FARM_POLLUTION ++){
      for (HOUSE_POLLUTION = 0; HOUSE_POLLUTION <= 20; HOUSE_POLLUTION ++){
        for (FOREST_POLLUTION = -1; FOREST_POLLUTION > -10 ; FOREST_POLLUTION --){
          WS.update();
          if (WS.totalDecayPollution > targetPollution-precision && WS.totalDecayPollution < targetPollution+precision) {
            println("Solution: ", i, WS.totalDecayPollution);
            println("factoryPollution: ", FACTORY_POLLUTION);
            println("farmPollution: ", FARM_POLLUTION);
            println("housePollution: ", HOUSE_POLLUTION);
            println("forestPollution: ", FOREST_POLLUTION);
            println("");
            i ++;
          }
        }
      }
    }
  }
  println("Done");
}
  
  

 
 
 