final int xpos = 40;   //xpos and ypos determines the position of the top left corner of the map, in pixels
final int ypos = 40;
final int tileWidth = 30;   //width of a tile in pixels
final int tileHeight = 30;    //height of a tile in pixels
final int xposB = xpos + sizeX*tileWidth + 40;    //Drawing dimensions. xpos and ypos are the coordinates of the top most button. 
final int yposB = 90;    //All buttons scale with respect to these

Button factoryB;
Button farmB;
Button houseB;
Button forestB;
Button demolishB;
Button resetB;

Toggle showPolT;
Toggle showDecayPolT;
Toggle showDistT;
Toggle showProfitT;


class GUI {
  final PFont axisFont = createFont("Calibri", 12);
  final PFont messageFont = createFont("Calibri", 13);
  final PFont budgetFont = createFont("Calibri-Bold", 20);
  final PFont numeralFont = createFont("Courier", 30);
  
  GUI(int x, int y) {
    factoryB = new Button(xposB, yposB, tileWidth, tileHeight, factoryBrown, #73A29C, #EA7E2F, "Factory");
    farmB = new Button(xposB, yposB + 60, tileWidth, tileHeight, farmYellow, #73A29C, #F0AD1D, "Farm");
    houseB = new Button(xposB, yposB + 120, tileWidth, tileHeight, houseTurquoise, #73A29C, #90B3B4, "House");
    forestB = new Button(xposB, yposB + 180, tileWidth, tileHeight, forestGreen, #73A29C, #02A002, "Forest");
    demolishB = new Button(xposB, yposB + 240, tileWidth, tileHeight, demolishBeige, #73A29C, #F5BB74, "Demolish");
    resetB = new Button(xposB+20, ypos+tileHeight*sizeY+40, tileWidth + 5, tileHeight + 5, #FFFFFF, #989795, #171717, "RESET MAP");
    
    showPolT = new Toggle(xposB+260, yposB+690, "Show Pollution");
    showDecayPolT = new Toggle(xposB+260, yposB+750, "Show decayPollution");
    showDistT = new Toggle(xposB+260, yposB+810, "Show distToRiver");
    showProfitT = new Toggle(xposB+260, yposB+870, "Show Money");

    factoryS = new Slider(xposB+260, yposB, 0, 20, factoryPollution, "Factory", factoryBrown);
    farmS = new Slider(xposB+260, yposB + 60, 0, 20, farmPollution, "Farm", farmYellow);
    houseS = new Slider(xposB+260, yposB + 120, 0, 20, housePollution, "House", houseTurquoise);
    forestS = new Slider(xposB+260, yposB + 180, -10, 10, forestPollution, "Forest", forestGreen);
    
    fa = new Factory();     //T his would be resolved bty making calcActualProfit() static, but that will mess up Tile.changeLandU()
    fm = new Farm();
    hs = new House();
    fo = new Forest();
  }
  
  void render() {
    /* Draws all the graphics elements of each frame */    
    drawGameBoard();
    axisLabels();
    showSelectedTile();     //For unknown reasons, this MUST be called before the two highlight functions or they all break
    highlightSingle();
    highlightBulk();
    
    showFeedback();
    showActualProfits();
    showScore();
    showBuildQuota();
    showPollutionSlider();
    
    showToggleInfo();    
    
    showPolT.display();
    showDecayPolT.display();
    showDistT.display();
    showProfitT.display();
    
    factoryB.display();
    farmB.display();
    houseB.display();
    forestB.display();
    demolishB.display();
    resetB.display();
    
    factoryS.display();
    farmS.display();
    houseS.display();
    forestS.display();
  }
  
  
  //**** Draws elements of the game map  ****//  -----------------------------------------------
  void drawTile(int x, int y, color c, int t) {
    /* Draws a tile at Location <x, y> on game map, fill color c, transparency t */
    stroke(240);
    strokeWeight(0.5);
    fill(c, t);
    rect(x*tileWidth + xpos, y*tileHeight + ypos, tileWidth, tileHeight);
    fill(255);    //resets to white.
  } 
  
  void drawGameBoard(){
    /* Draws the game board */
    for (Tile[] tileRow : WS.gameMap) {
      for (Tile t: tileRow) {
        drawTile(t.getX(), t.getY(), t.getLandUse().getIcon(), 255);
      }
    }
  }
  
  void axisLabels() {
    /* Draws axis labels. */
    textFont(axisFont);
    textAlign(CENTER, BOTTOM);
    fill(255);
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
    
   Factory fa;     //This would be resolved bty making calcActualProfit() static, but that will mess up Tile.changeLandU()
   Farm fm;
   House hs;
   Forest fo;
  
  void showSelectedTile() {    
    /* Accents the selected tile, displays tile information */
    //Draws the box
    stroke(255);
    fill(255);
    rect(xpos+450, ypos + sizeY*tileHeight + 10, 190, 110);
    
    //Displays info
    if (selected != null) {
      drawTile(selected.getX(), selected.getY(), 255, 130);
      noFill();
      strokeWeight(1.5);
      stroke(245);
      rect(selected.getX()*tileWidth + xpos, selected.getY()*tileHeight + ypos, tileWidth, tileHeight);
      fill(0);  //Color of text 
      textFont(messageFont);
      String text1 = selected.toString() + 
                    "     Type: " + selected.getLandUse().toString();
      text(text1, xpos+460, ypos + sizeY*tileHeight + 30);   
      String text2 = "Money: " + nfc(selected.getActualProfit(),2) + 
                      "\nPollution: " + nfc(selected.getDecayPollution(),2) + 
                      "\nDistToRiver: " + nfc(selected.getDistToRiver(),2);
      text(text2, xpos+460, ypos + sizeY*tileHeight + 50);
    }
  }
  
  void highlightSingle() {
    /* Accents the Tile mouse is over, displays purchase information if in purchase mode */
    Tile over = null;   //The Tile mouse is over
    String purchaseInfo = "";
    String pollutionInfo = "";
    float projectedProfit = 0;
    float projectedPollution = 0;
    if (mouseOverMap() && !mousePressed) {   //Highlight tile mouse is over
      int[] pos = converter(mouseX, mouseY);
      color hc;
      over = WS.gameMap[pos[0]][pos[1]];
        if (!(over.getLandUse() instanceof River)) {
           float d = over.getDistToRiver();
          if (pushed == factoryB) {
            hc = fa.getIcon();
            projectedProfit = fa.calcActualProfit(d);
            projectedPollution = calcDecayPollution(fa.s.getVal(), d);
            purchaseInfo = "Money: + $" + nfc(projectedProfit,2);
            pollutionInfo = "Pollution: + " + nfc(projectedPollution,2);
          }
          else if (pushed == farmB) {
            hc = fm.getIcon();
            projectedProfit = fm.calcActualProfit(d);
            projectedPollution = calcDecayPollution(fm.s.getVal(), d);
            purchaseInfo = "Money: + $" + nfc(projectedProfit,2);
            pollutionInfo = "Pollution: + " + nfc(projectedPollution,2);
          }
          else if (pushed == houseB) {
            hc = hs.getIcon();
            projectedProfit = hs.calcActualProfit(d);
            projectedPollution = calcDecayPollution(hs.s.getVal(), d);
            purchaseInfo = "Money: + $" + nfc(projectedProfit,2);
            pollutionInfo = "Pollution: + " + nfc(projectedPollution,2);
          }
          else if (pushed == forestB) {
            hc = fo.getIcon();
            projectedProfit = fo.calcActualProfit(d);
            projectedPollution = calcDecayPollution(fo.s.getVal(), d);
            purchaseInfo = "Money: - $" + nfc(abs(projectedProfit),2);
            pollutionInfo = "Pollution: - " + nfc(abs(projectedPollution),2);
          } else {                //Button not pressed
            hc = #B6FAB1;
            purchaseInfo = "";   
            pollutionInfo = "";
          }
        }else {    //Over the river
          hc = #B6FAB1;
          purchaseInfo = ""; 
          pollutionInfo = "";
        }
    drawTile(pos[0], pos[1], hc , 100);
    }
    textFont(messageFont);
    fill(125);
    text(purchaseInfo, xpos+460, ypos + sizeY*tileHeight + 90);  
    text(pollutionInfo, xpos+460, ypos + sizeY*tileHeight + 110);
  }
  
  void highlightBulk() {
    /* Highlights tiles during click and drag, and shows bulk purchase info */
    if (mousePressed && mouseOverMap()) {
      int[] posP = converter(mousePX, mousePY);   //tile coordinate when mouse is pressed
      int[] posC = converter(mouseX, mouseY);     //current tile coordinate
      ArrayList<int[]> highlighted = new ArrayList<int[]>();
      if ((posP[0] >= 0 && posP[0] <sizeX) && (posP[1] >= 0 && posP[1] < sizeY)) {
        for (int x = min(posP[0], posC[0]); x <= max(posP[0], posC[0]); x++) {
          for (int y = min(posP[1], posC[1]); y <= max(posP[1], posC[1]); y++) {
            highlighted.add(new int[] {x, y});
          }
        }
      }
      String purchaseInfo = "";
      String pollutionInfo = "";
      float projectedProfit = 0;
      float projectedPollution = 0;
      color hc;       //Highlight color
      projectedProfit = 0;     //calculate purchase info
      projectedPollution = 0;
      for (int[] p : highlighted) {
        Tile t = WS.gameMap[p[0]][p[1]];
        float d = t.getDistToRiver();
        if (! (t.getLandUse() instanceof River)) {
          if  (pushed == factoryB) {    
            hc = factoryBrown;      //highlight color
            projectedProfit += fa.calcActualProfit(d);  
            projectedPollution += calcDecayPollution(fa.s.getVal(), d);
          } 
          else if (pushed == farmB) {
            hc = farmYellow;
            projectedProfit += fm.calcActualProfit(d);
            projectedPollution += calcDecayPollution(fm.s.getVal(), d);
          }
          else if (pushed == houseB) {
            hc = houseTurquoise;
            projectedProfit += hs.calcActualProfit(d);
            projectedPollution += calcDecayPollution(hs.s.getVal(), d);
          }
          else if (pushed == forestB) {
            hc = #1EC610;
            projectedProfit += fo.calcActualProfit(d);
            projectedPollution += calcDecayPollution(fo.s.getVal(), d);
          }
          else if (pushed == demolishB){
            hc = demolishBeige;
            purchaseInfo = "";   
            pollutionInfo = "";
          }
          else {
            hc = #B6FAB1;
            purchaseInfo = "";   //No button is pushed
            pollutionInfo = "";
          }
        }else {
          hc = #B6FAB1;
          projectedProfit += 0;
          projectedPollution += 0;
        }
        drawTile(p[0], p[1], hc, 100);    //draws highlighted tile
      }
      if (pushed != null && pushed != demolishB) {
        if (projectedProfit > 0) purchaseInfo = "Money: + $" + nfc(projectedProfit,2);
        else purchaseInfo = "Money: - $" + nfc(abs(projectedProfit),2);
        if (projectedPollution > 0)pollutionInfo = "Pollution: + " + nfc(projectedPollution,2);
        else pollutionInfo = "Pollution: - " + nfc(abs(projectedPollution),2);
        textFont(messageFont);
        fill(125);
        text(purchaseInfo, xpos+460, ypos + sizeY*tileHeight + 90);  
        text(pollutionInfo, xpos+460, ypos + sizeY*tileHeight + 110); 
      }
    }
  }
  
   void showFeedback() {
     /*Draws the feedback box and shows info */
    stroke(255);
    fill(255);
    rect(xpos, ypos + sizeY*tileHeight + 10, 430, 110);
    fill(0);  //Color of text 
    textFont(messageFont);
    text(message, xpos + 20, ypos + sizeY*tileHeight + 30);   
    text(message2, xpos + 20, ypos + sizeY*tileHeight + 50);   
    text("Simple sum of all pollution: " + WS.totalPollution, xpos + 20, ypos + sizeY*tileHeight + 90);
    text("Total pollution entering river after distance decay: " + nfc(WS.totalDecayPollution,2), xpos + 20, ypos + sizeY*tileHeight + 110);
  }
  
  void showActualProfits() {
    /* Displays the money */
    int x = xpos + sizeX*tileWidth + 40;
    int y = yposB + 460;
    fill(0);
    textFont(budgetFont);
    text("Money: ", x, y);
    textFont(numeralFont);
    text(nfc(WS.totalActualProfits,2), x, y+36);
  }
  
  void showScore() {
    /* Displays the score */
    int x = xpos + sizeX*tileWidth + 40;
    int y = yposB + 550;
    fill(0);
    textFont(budgetFont);
    text("Score: ", x, y);
    textFont(numeralFont);
    text(nfc(WS.score,2), x, y+36);
  }
  
  void showBuildQuota() {
    /* Displays the build quota */
    int x = xpos + sizeX*tileWidth + 40;
    int y = yposB + 690;
    fill(0);
    textFont(messageFont);
    textSize(15);
    text("Factories: " + WS.factories + " / " + factoryQuota, x,y);
    text("Farms: " + WS.farms + " / " + farmQuota, x,y+30);
    text("Houses: " + WS.houses + " / " + houseQuota, x,y+60);
  }
  
  void showPollutionSlider() {
    /* Displays the pollution slider and indicator */
    color green = #4BDE4A;
    color red = #FF3300;
    color extreme = #A72200;
    int x =  xpos + sizeX*tileWidth + 40;     //xposition of the slider
    int y = yposB + 340;       //yposition of the slider
    int w = 220;    //width of slider
    int h = 33;  //height if slider
    colorMode(HSB);
    
    //Draws the Slidier
    strokeWeight(1);
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
    sliderX = constrain(sliderX + scaleC*WS.totalDecayPollution, x, x+w);
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
    textSize(15);
    fill(0);
    text("Pollution indicator: " + pLevel, x, y+65);
  }

 //**** Some helper displays ****//  -----------------------------------------------
 void showToggleInfo() {
   if (toggled == showPolT) {
     showPollution();
   } else if (toggled == showDecayPolT) {
     showDecayPollution();
   } else if (toggled == showDistT) {
     showDist();
   }else if (toggled == showProfitT) {
     showProfit();
   }
 }
 
 void showPollution() {
   for (Tile[] tileRow : WS.gameMap) {
      for (Tile t: tileRow) {
        textFont(messageFont);
        textSize(10);
        fill(0);
        textAlign(LEFT, TOP);
        if(t.getTilePollution()!=0) text(round(t.getTilePollution()), t.getX()*tileWidth + xpos+2, t.getY()*tileHeight + ypos+1);
      }
   }
 }
 
 void showDecayPollution() {
   float total = 0.;
   for (Tile[] tileRow : WS.gameMap) {
      for (Tile t: tileRow) {
        textFont(messageFont);
        textSize(10);
        fill(0);
        textAlign(LEFT, TOP);
        if(t.getTilePollution()!=0) text(nfc(t.getDecayPollution(),1), t.getX()*tileWidth + xpos+2, t.getY()*tileHeight + ypos+1);
        total += t.getDecayPollution();
      }
   }
   text("Decay Pollution total " + total, 1300, 10);
 }
 
 void showDist() {
   for (Tile[] tileRow : WS.gameMap) {
      for (Tile t: tileRow) {
        textFont(messageFont);
        textSize(10);
        fill(0);
        textAlign(LEFT, TOP);
        if (!(t.getLandUse() instanceof River)) text(nfc(t.getDistToRiver(),1), t.getX()*tileWidth + xpos+2, t.getY()*tileHeight + ypos+1);
      }
   }
 }
 
 void showProfit() {
   for (Tile[] tileRow : WS.gameMap) {
      for (Tile t: tileRow) {
        textFont(messageFont);
        textSize(10);
        fill(0);
        textAlign(LEFT, TOP);
        if (round(t.getActualProfit())!=0) text(nfc(t.getActualProfit(),1), t.getX()*tileWidth + xpos+2, t.getY()*tileHeight + ypos+1);
      }
   }
 }
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
      stroke(135);
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
    if ((mouseX >= x-1) && (mouseX <= x+bWidth+textWidth(label)+8) && 
        (mouseY >= y-1) && (mouseY <= y+bHeight+1)) {
      over = true;
    } else {
      over = false;
    }
  }
} 


class Toggle {
  int x, y;                 // The x- and y-coordinates of the Button in pixels
  int tWidth;                 // Dimensions in pixels
  int tHeight;
  color baseColor;           // Default color value 
  color overColor;           //Color when mouse over button
  color selectedColor;        //Color when button is selected
  String label;
  PFont baseFont = createFont("Arial", 14);
  
  boolean over = false;     //true if mouse is over button
  
  Toggle(int xp, int yp, String l) {
    x = xp;
    y = yp;
    tWidth = 15;
    tHeight = 15;
    baseColor = 255;          //Default color
    overColor = 204;           //Color when mouse over button
    selectedColor = 0; 
    label = l;            //Color when button is in pushed state
  }
  
  void display() {
    ellipseMode(CORNER);
    stroke(255);
    strokeWeight(2);
    textFont(baseFont);
    fill(255);  //Color of text label
    textAlign(LEFT,CENTER);
    if (toggled == this) { 
      text(label, x+tWidth+5, y+(tHeight/2.)-1);
      fill(selectedColor);
    }else if (over) {
      text(label, x+tWidth+5, y+(tHeight/2.)-1);
      fill(overColor);
    }else {
      text(label, x+tWidth+5, y+(tHeight/2.)-1);
      fill(baseColor);
    }
    ellipse(x, y, tWidth, tHeight);
    update();
  }  
  
  // Updates the over field every frame
  boolean overEvent() {
    if (mouseX > x-3 && mouseX < x+tWidth+textWidth(label)+9 &&
       mouseY > y-5 && mouseY < y+tHeight+5) {
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
  }
}


 

//**** MOUSE INTERACTION  ****//  -----------------------------------------------
Tile selected = null;    //The current Tile that is selected. null if no Tile selected
Button pushed = null;   //The current button that is pushed. null if none is pushed.
Toggle toggled = null;   //The current toggle. null if none toggled

String message = "";
String message2 = "";
int mousePX;    // Mouse press positions
int mousePY;
int mouseRX;   //Mouse release positions
int mouseRY;

boolean mouseOverMap(){
  /* Helper function: Returns true if the mouse position is over the Watershed map. false otherwise. */
  int[] xRange = {xpos, xpos + sizeX*tileWidth};
  int[] yRange = {ypos, ypos + sizeY*tileHeight};
  return ((mouseX > xRange[0] && mouseX < xRange[1]) && (mouseY > yRange[0] && mouseY < yRange[1]));
}

int[] converter(int xraw, int yraw) {
  /*Helper function: converts raw coordinates x and y in frame to tile locations   */
  if (mouseOverMap()){
    int xloc = 0;
    int yloc = 0;
    xloc = (xraw-xpos)/tileWidth;
    yloc = (yraw-ypos)/tileHeight;
    int[] out = {xloc, yloc};
    return out;
  } else return new int[] {0,0};
}


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
      message = "Do you want to reset the map? Click button again to reset.";
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
  if (! mouseOverMap() && !factoryS.over && !farmS.over && !houseS.over && !forestS.over && !showPolT.over && !showDecayPolT.over && !showDistT.over && !showProfitT.over) selected = null;    //Unselect when I click outside map
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

void mouseClicked() {
  if (showPolT.over) {
    if (toggled == showPolT) toggled = null;
    else toggled = showPolT;
  }else if (showDecayPolT.over) {
    if (toggled == showDecayPolT) toggled = null;
    else toggled = showDecayPolT;
  }else if (showDistT.over) {
    if (toggled == showDistT) toggled = null;
    else toggled = showDistT;
  }else if (showProfitT.over) {
    if (toggled == showProfitT) toggled = null;
    else toggled = showProfitT;
  }
}