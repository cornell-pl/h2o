abstract class LandType {
}

class River extends LandType {
  River(){
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
 }
}

class Farm extends LandUse {
 Farm () {
   pollution = 5;
 }
}

class GreenField extends LandUse {
  GreenField () {
    pollution = 0;
  }
}
  