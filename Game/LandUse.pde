final color riverBlue = #6FB4D8;
final color factoryBrown = #EA9253; 
final color farmYellow = #F5E77E;
final color forestGreen = #5DD65E;
final color dirtBrown = #AF956A;
final color houseTurquoise = #9EFCD6;
final color demolishBeige = #F5DAB9;

abstract class LandUse {
  float pollution;
  color icon;
  float getPollution() {
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
   pollution = 7;
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
    pollution = 0;     //Zero div error (-infinity pollution) occurs when this is negative. Check math. 
    icon = forestGreen;
  }
}
  
class House extends LandUse {
  House() {
    pollution = 2;
    icon = houseTurquoise;
  }
}
  