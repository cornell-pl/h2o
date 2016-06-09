final color riverBlue = #7CE3F5;
final color factoryBrown = #E36607; 
final color farmYellow = #F5E77E;

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

class GreenField extends LandUse {
  GreenField () {
    pollution = 0;
    icon = #7FF57E;
  }
}
  