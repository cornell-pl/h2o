Slider factoryS;
Slider farmS;
Slider houseS;
Slider forestS;

class Slider { 
  final int BAR_WIDTH = 180;
  final int BAR_HEIGHT = 20;    // width and height of bar 
  final int S_WIDTH = 20;        //width and height of slider
  final int S_HEIGHT = BAR_HEIGHT;
  final PFont sliderFont = createFont("Calibri", 14);
  
  int x, y;       // x and y position of bar
  float spos;  // x position of slider
  int minVal;        //Min and max val of slider
  int maxVal;
  float defaultVal;    //The initial and default value of the slider
  float ratio;
 
  boolean over;           // is the mouse over the slider?
  boolean locked;
  String label;
  color col;
  
  Slider(int xp, int yp, int minV, int maxV, float defaultV, String l, color c) {
    x = xp;
    y = yp;
    minVal = minV;
    maxVal = maxV;
    defaultVal = defaultV;
    ratio = (maxVal - minVal)/((float)(BAR_WIDTH - S_WIDTH));
    spos = x + (defaultVal-minVal)/ratio;
    label = l;
    col = c ;
  }
  
  boolean overEvent() {
    if (mouseX > x && mouseX < x+BAR_WIDTH &&
       mouseY > y && mouseY < y+BAR_HEIGHT) {
      return true;
    } else {
      return false;
    }
  }
  
  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      spos = constrain(mouseX, x+1, x+BAR_WIDTH-S_WIDTH);
    }
  }

  void display() {
    stroke(255);
    strokeWeight(1);
    fill(col);
    rectMode(CORNER);
    rect(x, y, BAR_WIDTH, BAR_HEIGHT);
    noStroke();
    fill(80);
    rect(spos, y-1, S_WIDTH, S_HEIGHT+2);
    fill(0);
    textFont(sliderFont); 
    text(getVal(), x + BAR_WIDTH + 15, y+7);
    update();
  }

  int getVal() {
    // Convert spos to be values between minVal and maxVal
    return round(((spos - x) * ratio) + minVal);
  }
}