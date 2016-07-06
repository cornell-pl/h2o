
class ButtonPanel {
  /* Creates and draws a vertical panel of Buttons  */
  int x, y;     //Position of the panel in pixels
  int bWidth;      //The dimension of each Button in pixels
  int bHeight;    
  int interval;     //The vertical spacing between two buttons
  int nexty;   //The yposition of the next button to be added
  ArrayList<Button> Buttons = new ArrayList<Button>();
  
  ButtonPanel(int xp, int yp, int bw, int bh, int i){
    x = xp;
    y = yp;
    bWidth = bw;
    bHeight = bh;
    interval = bHeight + i;
    nexty = y;
  }
   
  void makeAdderButton(LandUse lu, color c, color over, color selected, String l) {
    Buttons.add(new AdderButton(lu, x, nexty, bWidth, bHeight, c, over, selected, l));
    nexty += interval;
  }
  
  void makeDemolishButton(color c, color over, color selected, String l) {
    Buttons.add(new DemolishButton(x, nexty, bWidth, bHeight, c, over, selected, l));
    nexty += interval;
  }
  
  void makeResetButton(int xp, int yp, int bw, int bh, color c, color over, color selected, String l) {
    Buttons.add(new ResetButton(xp, yp, bw, bh, c, over, selected, l));
  }
  
  ArrayList<Button> getButtons() {
    return Buttons;
  }
  
  void display(){
    for (Button b: Buttons) {
      b.display();
    }
  }
}
  
  
class Button{ 
  final PFont BASEFONT = createFont("Arial", 16);
  final PFont SELECTEDFONT = createFont("Arial-Black", 16);
  int x, y;                 // The x- and y-coordinates of the Button in pixels
  int bWidth;                 // Dimensions in pixels
  int bHeight;
  color baseColor;           // Default color value 
  color overColor;           //Color when mouse over button
  color selectedColor;        //Color when button is selected
  String label;
  boolean over = false;     //true if mouse is over button
  
  Button(int xp, int yp, int w, int h, color c, color o, color s, String l) {
    x = xp;
    y = yp;
    bWidth = w;
    bHeight = h;
    baseColor = c;          //Default color
    overColor = o;           //Color when mouse over button
    selectedColor = s; 
    label = l;            //Color when button is in pushed state
  }
  
  void display() {
    stroke(255);
    strokeWeight(1.5);
    fill(255);  //Color of text label
    textAlign(LEFT,CENTER);
    if (pushed == this) { 
      stroke(90);
      strokeWeight(2.5);
      textFont(SELECTEDFONT);
      text(label, x+bWidth+8, y+(bHeight/2.)-3);
      fill(selectedColor);
    }else if (over) {
      textFont(BASEFONT);
      text(label, x+bWidth+5, y+(bHeight/2.)-1);
      fill(overColor);
    }else {
      textFont(BASEFONT);
      text(label, x+bWidth+5, y+(bHeight/2.)-1);
      fill(baseColor);
    }
    rect(x, y, bWidth, bHeight);
    update();
  }  
  
  void press(){
    if (this.over) {      //When button is clicked on
      if (pushed == this) {
        message = "";
        pushed = null;
        println("nulled");
      }else {
      pushed = this;
      message = "Add " + label + "mode is selected";
      message2 = "";
      }
    }return;
  }
 
  // Updates the over field every frame
  void update() {
    if ((mouseX >= x-1) && (mouseX <= x+bWidth+textWidth(label)+8) && 
        (mouseY >= y-1) && (mouseY <= y+bHeight+1)) {
      over = true;
    } else {
      over = false;
    }
  }   
}


class AdderButton extends Button {
  LandUse lu;
  
  AdderButton(LandUse landu, int xp, int yp, int w, int h, color c, color o, color s, String l) {
    super(xp, yp, w, h, c, o, s, l);
    lu = landu;
  }
  
  void addLandUse(Watershed ws, int xpos, int ypos){
    ws.getTile(xpos, ypos).changeLandUse(lu);
  }
}


class DemolishButton extends Button {
  DemolishButton(int xp, int yp, int w, int h, color c, color o, color s, String l) {
    super(xp, yp, w, h, c, o, s, l);
  }
  
  void demolishLandUse(Watershed ws, int xpos, int ypos){
    ws.removeLandUse(xpos, ypos);
  }
}

class ResetButton extends Button {
  ResetButton(int xp, int yp, int w, int h, color c, color o, color s, String l) {
    super(xp, yp, w, h, c, o, s, l);
  }
  
  void resetGame(){
    WS = new Watershed(SIZE_X, SIZE_Y);
  }
  
  @Override
  void press() {
    if (this.over) {      //When button is clicked on
      if (pushed == this) {
        message = "Restarting game";
        message2 = "";
        resetGame();
        graphics.waterS = WS;                
        pushed = null;
        selected = null;
        message = "Game is reset";
        message2 = "";
      } else {
        pushed = this;
        message = "Do you want to reset the map? Click button again to reset.";
        message2 = "Click anywhere to cancel.";
      }
    }
  }
}
  
  
  
  
  
  
  
  
  
    