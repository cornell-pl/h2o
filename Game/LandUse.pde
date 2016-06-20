final color riverBlue = #3CA1E3;
final color factoryBrown = #EA9253; 
final color farmYellow = #F0D446;
final color forestGreen = #5DD65E;
final color dirtBrown = #AF956A;
final color houseTurquoise = #9CC2C4;
final color demolishBeige = #F5DAB9;

//Defining pollution as global variables
int factoryPollution = 20;
int farmPollution = 12;
int housePollution = 5;
int forestPollution = -5;
int dirtPollution = 1;

abstract class LandUse {
  color icon;
  float pollution;
  int baseProfit;
  int cost;
  
  color getIcon() {
    return icon;
  }
  
  float getPollution() {
    /*Returns pollution of LandUse */
    return pollution;
  }
  
  float calcDecayPollution(float distToRiver) {
    /* Returns the pollution entering river acording to distance decay model.  */
    float decayPollution = pollution/(distToRiver/2+0.5);
    return decayPollution;
  }
  
  int getBaseProfit() {
    return baseProfit;
  }
  
  int getCost() {
    return cost;
  }
    
  abstract float calcActualProfit(float distToR);
}

  
class Factory extends LandUse {
  /* Factory gives fixed profit no matter the location */
  Factory () {
   pollution = factoryPollution;
   icon = factoryBrown;   //Color code for drawing on map
   cost = 2000;
   baseProfit = 5000;
   }
 
 float calcActualProfit(float distToRiver) {
    /*Returns the actual profit made according to profit model  */
    return baseProfit;
  }
 
   @Override
  public String toString() {
    return "Factory";
  }
}

class Farm extends LandUse {
  /* Farm gives less profit further from river  */
 Farm () {
   pollution = farmPollution;
   icon = farmYellow;
   cost = 1000;
   baseProfit = 2000;
 }
  
  float calcActualProfit(float distToRiver) {
     /*Returns the actual profit made according to profit model  */
    return baseProfit/(sq(distToRiver)/2+0.5);
  }
 
   @Override
  public String toString() {
    return "Farm";
  }
}

class House extends LandUse {
  House() {
    pollution = housePollution;
    icon = houseTurquoise;
    baseProfit = 1000;
    cost = 1000;
  }
  
  float calcActualProfit(float distToRiver) {
     /*Returns the actual profit made according to profit model  */
    return baseProfit/sqrt(distToRiver);
  }
  
  @Override
  public String toString() {
    return "House";
  }
}

class Forest extends LandUse {
  Forest () {
    pollution = forestPollution;    
    icon = forestGreen;
    baseProfit = -100;
    cost = 500;
  }
  
  @Override
  float calcDecayPollution(float distToRiver) {   //Reduction of pullution from forest is a constant.
    return pollution;
  }
  
  float calcActualProfit(float distToRiver) {
     /*Returns the actual profit made according to profit model  */
    return -100;           //Cost of forest is a constant.
  }
  
  @Override
  public String toString() {
    return "Forest";
  }
}

class Dirt extends LandUse {
 Dirt() {
   pollution = dirtPollution;
   icon = dirtBrown;
   baseProfit = 0;
   cost = 0;
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
    icon = riverBlue;
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

 
  