final color riverBlue = #6FB4D8;
final color factoryBrown = #E36607; 
final color farmYellow = #F5E77E;
final color forestGreen = #5DD65E;
final color dirtBrown = #AF956A;

abstract class LandUse {
  int pollution;
  color icon;
  int getPollution() {
    /*Returns pollution of LandUse */
    return pollution;
  }
  color getIcon() {
    return icon;
  }
}

class River extends LandUse {
  River(){
    icon = riverBlue;
  }
}
  
class Factory extends LandUse {
 Factory () {
   pollution = 10;
   icon = factoryBrown;   //Color code for drawing on map
 }
}

class Farm extends LandUse {
 Farm () {
   pollution = 5;
   icon = farmYellow;
 }
}

class Dirt extends LandUse {
 Dirt() {
   pollution = 0;
   icon = dirtBrown;
 }
}

class Forest extends LandUse {
  Forest () {
    pollution = 0;
    icon = forestGreen;
  }
}
  