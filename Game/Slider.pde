Slider slider;

class Slider {
  int bWidth = 220;
  int bHeight = 33;    // width and height of bar
  float x, y;       // x and y position of bar
  int sWidth = 20;        //width and height of slider
  int sHeight = bHeight;
  float spos;  // x position of slider
  float ratio;
  
  int minVal;        //Min and max val of slider
  int maxVal;
  boolean over;           // is the mouse over the slider?
  boolean locked;
  
  Slider(float xp, float yp, int minVal, int maxVal) {
    x = xp;
    y = yp;
    spos = x + bWidth/2-sWidth/2;
    minVal = minVal;
    maxVal = maxVal;
    ratio = (maxVal - minVal)/((float)(bWidth-sWidth));
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
      spos = constrain(mouseX, x, x+bWidth-sWidth);
    }
  }

  void display() {
    stroke(255);
    strokeWeight(1);
    fill(factoryBrown);
    rectMode(CORNER);
    rect(x, y, bWidth, bHeight);
    noStroke();
    fill(50);
    rect(spos, y-1, sWidth, sHeight+2);
    text(getPos(), x, y + 50);
    update();
  }

  float getPos() {
    // Convert spos to be values between minVal and maxVal
    return (spos - x) * ratio;
  }
}