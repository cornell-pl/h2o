final color riverBlue = #3CA1E3;
final color factoryBrown = #EA9253; 
final color farmYellow = #F0D446;
final color forestGreen = #5DD65E;
final color dirtBrown = #AF956A;
final color houseTurquoise = #9CC2C4;
final color demolishBeige = #F5DAB9;



//Setting the build quota for each landUse
final int factoryQuota = 40;
final int farmQuota = 60;
final int houseQuota = 100;


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
      return getPollution(this);
    }
  }
  
  abstract float calcActualProfit(float distToR);
}

  
class Factory extends LandUse {
  /* Factory gives fixed profit no matter the location */
  Factory () {
   icon = factoryBrown;   //Color code for drawing on map
   baseProfit = 5000;
   s = factoryS;
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
   icon = farmYellow;
   baseProfit = 2000;
   s = farmS;
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
    icon = houseTurquoise;
    baseProfit = 1000;
    s = houseS;
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
    icon = forestGreen;
    baseProfit = -100;
    s = forestS;
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
   icon = dirtBrown;
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

 
  