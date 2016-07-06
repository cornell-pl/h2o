final color RIVER_BLUE = #3CA1E3;
final color FACTORY_BROWN = #EA9253; 
final color FARM_YELLOW = #F0D446;
final color FOREST_GREEN = #5DD65E;
final color HOUSE_GRAY = #9CC2C4;
final color DIRT_BROWN = #AF956A;
final color DEMOLISH_BEIGE = #F5DAB9;

//Default pollution values that the game is initialized with
final int DEFAULT_FACTORY_POLLUTION = 20;    
final int DEFAULT_FARM_POLLUTION = 12;
final int DEFAULT_HOUSE_POLLUTION = 4;
final int DEFAULT_FOREST_POLLUTION = -2;
final int DEFAULT_DIRT_POLLUTION = 0;


abstract class LandUse {
  color icon;
  int basePollution;
  int baseProfit;

  boolean isDirt() {
    return (this == DIRT);
  }
  boolean isForest() {
    return (this == FOREST);
  }
  boolean isFactory() {
    return (this == FACTORY);
  }
  boolean isFarm() {
    return (this == FARM);
  }
  boolean isHouse() {
    return (this == HOUSE);
  }
  boolean isRiver() {
    return (this == RIVER);
  }
  
  color getIcon() {
    return icon;
  }
   
  int getBaseProfit() {
    return baseProfit;
  }
  
  int getBasePollution() {
    return basePollution;
  }
  
  void updatePollution(int newPollution){
    basePollution = newPollution;
  }
 
  abstract float calcActualProfit(float distToR);      //Placing pollution and profit calculators at this level allows for 
                                                        //customized functions for each landuse
  float calcDecayPollution(float distToRiver) {
   /* Returns the pollution entering river of Tile t according to distance decay model.  */
     float decayPollution = basePollution/(distToRiver/2+0.5);
     return decayPollution;
  }
}

  
class Factory extends LandUse {
  /* Factory gives fixed profit no matter the location */
  
  Factory () {
    icon = FACTORY_BROWN;   //Color code for drawing on map
    basePollution = DEFAULT_FACTORY_POLLUTION;
    baseProfit = 2000;
  }
 
 float calcActualProfit(float distToRiver) {
    /*Returns the actual profit made according to profit model  */
    return baseProfit/(sqrt(distToRiver)/4 + 0.75);
  }
  
   @Override
  public String toString() {
    return "Factory";
  }
}


class Farm extends LandUse {
  /* Farm gives less profit further from river  */
  Farm () {
    icon = FARM_YELLOW;
    basePollution = DEFAULT_FARM_POLLUTION;
    baseProfit = 1000;
 }
  
  float calcActualProfit(float distToRiver) {
     /*Returns the actual profit made according to profit model  */
    return baseProfit/(distToRiver/5+0.8);
  }
  
   @Override
  public String toString() {
    return "Farm";
  }
}


class House extends LandUse {
  House() {
    icon = HOUSE_GRAY;
    basePollution = DEFAULT_HOUSE_POLLUTION;
    baseProfit = 700;
  }
  
  float calcActualProfit(float distToRiver) {
     /*Returns the actual profit made according to profit model  */
    return baseProfit/(sqrt(distToRiver)/2+0.5);
  }

  @Override
  public String toString() {
    return "House";
  }
}


class Forest extends LandUse {
  Forest () {  
    icon = FOREST_GREEN;
    basePollution = DEFAULT_FOREST_POLLUTION;
    baseProfit = -300;
  }
  
  float calcActualProfit(float distToRiver) {
     /*Returns the actual profit made according to profit model  */
    return baseProfit;      //Cost of forest is a constant.
  }
  
  @Override
  float calcDecayPollution(float distToRiver) {
    /* Forest pollution does not decay */
    return basePollution;
  }
  
  @Override 
  void updatePollution(int newPollution){
    basePollution = newPollution;
    PFOREST.updatePollution(newPollution);
  }
  
  @Override
  public String toString() {
    return "Forest";
  }
}

class PrimaryForest extends Forest {
  /* PrimaryForests have zero cost */
  PrimaryForest () {  
    baseProfit = 0;
  }
  
  float calcActualProfit(float distToRiver) {
    /*Returns the actual profit made according to profit model  */
    return baseProfit; 
  }
  
  @Override 
  void updatePollution(int newPollution){
    basePollution = newPollution;
  }
  
  @Override
  public String toString() {
    return "Forest";
  }
}


class Dirt extends LandUse {
  Dirt() {
    icon = DIRT_BROWN;
    basePollution = DEFAULT_DIRT_POLLUTION;
    baseProfit = 0;
 }
 
  float calcActualProfit(float distToRiver) {
    /*Returns the actual profit made according to profit model  */
    return 0;
  }
 
  @Override
  public String toString() {
    return "Dirt";
  }
}

class River extends LandUse {
  River(){
    icon = RIVER_BLUE;
  }
  float calcActualProfit(float distToRiver) {
     /*Returns the actual profit made according to profit model  */
    return 0;
  }
 
  @Override
  public String toString() {
    return "River";
  }
}

 
  