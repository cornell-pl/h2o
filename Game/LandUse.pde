final color RIVER_BLUE = #3CA1E3;
final color FACTORY_BROWN = #EA9253; 
final color FARM_YELLOW = #F0D446;
final color FOREST_GREEN = #5DD65E;
final color HOUSE_GRAY = #9CC2C4;
final color DIRT_BROWN = #AF956A;
final color DEMOLISH_BEIGE = #F5DAB9;

//Setting the build quota for each landUse
final int FACTORY_QUOTA = 40;
final int FARM_QUOTA = 60;
final int HOUSE_QUOTA = 100;

public enum LUType {FACTORY, FARM, HOUSE, FOREST, DIRT, RIVER}

abstract class LandUse {
  color icon;
  int baseProfit;
  Slider s;
  
  color getIcon() {
    return icon;
  }
   
  int getBaseProfit() {
    return baseProfit;
  }
  
  int getSliderPollution() {
    try{ 
      return this.s.getVal();
    }catch(NullPointerException e){
      if (this instanceof Forest) {
        return forestS.getVal();       //Hotfix for forest pollution not updating when first init
      }return getPollution(this);
    }
  }
  
  boolean equals(Class c){
    return true;
  }
  
  abstract LUType getType();
  
  abstract float calcActualProfit(float distToR);
}

  
class Factory extends LandUse {
  /* Factory gives fixed profit no matter the location */
  final LUType type = LUType.FACTORY;
  Factory () {
   icon = FACTORY_BROWN;   //Color code for drawing on map
   baseProfit = 5000;
   s = factoryS;
   }
 
 float calcActualProfit(float distToRiver) {
    /*Returns the actual profit made according to profit model  */
    return baseProfit;
  }
  
  LUType getType() {
    return type;
  }
 
   @Override
  public String toString() {
    return "Factory";
  }
}

class Farm extends LandUse {
  /* Farm gives less profit further from river  */
  final LUType type = LUType.FARM;
  Farm () {
    icon = FARM_YELLOW;
    baseProfit = 2000;
    s = farmS;
 }
  
  float calcActualProfit(float distToRiver) {
     /*Returns the actual profit made according to profit model  */
    return baseProfit/(sq(distToRiver)/2+0.5);
  }
  
  LUType getType() {
    return type;
  }
 
   @Override
  public String toString() {
    return "Farm";
  }
}

class House extends LandUse {
  final LUType type = LUType.HOUSE;
  House() {
    icon = HOUSE_GRAY;
    baseProfit = 1000;
    s = houseS;
  }
  
  float calcActualProfit(float distToRiver) {
     /*Returns the actual profit made according to profit model  */
    return baseProfit/sqrt(distToRiver);
  }
  
  LUType getType() {
    return type;
  }
  
  @Override
  public String toString() {
    return "House";
  }
}

class Forest extends LandUse {
  final LUType type = LUType.FOREST;
  Forest () {  
    icon = FOREST_GREEN;
    baseProfit = -100;
    s = forestS;
  }
  
  
  float calcActualProfit(float distToRiver) {
     /*Returns the actual profit made according to profit model  */
    return -100;           //Cost of forest is a constant.
  }
  
  LUType getType() {
    return type;
  }
  
  @Override
  public String toString() {
    return "Forest";
  }
}

class Dirt extends LandUse {
  final LUType type = LUType.DIRT;
  Dirt() {
    icon = DIRT_BROWN;
    baseProfit = 0;
 }
 
  float calcActualProfit(float distToRiver) {
    /*Returns the actual profit made according to profit model  */
    return 0;
  }
  
  LUType getType() {
    return type;
  }
 
  @Override
  public String toString() {
    return "Dirt";
  }
}

class River extends LandUse {
  final LUType type = LUType.FACTORY;
  River(){
    icon = RIVER_BLUE;
  }
  float calcActualProfit(float distToRiver) {
     /*Returns the actual profit made according to profit model  */
    return 0;
  }
  
  LUType getType() {
    return type;
  }
 
  @Override
  public String toString() {
    return "River";
  }
}

 
  