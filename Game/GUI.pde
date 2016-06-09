final static int xpos = 40;   //xpos and ypos determines the position of the top left corner of the map, in pixels
final static int ypos = 40;
final static int tileWidth = 20;   //width of a tile in pixels
final static int tileHeight = 20;    //height of a tile in pixels

class GUI {

  GUI(int x, int y) {
    factoryB = new Button(Button.xposB, Button.yposB, tileWidth, tileHeight, factoryBrown, #73A29C, #575FAD, "Factory");
    farmB = new Button(Button.xposB, Button.yposB + 50, tileWidth, tileHeight, farmYellow, #73A29C, #F0AD1D, "Farm");
    //removeB = new Button(xpos, ypos+100, tileWidth, tileHeight, farmYellow, #73A29C, #F0AD1D, "Farm");
  }
  
  void render() {
    /* Single function for all graphics.
    * Draws each frame   */
    for (Tile[] tileRow : WS.gameMap) {
      for (Tile t: tileRow) {
        drawTile(t.getX(), t.getY(), t.getLandT().getIcon());
      }
    }
    axisLabels();
    factoryB.display();
    farmB.display();
  }
  
  
  //**** Draws elements of the game map  ****//  -----------------------------------------------
  void axisLabels() {
    /* Draw axis labels. */
    int xcount = 0;
    for (int x=xpos; x < sizeX*tileWidth+xpos; x+=tileWidth){
      text(xcount, x+3, xpos-7);
      xcount ++;
    }
    int ycount = 0;
    for (int y=ypos; y < sizeY*tileHeight+ypos; y+=tileHeight){
      text(ycount, ypos-21, y+15);
      ycount ++;
    }
  }
  
  void drawTile(int x, int y, color c) {
    /* Draws a tile at Location <x, y> on game map, fill color c */
    stroke(255);
    fill(c);
    rect(x*tileWidth + xpos, y*tileHeight + ypos, tileWidth, tileHeight);
    fill(255);    //resets to white.
  }
}

//**** Buttons and mouse interaction  ****//  -----------------------------------------------
Button factoryB;
Button farmB;
Button removeB;


void mousePressed() {
  if (factoryB.over) {      //When factory button is clicked on
    factoryB.press();
    farmB.isPressed = false;     //Reset all other buttons when one is pressed
    //removeB.isPressed = false;
  }
  else if (farmB.over) {      //When farm button is clicked on
    farmB.press();
    factoryB.isPressed = false;     //Reset all other buttons when one is pressed
    //removeB.isPressed = false;
  }
  else if (mouseOverMap()){     //When mouse clicked on tile
    int[] loc = converter(mouseX, mouseY);
    if (factoryB.isPressed) {        //If factory button is in pressed state
    WS.addFactory(loc[0], loc[1]);
    } else if (farmB.isPressed) {        //If farm button is in pressed state
    WS.addFarm(loc[0], loc[1]);
    }
  }
  else {
    factoryB.isPressed = false;     //Reset all buttons when click on blank areas
    farmB.isPressed = false;     
    //removeB.isPressed = false;
  }
}

boolean mouseOverMap(){
  /* Helper function: Returns true if the mouse position is over the Watershed map. false otherwise. */
  int[] xRange = {xpos, xpos + sizeX*tileWidth};
  int[] yRange = {ypos, ypos + sizeY*tileHeight};
  return ((mouseX > xRange[0] && mouseX < xRange[1]) && (mouseY > yRange[0] && mouseY < yRange[1]));
}

int[] converter(int xraw, int yraw) {
  /*Helper function: converts raw coordinates x and y in frame to tile locations   */
    int xloc = 0;
    int yloc = 0;
    xloc = (xraw-xpos)/tileWidth;
    yloc = (yraw-ypos)/tileHeight;
    int[] out = {xloc, yloc};
    return out;
}


class Button{
  final static int xposB = xpos + sizeX*tileWidth + 40;    //Drawing dimensions. xpos and ypos are the coordinates of the top most button. 
  final static int yposB = 100;    //All buttons scale with respect to this
  int x, y;                 // The x- and y-coordinates of the Button in pixels
  int bWidth;                 // Dimensions in pixels
  int bHeight;
  color baseColor;           // Default color value 
  color overColor;           //Color when mouse over button
  color selectedColor;        //Color when button is selected
  String label;
  
  boolean over = false;
  boolean isPressed = false;     //press state of the button
  
  Button(int xp, int yp, int w, int h, color c, color o, color s, String l) {
    x = xp;
    y = yp;
    bWidth = w;
    bHeight = h;
    baseColor = c;
    overColor = o;           //Color when mouse over button
    selectedColor = s; 
    label = l;
  }
  
  void display() {
    fill(255);  //Color of text label
    text(label, x+bWidth+5, y+15);
    if (isPressed) {
      fill(0);  //Color of text label
      text(label + " is selected", 20, ypos + sizeY*tileHeight + 30);    
      fill(selectedColor);
    }else if (over) {
      fill(overColor);
    }else {
      fill(baseColor);
    }
    rect(x, y, bWidth, bHeight);
    update();
  }  
  
  // Updates the over field every frame
  void update() {
    if ((mouseX >= x) && (mouseX <= x+bWidth) && 
        (mouseY >= y) && (mouseY <= y+bHeight)) {
      over = true;
    } else {
      over = false;
    }
  }
  
  // Respond to mousePressed() event
  void press() {
    if (over) {
      if (! isPressed) {
        isPressed = true;
      }else{
        isPressed = false;
      } 
    } else {
      isPressed = false;
    }
  }
}