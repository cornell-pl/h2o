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
      return s.getVal();
    } catch(NullPointerException e){     //This is when those first forests(Game) and example types(GUI) initialized has s field pointed to null
        println("error");
        if (this == FACTORY) {
        s = factoryS;
      } else if (this == FARM){
        s = farmS;
      } else if (this == HOUSE){
        s = houseS;
      } else if (this == FOREST){
        s = forestS;
      }
      return getPollution(this);
    }      
  }
  
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
  
  abstract LUType getType();
  
  abstract float calcActualProfit(float distToR);
}

  
class Factory extends LandUse {
  /* Factory gives fixed profit no matter the location */
  final LUType TYPE = LUType.FACTORY;
  
  Factory () {
   s = factoryS;
   icon = FACTORY_BROWN;   //Color code for drawing on map
   baseProfit = 2000;
   }
 
 float calcActualProfit(float distToRiver) {
    /*Returns the actual profit made according to profit model  */
    return baseProfit/(sqrt(distToRiver)/4 + 0.75);
  }
  
  LUType getType() {
    return TYPE;
  }
 
   @Override
  public String toString() {
    return "Factory";
  }
}

class Farm extends LandUse {
  /* Farm gives less profit further from river  */
  final LUType TYPE = LUType.FARM;
  Farm () {
    icon = FARM_YELLOW;
    baseProfit = 1000;
    s = farmS;
 }
  
  float calcActualProfit(float distToRiver) {
     /*Returns the actual profit made according to profit model  */
    return baseProfit/(distToRiver/5+0.8);
  }
  
  LUType getType() {
    return TYPE;
  }
 
   @Override
  public String toString() {
    return "Farm";
  }
}

class House extends LandUse {
  final LUType TYPE = LUType.HOUSE;
  House() {
    icon = HOUSE_GRAY;
    baseProfit = 700;
    s = houseS;
  }
  
  float calcActualProfit(float distToRiver) {
     /*Returns the actual profit made according to profit model  */
    return baseProfit/(sqrt(distToRiver)/2+0.5);
  }
  
  LUType getType() {
    return TYPE;
  }
  
  @Override
  public String toString() {
    return "House";
  }
}

class Forest extends LandUse {
  final LUType TYPE = LUType.FOREST;
  Forest () {  
    icon = FOREST_GREEN;
    baseProfit = -300;
    s = forestS;
  }
  
  
  float calcActualProfit(float distToRiver) {
     /*Returns the actual profit made according to profit model  */
    return -100;           //Cost of forest is a constant.
  }
  
  LUType getType() {
    return TYPE;
  }
  
  @Override
  public String toString() {
    return "Forest";
  }
}

class Dirt extends LandUse {
  final LUType TYPE = LUType.DIRT;
  Dirt() {
    icon = DIRT_BROWN;
    baseProfit = 0;
 }
 
  float calcActualProfit(float distToRiver) {
    /*Returns the actual profit made according to profit model  */
    return 0;
  }
  
  LUType getType() {
    return TYPE;
  }
 
  @Override
  public String toString() {
    return "Dirt";
  }
}

class River extends LandUse {
  final LUType TYPE = LUType.RIVER;
  River(){
    icon = RIVER_BLUE;
  }
  float calcActualProfit(float distToRiver) {
     /*Returns the actual profit made according to profit model  */
    return 0;
  }
  
  LUType getType() {
    return TYPE;
  }
 
  @Override
  public String toString() {
    return "River";
  }
}

 
  