final int xpos = 40;   //xpos and ypos determines the position of the top left corner of the map, in pixels
final int ypos = 40;
final int tileWidth = 20;   //width of a tile in pixels
final int tileHeight = 20;    //height of a tile in pixels
final int xposB = xpos + sizeX*tileWidth + 40;    //Drawing dimensions. xpos and ypos are the coordinates of the top most button. 
final int yposB = 100;    //All buttons scale with respect to these

class GUI {
  PFont axisFont = createFont("Calibri", 12);
  PFont messageFont = createFont("Calibri", 13);
  PFont budgetFont = createFont("Calibri-Bold", 24);
  PFont numeralFont = createFont("Courier-Bold", 34);
  
  GUI(int x, int y) {
    factoryB = new Button(xposB, yposB, tileWidth, tileHeight, factoryBrown, #73A29C, #EA7E2F, "Factory");
    farmB = new Button(xposB, yposB + 50, tileWidth, tileHeight, farmYellow, #73A29C, #F0AD1D, "Farm");
    houseB = new Button(xposB, yposB + 100, tileWidth, tileHeight, houseTurquoise, #73A29C, #55F7B5, "House");
    forestB = new Button(xposB, yposB + 150, tileWidth, tileHeight, forestGreen, #73A29C, #02A002, "Forest");
    demolishB = new Button(xposB, yposB+200, tileWidth, tileHeight, demolishBeige, #73A29C, #F5BB74, "Demolish");
    resetB = new Button(xposB + 200, yposB+600, tileWidth + 5, tileHeight + 5, #FFFFFF, #989795, #171717, "RESET");
  }
  
  void render() {
    /* Single function for all graphics.
    * Draws each frame   */    
    for (Tile[] tileRow : WS.gameMap) {
      for (Tile t: tileRow) {
        drawTile(t.getX(), t.getY(), t.getLandU().getIcon(), 255);
      }
    }
      showPollution();
    //showDecayPollution();
    //showDist();
    
    
    axisLabels();
    showPollutionSlider();
    showFeedback();
    showSelectedTile();
    showBudget();
    showActualProfits();
    showPurchaseInfo();
    highlight();
    
    factoryB.display();
    farmB.display();
    houseB.display();
    forestB.display();
    demolishB.display();
    resetB.display();
  }
  
  
  //**** Draws elements of the game map  ****//  -----------------------------------------------
  void drawTile(int x, int y, color c, int t) {
    /* Draws a tile at Location <x, y> on game map, fill color c, transparency t */
    stroke(210);
    strokeWeight(1.6);
    fill(c, t);
    rect(x*tileWidth + xpos, y*tileHeight + ypos, tileWidth, tileHeight);
    fill(255);    //resets to white.
  }  
  
  Factory fa = new Factory();     //This would be resolved bty making calcActualProfit() static, but that will mess up Tile.changeLandU()
  Farm fm = new Farm();
  House hs = new House();
  Forest fo = new Forest();
  
  String purchaseInfo = "";
  float projectedProfit = 0;
  void highlight() {
    /* Highlights tiles during click and drag, and shows bulk purchase info */
    int[] posP = converter(mousePX, mousePY);   //tile coordinate when mouse is pressed
    int[] posC = converter(mouseX, mouseY);     //current tile coordinate
    ArrayList<int[]> highlighted = new ArrayList<int[]>();
    for (int x = min(posP[0], posC[0]); x <= max(posP[0], posC[0]); x++) {
      for (int y = min(posP[1], posC[1]); y <= max(posP[1], posC[1]); y++) {
        highlighted.add(new int[] {x, y});
      }
    }
    if (mousePressed && mouseOverMap()) {
      color hc;       //Highlight color
      projectedProfit = 0;     //calculate purchase info
      for (int[] p : highlighted) {
        if  (pushed == factoryB) {    
          hc = factoryBrown;      //highlight color
          Tile t = WS.gameMap[p[0]][p[1]];
          if (! (t.getLandU() instanceof River)) {
            float d = t.getDistToRiver();
            projectedProfit += fa.calcActualProfit(d);         
          } else projectedProfit += 0;
          purchaseInfo = "Will make: $" + projectedProfit;
        }
        else if (pushed == farmB) {
          hc = farmYellow;
          Tile t = WS.gameMap[p[0]][p[1]];
          if (! (t.getLandU() instanceof River)) {
            float d = t.getDistToRiver();
            projectedProfit += fm.calcActualProfit(d);
          } else projectedProfit += 0;
          purchaseInfo = "Will make: $" + projectedProfit;
        }
        else if (pushed == houseB) {
          hc = houseTurquoise;
          Tile t = WS.gameMap[p[0]][p[1]];
          if (! (t.getLandU() instanceof River)) {
            float d = t.getDistToRiver();
            projectedProfit += hs.calcActualProfit(d);
          } else projectedProfit += 0;
          purchaseInfo = "Will make: $" + projectedProfit;
        }
        else if (pushed == forestB) {
          hc = #1EC610;
          Tile t = WS.gameMap[p[0]][p[1]];
          if (! (t.getLandU() instanceof River)) {
            float d = t.getDistToRiver();
            projectedProfit += fo.calcActualProfit(d);
          } else projectedProfit += 0;
          purchaseInfo = "Will make: $" + projectedProfit;
        }
        else if (pushed == demolishB) hc = demolishBeige;
        else {
          hc = #B6FAB1;
          purchaseInfo = "";   //No button is pushed
        } 
        drawTile(p[0], p[1], hc, 100);    //draws highlighted tile
      }
      textFont(messageFont);
      fill(100);
      text(purchaseInfo, 480, ypos + sizeY*tileHeight + 90);  
    }
  }
  
  void showPurchaseInfo() {
    /* Accents the Tile mouse is over, displays purchase information if in purchase mode */
    Tile over = null;   //The Tile mouse is over
    projectedProfit = 0;
    if (mouseOverMap() && !mousePressed) {   //Highlight tile mouse is over
      int[] pos = converter(mouseX, mouseY);
      drawTile(pos[0], pos[1], #B6FAB1, 200);
      over = WS.gameMap[pos[0]][pos[1]];
        if (!(over.getLandU() instanceof River)) {
          if (pushed == factoryB) {
            float distToRiver = over.getDistToRiver();
            projectedProfit = fa.calcActualProfit(distToRiver);
            purchaseInfo = "Will make: $" + projectedProfit;
          }
          else if (pushed == farmB) {
            float distToRiver = over.getDistToRiver();
            projectedProfit = fm.calcActualProfit(distToRiver);
            purchaseInfo = "Will make: $" + projectedProfit;
          }
          else if (pushed == houseB) {
            float distToRiver = over.getDistToRiver();
            projectedProfit = hs.calcActualProfit(distToRiver);
            purchaseInfo = "Will make: $" + projectedProfit;
          }
          else if (pushed == forestB) {
            float distToRiver = over.getDistToRiver();
            projectedProfit = fo.calcActualProfit(distToRiver);
            purchaseInfo = "Will make: $" + projectedProfit;
          } else purchaseInfo = "";   //Button not pressed
        }else purchaseInfo = "";     //Over the river
    }
    textFont(messageFont);
    fill(100);
    text(purchaseInfo, 480, ypos + sizeY*tileHeight + 90);  
  }
  
  void showSelectedTile() {
    /* Accents the selected tile, displays tile information */
    //Draws the box
    stroke(255);
    fill(255);
    rect(480, ypos + sizeY*tileHeight + 10, 190, 110);
    
    //Display info
    if (selected != null) {
      drawTile(selected.getX(), selected.getY(), #B2EBF5, 150);
      fill(0);  //Color of text 
      textFont(messageFont);
      String text1 = selected.toString() + 
                    "     Type: " + selected.getLandU().toString();
      text(text1, 480, ypos + sizeY*tileHeight + 30);   
      String text2 = "Money: " + selected.getActualProfit() + 
                      "\nPollution: " + selected.getDecayPollution();
      text(text2, 480, ypos + sizeY*tileHeight + 50);
    }
  }
  
    void showFeedback() {
    stroke(255);
    fill(255);
    rect(60 - 20, ypos + sizeY*tileHeight + 10, 420, 110);
    fill(0);  //Color of text 
    textFont(messageFont);
    text(message, 60, ypos + sizeY*tileHeight + 30);   
    text(message2, 60, ypos + sizeY*tileHeight + 50);   
    text("Simple sum of all pollution: " + WS.totalPollution, 60, ypos + sizeY*tileHeight + 90);
    text("Total pollution entering river after distance decay: " + WS.totalDecayPollution, 60, ypos + sizeY*tileHeight + 110);
  }
  
  void axisLabels() {
    /* Draw axis labels. */
    textFont(axisFont);
    textAlign(CENTER, BOTTOM);
    int xcount = 0;  
    for (int x=xpos; x < sizeX*tileWidth+xpos; x+=tileWidth){
      text(xcount, x+(tileWidth/2), ypos-3);
      xcount ++;
    }
    textAlign(RIGHT,CENTER);
    int ycount = 0;
    for (int y=ypos; y < sizeY*tileHeight+ypos; y+=tileHeight){
      text(ycount, xpos-7, y+(tileHeight/2));
      ycount ++;
    }
    textAlign(LEFT);
  }
  
  void showBudget() {
    int x = xpos + sizeX*tileWidth + 40;
    int y = yposB + 430;
    String bu = "Budget: ";
    fill(0);
    textAlign(LEFT, TOP);
    textFont(budgetFont);
    text(bu, x, y);
    textFont(numeralFont);
    textAlign(LEFT, TOP);
    text(intToStr(WS.budget), x, y+36);
  }
  
  void showActualProfits() {
    int x = xpos + sizeX*tileWidth + 40;
    int y = yposB + 520;
    fill(0);
    textFont(budgetFont);
    text("Money: ", x, y);
    textFont(numeralFont);
    text(intToStr(round(WS.totalActualProfits)), x, y+36);
  }
  
  void showPollutionSlider() {
    color green = #4BDE4A;
    color red = #FF3300;
    color extreme = #A72200;
    int x =  xpos + sizeX*tileWidth + 40;     //xposition of the slider
    int y = yposB + 270;       //yposition of the slider
    int w = 200;    //width of slider
    int h = 25;  //height if slider
    colorMode(HSB);
    
    //Draws the Slidier
    for (float i = x; i <= x+w-w*0.25; i++) {     //Green to red portion
      float inter = map(i, x, x+w-w*0.25, 0, 1);
      color c = lerpColor(green, red, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
    for (float i = x+w-w*0.25; i <= x+w; i++) {       //Red to extreme portion
      float inter = map(i, x+w-w*0.25, x+w, 0, 1);
      color c = lerpColor(red, extreme, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
    stroke(255);
    noFill();
    rect(x-1, y-1, w+2, h+2);
    
    //Draws the needle
    stroke(50);
    strokeWeight(4);
    float scaleC = 1.5;    //Scaling constant that scales decayPollution number to pixel coordinates of slider
    float sliderX = x;    //xposition of the slider in pixels;
    if (WS.totalDecayPollution <= 0.) {
      sliderX = x;
    }else if (sliderX + scaleC*WS.totalDecayPollution >= x+w) {
      sliderX = x+w;
    }else {
      sliderX = sliderX + scaleC*WS.totalDecayPollution;
    } 
    line(sliderX, y-5, sliderX, y+h+5);
    
    //Gives a text indicator:
    String pLevel;
    if (sliderX - x < w*0.2) {
      pLevel = "Healthy";
    } else if (sliderX - x < w*0.34){
      pLevel = "Okay";
    } else if (sliderX -x < w*0.55) {
      pLevel = "Moderate";
    } else if (sliderX-x < w*0.72) {
      pLevel = "Unhealthy";
    } else if (sliderX-x < w*0.89) {
      pLevel = "Severe"; 
    } else if (sliderX-x < w){
      pLevel = "Extreme" ;
    } else {
      pLevel = "Off the scale";
    }
    textFont(messageFont);
    fill(0);
    text("Pollution indicator: " + pLevel, x, y+60);
  }

  

 //**** Some helper displays and functions  ****//  -----------------------------------------------
 void showPollution() {
   for (Tile[] tileRow : WS.gameMap) {
      for (Tile t: tileRow) {
        textSize(10);
        textAlign(LEFT, TOP);
        text(round(t.getPollution()), t.getX()*tileWidth + xpos+2, t.getY()*tileHeight + ypos+1);
      }
   }
 }
 
 void showDecayPollution() {
   for (Tile[] tileRow : WS.gameMap) {
      for (Tile t: tileRow) {
        textSize(10);
        textAlign(LEFT, TOP);
        text(round(t.getDecayPollution()), t.getX()*tileWidth + xpos+2, t.getY()*tileHeight + ypos+1);
      }
   }
 }
 
 void showDist() {
   for (Tile[] tileRow : WS.gameMap) {
      for (Tile t: tileRow) {
        textSize(10);
        textAlign(LEFT, TOP);
        text(round(t.getDistToRiver()), t.getX()*tileWidth + xpos+2, t.getY()*tileHeight + ypos+1);
      }
   }
 }
 
  String intToStr(int n) {
    /* Returns a String representation of the int */
    String out = "";
    while(n > 999){
      String s = Integer.toString(n);
      out = "," + s.substring(s.length()-3) + out;
      n = n/1000;
    }
    String s = Integer.toString(n);
    out = s + out;
    return out;
  }
}
 

//**** Buttons and mouse interaction  ****//  -----------------------------------------------

Button factoryB;
Button farmB;
Button houseB;
Button forestB;
Button demolishB;
Button resetB;

Tile selected = null;
Button pushed = null;   //The current button that is pushed. null if none is pushed.

String message = "";
String message2 = "";
int mousePX;    // Mouse press positions
int mousePY;
int mouseRX;   //Mouse release positions
int mouseRY;
int mouseCX = mouseX;     //Current mouse positions
int mouseCY = mouseY;

void mousePressed() {  
  if (factoryB.over) {      //When factory button is clicked on
    if (pushed == factoryB) {
        message = "";
        pushed = null;
      } else {
    pushed = factoryB;
    message = "Add factory mode is selected";
    message2 = "";
      }
  }
  else if (farmB.over) {      //When farm button is clicked on
    if (pushed == farmB) {
        message = "";
        pushed = null;
      }else {
    pushed = farmB;
    message = "Add farm mode is selected";
    message2 = "";
      }
  }
  else if (houseB.over) {      //When house button is clicked on
    if (pushed == houseB) {
        message = "";
        pushed = null;
      } else {
    pushed = houseB;
    message = "Add house mode is selected";
    message2 = "";
      }
  }
  else if (forestB.over) {      //When forest button is clicked on
    if (pushed == forestB) {
        message = "";
        pushed = null;
      }else {
    pushed = forestB;
    message = "Add forest mode is selected";
    message2 = "";
      }
  }
  else if(demolishB.over) {   //When demolish button is clicked on
    if (pushed == demolishB) {
        message = "";
        pushed = null;
      } else {
    pushed = demolishB;
    message = "Demolish mode is selected";
    message2 = "";
      }
  }
  else if(resetB.over) {  //When reset button is clicked on
    if (pushed == resetB) {
      message = "Restarting game";
      message2 = "";
      WS = new Watershed(sizeX, sizeY);
      pushed = null;
      selected = null;
      message = "Game is reset";
      message2 = "";
    } else {
      pushed = resetB;
      message = "Do you want to reset the game? Click button again to reset.";
      message2 = "Click anywhere to cancel.";
    }
  }
  else if (mouseOverMap()){     //When mouse clicked on tile
    mousePX = mouseX;
    mousePY = mouseY;
    if (pushed == resetB) {
      message2 = "";
      message = "";
      pushed = null;
    }
  }
  else {
    if (pushed == resetB) {
      message2 = "";
    }
    pushed = null;
    message = "";
  }
  if (! mouseOverMap()) selected = null;    //Unselect when I click outside map
}

void mouseReleased() {
  if (mouseOverMap() && mouseButton == LEFT){    //Left mouse button to add
    mouseRX = mouseX;
    mouseRY = mouseY;
    int[] posP = converter(mousePX, mousePY);
    int[] posR = converter(mouseRX, mouseRY);
    selected = WS.gameMap[posR[0]][posR[1]];
    int count = 0;
    String thing = "";
    boolean s = false;
    for (int x = min(posP[0], posR[0]); x <= max(posP[0], posR[0]); x++) {
      for (int y = min(posP[1], posR[1]); y <= max(posP[1], posR[1]); y++) {
        if (pushed == factoryB) {        //If factory button is in pressed state
          s = WS.addFactory(x, y);      //count++ only when true
          if (s) count ++;
          thing = "Factories";
        } 
        else if (pushed == farmB) {        //If farm button is in pressed state
          s = WS.addFarm(x, y);
          if (s) count ++;
          thing = "Farms";
        }
        else if (pushed == houseB) {        //If house button is in pressed state
          s = WS.addHouse(x, y);
          if (s) count ++;
          thing = "Houses";
        }
        else if (pushed == forestB) {        //If forest button is in pressed state
          s = WS.addForest(x, y);
          if (s) count ++;
          thing = "Forests";
        }
        else if(pushed == demolishB) {    //If demolish button is in pressed state
          s = WS.removeLandUse(x,y);
          if (s) count ++;
        }
      }
    }
    if (pushed == null) {
      selected = WS.gameMap[posR[0]][posR[1]];     //Select tile if no button is pushed and clicked inside map
    } 
    if (pushed != null) selected = null;     //Remove selection when building things
    
    if (count > 1 || (count == 1 && s == false)) {  //Different message if multiple objects 
      message2 = "Added " + Integer.toString(count) + " " + thing;    
      if (pushed == demolishB) message2 = "Removed land use at " + Integer.toString(count) + " locations";
    }    
  }
  if (mouseButton == RIGHT) {    //Right mouse button to cancel selection and button pushed
    message = "";
    pushed = null;
    selected = null;
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
  int x, y;                 // The x- and y-coordinates of the Button in pixels
  int bWidth;                 // Dimensions in pixels
  int bHeight;
  color baseColor;           // Default color value 
  color overColor;           //Color when mouse over button
  color selectedColor;        //Color when button is selected
  String label;
  PFont baseFont = createFont("Arial", 16);
  PFont selectedFont = createFont("Arial-Black", 16);
  
  boolean over = false;     //true if mouse is over button
  
  Button(int xp, int yp, int w, int h, color c, color o, color s, String l) {
    x = xp;
    y = yp;
    bWidth = w+5;
    bHeight = h+5;
    baseColor = c;          //Default color
    overColor = o;           //Color when mouse over button
    selectedColor = s; 
    label = l;            //Color when button is in pushed state
  }
  
  void display() {
    stroke(255);
    strokeWeight(2);
    fill(255);  //Color of text label
    textAlign(LEFT,CENTER);
    if (pushed == this) { 
      textFont(selectedFont);
      text(label, x+bWidth+8, y+(bHeight/2.)-3);
      fill(selectedColor);
    }else if (over) {
      textFont(baseFont);
      text(label, x+bWidth+5, y+(bHeight/2.)-1);
      fill(overColor);
    }else {
      textFont(baseFont);
      text(label, x+bWidth+5, y+(bHeight/2.)-1);
      fill(baseColor);
    }
    rect(x, y, bWidth, bHeight);
    update();
  }  
  
  // Updates the over field every frame
  void update() {
    if ((mouseX >= x-1) && (mouseX <= x+bWidth+textWidth(label)+1) && 
        (mouseY >= y-1) && (mouseY <= y+bHeight+1)) {
      over = true;
    } else {
      over = false;
    }
  }
}