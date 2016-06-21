Slider factoryS;
Slider farmS;
Slider houseS;
Slider forestS;

class Slider {
  int x, y;       // x and y position of bar
  int bWidth = 180;
  int bHeight = 20;    // width and height of bar 
  int sWidth = 20;        //width and height of slider
  int sHeight = bHeight;
  float spos;  // x position of slider
  int minVal;        //Min and max val of slider
  int maxVal;
  float defaultVal;    //The initial and default value of the slider
  float ratio;
 
  boolean over;           // is the mouse over the slider?
  boolean locked;
  String label;
  color col;
  
  PFont sliderFont = createFont("Calibri", 14);
  
  Slider(int xp, int yp, int minV, int maxV, float defaultV, String l, color c) {
    x = xp;
    y = yp;
    minVal = minV;
    maxVal = maxV;
    defaultVal = defaultV;
    ratio = (maxVal - minVal)/((float)(bWidth-sWidth));
    spos = x + (defaultVal-minVal)/ratio;
    label = l;
    col = c ;
  }
  
  boolean overEvent() {
    if (mouseX > x && mouseX < x+bWidth &&
       mouseY > y && mouseY < y+bHeight) {
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
      spos = constrain(mouseX, x+1, x+bWidth-sWidth);
    }
  }

  void display() {
    stroke(255);
    strokeWeight(1);
    fill(col);
    rectMode(CORNER);
    rect(x, y, bWidth, bHeight);
    noStroke();
    fill(80);
    rect(spos, y-1, sWidth, sHeight+2);
    fill(0);
    textFont(sliderFont); 
    text(round(getVal()), x + bWidth + 15, y+7);
    update();
  }

  float getVal() {
    // Convert spos to be values between minVal and maxVal
    return ((spos - x) * ratio) + minVal;
  }
}