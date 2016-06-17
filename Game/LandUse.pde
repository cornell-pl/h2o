final color riverBlue = #3CA1E3;
final color factoryBrown = #EA9253; 
final color farmYellow = #F0D446;
final color forestGreen = #5DD65E;
final color dirtBrown = #AF956A;
final color houseTurquoise = #9CC2C4;
final color demolishBeige = #F5DAB9;

abstract class LandUse {
  float pollution;
  color icon;
  int baseProfit;
  int cost;
  
  float getPollution() {
    /*Returns pollution of LandUse */
    return pollution;
  }
  
  int getBaseProfit() {
    return baseProfit;
  }
  
  int getCost() {
    return cost;
  }
    
  color getIcon() {
    return icon;
  }
  
  abstract float calcActualProfit(float distToR);
}

  
class Factory extends LandUse {
  /* Factory gives fixed profit no matter the location */
  Factory () {
   pollution = 10;
   icon = factoryBrown;   //Color code for drawing on map
   cost = 2000;
   baseProfit = 5000;
   }
 
 float calcActualProfit(float distToRiver) {
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
   pollution = 7;
   icon = farmYellow;
   cost = 1000;
   baseProfit = 2000;
 }
  
  float calcActualProfit(float distToRiver) {
    return baseProfit/sqrt(distToRiver);
  }
 
   @Override
  public String toString() {
    return "Farm";
  }
}

class House extends LandUse {
  House() {
    pollution = 2;
    icon = houseTurquoise;
    baseProfit = 1000;
    cost = 1000;
  }
  
  float calcActualProfit(float distToRiver) {
    return baseProfit/sqrt(distToRiver);
  }
  
  @Override
  public String toString() {
    return "House";
  }
}

class Forest extends LandUse {
  Forest () {
    pollution = -5;    
    icon = forestGreen;
    baseProfit = -100;
    cost = 500;
  }
  
  float calcActualProfit(float distToRiver) {
    return -100;
  }
  
  @Override
  public String toString() {
    return "Forest";
  }
}

class Dirt extends LandUse {
 Dirt() {
   pollution = 0;
   icon = dirtBrown;
   baseProfit = 0;
   cost = 0;
 }
 
 float calcActualProfit(float distToRiver) {
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
    return 0;
  }
 
  @Override
  public String toString() {
    return "River";
  }
}

 
  