Slider slider;

class Slider {
  int bWidth, bHeight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;
  
  Slider(float xp, float yp, int w, int h) {
    bWidth = w;
    bHeight = h;
    int widthtoheight = w - h;
    ratio = (float)w / (float)widthtoheight;
    xpos = xp;
    ypos = yp-bHeight/2;
    spos = xpos + bWidth/2 - bHeight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + bWidth;
  }
  
  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+bWidth &&
       mouseY > ypos && mouseY < ypos+bHeight) {
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
      newspos = constrain(mouseX-bHeight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/1;
    }
  }

  void display() {
    noStroke();
    fill(100);
    rectMode(CORNER);
    rect(xpos, ypos, bWidth, bHeight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, bHeight, bHeight);
    update();
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}