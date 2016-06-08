final color riverBlue = #7CE3F5;
final color factoryBrown = #E36607; 
final color farmYellow = #F5E77E;

abstract class LandType {
  color icon;
  color getIcon() {
    return icon;
  }
}

class River extends LandType {
  River(){
    icon = riverBlue;
  }
}

abstract class LandUse extends LandType {
  int pollution;
  int getPollution() {
    /*Returns pollution of LandUse */
    return pollution;
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

class GreenField extends LandUse {
  GreenField () {
    pollution = 0;
    icon = #7FF57E;
  }
}
  