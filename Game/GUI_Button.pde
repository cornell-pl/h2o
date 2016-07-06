Button factoryB;
Button farmB;
Button houseB;
Button forestB;
Button demolishB;
Button resetB;

class ButtonPanel {
  /* Creates and draws a vertical panel of Buttons  */
  int x, y;     //Position of the panel in pixels
  int bWidth;      //The dimension of the Buttons in pixels
  int bHeight;    
  int interval;     //The vertical spacing between two buttons
  
  ButtonPanel(int xp, int yp, int bw, int bh, int i){
    x = xp;
    y = yp;
    bWidth = bw;
    bHeight = bh;
    interval = bHeight + i;
    
    factoryB = new Button(x, y, bWidth, bHeight, FACTORY_BROWN, #73A29C, #EA7E2F, "Factory");
    farmB = new Button(x, y+interval, bWidth, bHeight, FARM_YELLOW, #73A29C, #F0AD1D, "Farm");
    houseB = new Button(x, y+2*interval, bWidth, bHeight, HOUSE_GRAY, #73A29C, #90B3B4, "House");
    forestB = new Button(x, y+3*interval, bWidth, bHeight, FOREST_GREEN, #73A29C, #02A002, "Forest");
    demolishB = new Button(x, y+4*interval, bWidth, bHeight, DEMOLISH_BEIGE, #73A29C, #F5BB74, "Demolish");
    resetB = new Button(x+220, YPOS+TILE_HEIGHT*SIZE_Y-57, bWidth + 5, bHeight + 5, #FFFFFF, #989795, #171717, "RESET MAP");
  }
  
  Button[] getButtons() {
    return new Button[] {factoryB, farmB, houseB, forestB, demolishB, resetB};
  }
  
  void display(){
    factoryB.display();
    farmB.display();
    houseB.display();
    forestB.display();
    demolishB.display();
    resetB.display();
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
     // println("Pressed" + "  " + this.label);
      if (pushed == this) {
        message = "";
        pushed = null;
        println("nulled");
      }else {
      pushed = this;
      message = "Add " + label + "mode is selected";
      message2 = "";
     // println(pushed);
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