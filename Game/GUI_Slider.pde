class Slider { 
  static final int BAR_WIDTH = 180;
  static final int BAR_HEIGHT = 20;    // width and height of bar 
  static final int S_WIDTH = 20;        //width and height of slider
  static final int S_HEIGHT = BAR_HEIGHT;
  final PFont sliderFont = createFont("Calibri", 14);
  
 
  int x, y;       // x and y position of bar
  float spos;  // x position of slider
  boolean over;           // is the mouse over the slider?
  boolean locked;
  color col;
  
  LandUse lu;
  int minVal;        //Min and max val of slider
  int maxVal;
  float defaultVal;    //The initial value of the slider
  float ratio;
  
  Slider(LandUse l, int xp, int yp, int minV, int maxV, color c) {
    lu = l;
    x = xp;
    y = yp;
    minVal = minV;
    maxVal = maxV;
    defaultVal = l.getBasePollution();
    ratio = (maxVal - minVal)/((float)(BAR_WIDTH - S_WIDTH));
    spos = x + (defaultVal-minVal)/ratio;
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
    lu.updatePollution(getVal());
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


 