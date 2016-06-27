final int XPOS = 40;   //XPOS and ypos determines the position of the top left corner of the map, in pixels
final int YPOS = 40;
final int TILE_WIDTH = 26;   //width of a tile in pixels
final int TILE_HEIGHT = 26;    //height of a tile in pixels
final int XPOSB = XPOS + SIZE_X*TILE_WIDTH + 40;    //Drawing dimensions. XPOS and ypos are the coordinates of the top most button. 
final int YPOSB = 90;    //All buttons scale with respect to these

final Factory FA = new Factory();     //a bunch of land types to retrieve their fields in GUI
final Farm FM = new Farm();
final House HS = new House();
final Forest FO = new Forest();

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
Toggle sliderT;

Slider factoryS;
Slider farmS;
Slider houseS;
Slider forestS;



class GUI {
  final PFont AXISFONT = createFont("Calibri", 12);
  final PFont MESSAGEFONT = createFont("Calibri", 14);
  final PFont BIGFONT = createFont("Calibri-Bold", 20);
  final PFont NUMERALFONT = createFont("Courier", 30);
  
  GUI(int x, int y) {
    factoryB = new Button(XPOSB, YPOSB, TILE_WIDTH, TILE_HEIGHT, FACTORY_BROWN, #73A29C, #EA7E2F, "Factory");
    farmB = new Button(XPOSB, YPOSB + 60, TILE_WIDTH, TILE_HEIGHT, FARM_YELLOW, #73A29C, #F0AD1D, "Farm");
    houseB = new Button(XPOSB, YPOSB + 120, TILE_WIDTH, TILE_HEIGHT, HOUSE_GRAY, #73A29C, #90B3B4, "House");
    forestB = new Button(XPOSB, YPOSB + 180, TILE_WIDTH, TILE_HEIGHT, FOREST_GREEN, #73A29C, #02A002, "Forest");
    demolishB = new Button(XPOSB, YPOSB + 240, TILE_WIDTH, TILE_HEIGHT, DEMOLISH_BEIGE, #73A29C, #F5BB74, "Demolish");
    resetB = new Button(XPOSB+290, YPOS+TILE_HEIGHT*SIZE_Y+40, TILE_WIDTH + 5, TILE_HEIGHT + 5, #FFFFFF, #989795, #171717, "RESET MAP");
    
    showPolT = new Toggle(XPOSB+290, YPOSB+450, "Show Pollution");
    showDecayPolT = new Toggle(XPOSB+290, YPOSB+500, "Show decayPollution");
    showDistT = new Toggle(XPOSB+290, YPOSB+550, "Show distToRiver");
    showProfitT = new Toggle(XPOSB+290, YPOSB+600, "Show Money");
    sliderT = new Toggle(XPOSB+290, YPOSB+240, "Show sliders");

    factoryS = new Slider(XPOSB+260, YPOSB, 0, 20, getPollution(FA), "Factory", FACTORY_BROWN);
    farmS = new Slider(XPOSB+260, YPOSB + 60, 0, 20, getPollution(FM), "Farm", FARM_YELLOW);
    houseS = new Slider(XPOSB+260, YPOSB + 120, 0, 20, getPollution(HS), "House", HOUSE_GRAY);
    forestS = new Slider(XPOSB+260, YPOSB + 180, -10, 10, getPollution(FO), "Forest", FOREST_GREEN);
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
    sliderT.display();
    
    factoryB.display();
    farmB.display();
    houseB.display();
    forestB.display();
    demolishB.display();
    resetB.display();
    
    if (showSlider == true) {
      factoryS.display();
      farmS.display();
      houseS.display();
      forestS.display();
    }
  }
  
  
  //**** Draws elements of the game map  ****//  -----------------------------------------------
  void drawTile(int x, int y, color c, int t) {
    /* Draws a tile at Location <x, y> on game map, fill color c, transparency t */
    stroke(240);
    strokeWeight(0.5);
    fill(c, t);
    rect(x*TILE_WIDTH + XPOS, y*TILE_HEIGHT + YPOS, TILE_WIDTH, TILE_HEIGHT);
    fill(255);    //resets to white.
  } 
  
  void drawGameBoard(){
    /* Draws the game board */
    for (Tile[] tileRow : WS.GAME_MAP) {
      for (Tile t: tileRow) {
        drawTile(t.getX(), t.getY(), t.getLandUse().getIcon(), 255);
      }
    }
  }
  
  void axisLabels() {
    /* Draws axis labels. */
    textFont(AXISFONT);
    textAlign(CENTER, BOTTOM);
    fill(255);
    int xcount = 0;  
    for (int x=XPOS; x < SIZE_X*TILE_WIDTH+XPOS; x+=TILE_WIDTH){
      text(xcount, x+(TILE_WIDTH/2), YPOS-3);
      xcount ++;
    }
    textAlign(RIGHT,CENTER);
    int ycount = 0;
    for (int y=YPOS; y < SIZE_Y*TILE_HEIGHT+YPOS; y+=TILE_HEIGHT){
      text(ycount, XPOS-7, y+(TILE_HEIGHT/2));
      ycount ++;
    }
    textAlign(LEFT);
  }
    
  void showSelectedTile() {    
    /* Accents the selected tile, displays tile information */
    //Draws the box
    stroke(255);
    fill(255);
    rect(XPOS+455, YPOS + SIZE_Y*TILE_HEIGHT + 10, 200, 115);
    
    //Displays info
    if (selected != null) {
      drawTile(selected.getX(), selected.getY(), 255, 130);
      noFill();
      strokeWeight(1.5);
      stroke(245);
      rect(selected.getX()*TILE_WIDTH + XPOS, selected.getY()*TILE_HEIGHT + YPOS, TILE_WIDTH, TILE_HEIGHT);
      fill(0);  //Color of text 
      textFont(MESSAGEFONT);
      String text1 = selected.toString() + 
                    "     Type: " + selected.getLandUse().toString();
      text(text1, XPOS+470, YPOS + SIZE_Y*TILE_HEIGHT + 30);   
      String text2 = "Money: $" + round(selected.getActualProfit()) + 
                      "\ndecayPollution: " + nfc(selected.getDecayPollution(),2) + 
                      "\nDistToRiver: " + nfc(selected.getDistToRiver(),2);
      text(text2, XPOS+470, YPOS + SIZE_Y*TILE_HEIGHT + 50);
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
      over = WS.GAME_MAP[pos[0]][pos[1]];
        if (!(over.getLandUse() instanceof River)) {
           float d = over.getDistToRiver();
          if (pushed == factoryB) {
            hc = FA.getIcon();
            projectedProfit = FA.calcActualProfit(d);
            projectedPollution = calcDecayPollution(FA.getSliderPollution(), d);
            purchaseInfo = "Money: + $" + nfc(round(projectedProfit));
            pollutionInfo = "Pollution: + " + nfc(projectedPollution,2);
          }
          else if (pushed == farmB) {
            hc = FM.getIcon();
            projectedProfit = FM.calcActualProfit(d);
            projectedPollution = calcDecayPollution(FM.getSliderPollution(), d);
            purchaseInfo = "Money: + $" + nfc(round(projectedProfit));
            pollutionInfo = "Pollution: + " + nfc(projectedPollution,2);
          }
          else if (pushed == houseB) {
            hc = HS.getIcon();
            projectedProfit = HS.calcActualProfit(d);
            projectedPollution = calcDecayPollution(HS.getSliderPollution(), d);
            purchaseInfo = "Money: + $" + nfc(round(projectedProfit));
            pollutionInfo = "Pollution: + " + nfc(projectedPollution,2);
          }
          else if (pushed == forestB) {
            hc = FO.getIcon();
            projectedProfit = FO.calcActualProfit(d);
            projectedPollution = calcDecayPollution(FO.getSliderPollution(), d);
            purchaseInfo = "Money: - $" + nfc(round(projectedProfit));
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
    textFont(MESSAGEFONT);
    fill(125);
    text(purchaseInfo, XPOS+460, YPOS + SIZE_Y*TILE_HEIGHT + 90);  
    text(pollutionInfo, XPOS+460, YPOS + SIZE_Y*TILE_HEIGHT + 110);
  }
  
  void highlightBulk() {
    /* Highlights tiles during click and drag, and shows bulk purchase info */
    if (mousePressed && mouseOverMap()) {
      int[] posP = converter(mousePX, mousePY);   //tile coordinate when mouse is pressed
      int[] posC = converter(mouseX, mouseY);     //current tile coordinate
      ArrayList<int[]> highlighted = new ArrayList<int[]>();
      if ((posP[0] >= 0 && posP[0] <SIZE_X) && (posP[1] >= 0 && posP[1] < SIZE_Y)) {
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
        Tile t = WS.GAME_MAP[p[0]][p[1]];
        float d = t.getDistToRiver();
        if (! (t.getLandUse() instanceof River)) {
          if  (pushed == factoryB) {    
            hc = FACTORY_BROWN;      //highlight color
            projectedProfit += FA.calcActualProfit(d);  
            projectedPollution += calcDecayPollution(FA.getSliderPollution(), d);
          } 
          else if (pushed == farmB) {
            hc = FARM_YELLOW;
            projectedProfit += FM.calcActualProfit(d);
            projectedPollution += calcDecayPollution(FM.getSliderPollution(), d);
          }
          else if (pushed == houseB) {
            hc = HOUSE_GRAY;
            projectedProfit += HS.calcActualProfit(d);
            projectedPollution += calcDecayPollution(HS.getSliderPollution(), d);
          }
          else if (pushed == forestB) {
            hc = #1EC610;
            projectedProfit += FO.calcActualProfit(d);
            projectedPollution += calcDecayPollution(FO.getSliderPollution(), d);
          }
          else if (pushed == demolishB){
            hc = DEMOLISH_BEIGE;
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
        if (projectedProfit > 0) purchaseInfo = "Money: + $" + nfc(round(projectedProfit));
        else purchaseInfo = "Money: - $" + nfc(abs(projectedProfit),2);
        if (projectedPollution > 0)pollutionInfo = "Pollution: + " + nfc(projectedPollution,2);
        else pollutionInfo = "Pollution: - " + nfc(abs(projectedPollution),2);
        textFont(MESSAGEFONT);
        fill(125);
        text(purchaseInfo, XPOS+460, YPOS + SIZE_Y*TILE_HEIGHT + 90);  
        text(pollutionInfo, XPOS+460, YPOS + SIZE_Y*TILE_HEIGHT + 110); 
      }
    }
  }
  
   void showFeedback() {
     /*Draws the feedback box and shows info */
    stroke(255);
    fill(255);
    rect(XPOS, YPOS + SIZE_Y*TILE_HEIGHT + 10, 440, 115);
    fill(0);  //Color of text 
    textFont(MESSAGEFONT);
    text(message, XPOS + 20, YPOS + SIZE_Y*TILE_HEIGHT + 30);   
    text(message2, XPOS + 20, YPOS + SIZE_Y*TILE_HEIGHT + 50);   
    text("Simple sum of all pollution: " + WS.totalPollution, XPOS + 20, YPOS + SIZE_Y*TILE_HEIGHT + 90);
    text("Total pollution entering river after distance decay: " + nfc(WS.totalDecayPollution,2), XPOS + 20, YPOS + SIZE_Y*TILE_HEIGHT + 110);
  }
  
  void showActualProfits() {
    /* Displays the money */
    int x = XPOS + SIZE_X*TILE_WIDTH + 40;
    int y = YPOSB + 460;
    fill(0);
    textFont(BIGFONT);
    text("Money: ", x, y);
    textFont(NUMERALFONT);
    text("$"+nfc(round(WS.totalActualProfits)), x, y+36);
  }
  
  void showScore() {
    /* Displays the score */
    int x = XPOS + SIZE_X*TILE_WIDTH + 40;
    int y = YPOSB + 550;
    fill(0);
    textFont(BIGFONT);
    text("Score: ", x, y);
    textFont(NUMERALFONT);
    text(nfc(round(WS.score)), x, y+36);
  }
  
  void showBuildQuota() {
    /* Displays the build quota */
    int x = XPOS + SIZE_X*TILE_WIDTH + 40;
    int y = YPOSB + 640;
    fill(0);
    textFont(BIGFONT);
    text("Quota: ", x, y);
    textFont(MESSAGEFONT);
    textSize(16);
    text("  Factories: " + WS.factories + " / " + FACTORY_QUOTA, x,y+30);
    text("  Farms: " + WS.farms + " / " + FARM_QUOTA, x,y+60);
    text("  Houses: " + WS.houses + " / " + HOUSE_QUOTA, x,y+90);
  }
  
  void showPollutionSlider() {
    /* Displays the pollution slider and indicator */
    color green = #4BDE4A;
    color red = #FF3300;
    color extreme = #A72200;
    int x =  XPOS + SIZE_X*TILE_WIDTH + 40;     //xposition of the slider
    int y = YPOSB + 340;       //YPOSition of the slider
    int w = 220;    //width of slider
    int h = 33;  //height if slider
    int polMax = 1200;  // The maximum pollution the slider can handle
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
    float scaleC = polMax/(float)w;    //Scaling constant that scales decayPollution number to pixel coordinates of slider
    float sliderX = x;    //xposition of the slider in pixels;
    sliderX = constrain(sliderX + WS.totalDecayPollution/scaleC, x, x+w);
    line(sliderX, y-5, sliderX, y+h+5);
    
    //Gives a text indicator:
    String pLevel;
    if ((sliderX - x)*scaleC < polMax*0.2) {
      pLevel = "Healthy";
    } else if ((sliderX - x)*scaleC < polMax*0.34){
      pLevel = "Okay";
    } else if ((sliderX - x)*scaleC < polMax*0.52) {
      pLevel = "Moderate";
    } else if ((sliderX - x)*scaleC < polMax*0.70) {
      pLevel = "Unhealthy";
    } else if ((sliderX - x)*scaleC < polMax*0.89) {
      pLevel = "Severe"; 
    } else if ((sliderX - x)*scaleC < polMax){
      pLevel = "Dangerous" ;
    } else {
      pLevel = "Off the scale";
    }
    textFont(MESSAGEFONT);
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
   for (Tile[] tileRow : WS.GAME_MAP) {
      for (Tile t: tileRow) {
        textFont(MESSAGEFONT);
        textSize(10);
        fill(0);
        textAlign(LEFT, TOP);
        if(t.getTilePollution()!=0) text(round(t.getTilePollution()), t.getX()*TILE_WIDTH + XPOS+2, t.getY()*TILE_HEIGHT + YPOS+1);
      }
   }
 }
 
 void showDecayPollution() {
   float total = 0.;
   for (Tile[] tileRow : WS.GAME_MAP) {
      for (Tile t: tileRow) {
        textFont(MESSAGEFONT);
        textSize(10);
        fill(0);
        textAlign(LEFT, TOP);
        if(t.getTilePollution()!=0) text(nfc(t.getDecayPollution(),1), t.getX()*TILE_WIDTH + XPOS+2, t.getY()*TILE_HEIGHT + YPOS+1);
        total += t.getDecayPollution();
      }
   }
 }
 
 void showDist() {
   for (Tile[] tileRow : WS.GAME_MAP) {
      for (Tile t: tileRow) {
        textFont(MESSAGEFONT);
        textSize(10);
        fill(0);
        textAlign(LEFT, TOP);
        if (!(t.getLandUse() instanceof River)) text(nfc(t.getDistToRiver(),1), t.getX()*TILE_WIDTH + XPOS+2, t.getY()*TILE_HEIGHT + YPOS+1);
      }
   }
 }
 
 void showProfit() {
   for (Tile[] tileRow : WS.GAME_MAP) {
      for (Tile t: tileRow) {
        textFont(MESSAGEFONT);
        textSize(9);
        fill(0);
        textAlign(LEFT, TOP);
        if (round(t.getActualProfit())!=0) text(round(t.getActualProfit()), t.getX()*TILE_WIDTH + XPOS+2, t.getY()*TILE_HEIGHT + YPOS+1);
      }
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
  final PFont BASEFONT = createFont("Arial", 14);  
  int x, y;                 // The x- and y-coordinates of the Button in pixels
  int tWidth;                 // Dimensions in pixels
  int tHeight;
  color baseColor;           // Default color value 
  color overColor;           //Color when mouse over button
  color selectedColor;        //Color when button is selected
  String label;
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
    textFont(BASEFONT);
    fill(255);  //Color of text label
    textAlign(LEFT,CENTER);
    if ((toggled == this) || (this.label.equals("Show sliders") && showSlider == true)) { 
      text(label, x+tWidth+5, y+(tHeight/2.)-1);
      fill(selectedColor);
      if (this.label.equals("Show sliders")) fill(#B72416);
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
boolean showSlider = false;

String message = "";
String message2 = "";
int mousePX;    // Mouse press positions
int mousePY;
int mouseRX;   //Mouse release positions
int mouseRY;

boolean mouseOverMap(){
  /* Helper function: Returns true if the mouse position is over the Watershed map. false otherwise. */
  int[] xRange = {XPOS, XPOS + SIZE_X*TILE_WIDTH};
  int[] yRange = {YPOS, YPOS + SIZE_Y*TILE_HEIGHT};
  return ((mouseX > xRange[0] && mouseX < xRange[1]) && (mouseY > yRange[0] && mouseY < yRange[1]));
}

int[] converter(int xraw, int yraw) {
  /*Helper function: converts raw coordinates x and y in frame to tile locations   */
  if (mouseOverMap()){
    int xloc = 0;
    int yloc = 0;
    xloc = (xraw-XPOS)/TILE_WIDTH;
    yloc = (yraw-YPOS)/TILE_HEIGHT;
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
      WS = new Watershed(SIZE_X, SIZE_Y);
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
    selected = WS.GAME_MAP[posR[0]][posR[1]];
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
      selected = WS.GAME_MAP[posR[0]][posR[1]];     //Select tile if no button is pushed and clicked inside map
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
  else if (sliderT.over) {
    if (showSlider == true) showSlider = false;
    else showSlider = true;
  }
}