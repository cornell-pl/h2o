final int XPOS = 40;   //XPOS and ypos determines the position of the top left corner of the map, in pixels
final int YPOS = 30;
final int TILE_WIDTH = 26;   //width of a tile in pixels
final int TILE_HEIGHT = 26;    //height of a tile in pixels
final int XPOSB = XPOS + SIZE_X*TILE_WIDTH + 40;    //Drawing dimensions. XPOS and ypos are the coordinates of the top most button. 
final int YPOSB = 60;    //All buttons scale with respect to these


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
  
  ButtonPanel BPanel;
  
  Watershed waterS;
  
  GUI(int x, int y, Watershed ws) {
    BPanel = new ButtonPanel(XPOSB, YPOSB, TILE_WIDTH+5, TILE_HEIGHT+5, 30);
    waterS = ws;
    
    showPolT = new Toggle(XPOSB+180, YPOSB+450, "Show Pollution");
    showDecayPolT = new Toggle(XPOSB+180, YPOSB+500, "Show decayPollution");
    showDistT = new Toggle(XPOSB+180, YPOSB+550, "Show distToRiver");
    showProfitT = new Toggle(XPOSB+180, YPOSB+600, "Show Money");
    sliderT = new Toggle(XPOSB+160, YPOSB+240, "Show sliders");

    factoryS = new Slider(FACTORY, XPOSB+140, YPOSB, 0, 20, FACTORY_BROWN);
    farmS = new Slider(FARM, XPOSB+140, YPOSB + 60, 0, 20, FARM_YELLOW);
    houseS = new Slider(HOUSE, XPOSB+140, YPOSB + 120, 0, 20, HOUSE_GRAY);
    forestS = new Slider(FOREST, XPOSB+140, YPOSB + 180, -10, 10, FOREST_GREEN);
  }
  
  void render() {
    /* Draws all the graphics elements of each frame */   
    BPanel.display();
    
    drawDividers();
    drawGameBoard();
    axisLabels();
    showSelectedTile();
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
    
    if (showSlider == true) {
      factoryS.display();
      farmS.display();
      houseS.display();
      forestS.display();
    }
  }
  
  
  //**** Draws elements of the game map  ****//  -----------------------------------------------
  void drawDividers(){ 
    noFill();
    stroke(204);
    strokeWeight(1);
    rect(XPOSB-20, YPOS, 392, TILE_HEIGHT*SIZE_Y);
    line(XPOSB-20, YPOSB+TILE_HEIGHT+5+270, XPOSB-20+392, YPOSB+TILE_HEIGHT+5+270);
  }
    
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
    for (Tile t: waterS.getAllTiles()) 
      drawTile(t.getX(), t.getY(), t.getLandUse().getIcon(), 255);
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
                      "\nDistToRiver: " + nfc(selected.distToRiver(),2);
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
      over = waterS.getTile(pos[0], pos[1]);
        if (!(over.isRiver())) {
           float d = over.distToRiver();
          if (pushed == factoryB) {
            hc = FACTORY.getIcon();
            projectedProfit = FACTORY.calcActualProfit(d);
            projectedPollution = FACTORY.calcDecayPollution(d);        
            purchaseInfo = "Money: + $" + nfc(round(projectedProfit));
            pollutionInfo = "Pollution: + " + nfc(projectedPollution,2);
          }
          else if (pushed == farmB) {
            hc = FARM.getIcon();
            projectedProfit = FARM.calcActualProfit(d);
            projectedPollution = FARM.calcDecayPollution(d);
            purchaseInfo = "Money: + $" + nfc(round(projectedProfit));
            pollutionInfo = "Pollution: + " + nfc(projectedPollution,2);
          }
          else if (pushed == houseB) {
            hc = HOUSE.getIcon();
            projectedProfit = HOUSE.calcActualProfit(d);
            projectedPollution = HOUSE.calcDecayPollution(d);
            purchaseInfo = "Money: + $" + nfc(round(projectedProfit));
            pollutionInfo = "Pollution: + " + nfc(projectedPollution,2);
          }
          else if (pushed == forestB) {
            hc = FOREST.getIcon();
            projectedProfit = FOREST.calcActualProfit(d);
            projectedPollution = FOREST.calcDecayPollution(d);
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
        Tile t = waterS.getTile(p[0], p[1]);
        float d = t.distToRiver();
        if (! (t.getLandUse() instanceof River)) {
          if  (pushed == factoryB) {    
            hc = FACTORY_BROWN;      //highlight color
            projectedProfit += FACTORY.calcActualProfit(d);  
            projectedPollution += FACTORY.calcDecayPollution(d);
          } 
          else if (pushed == farmB) {
            hc = FARM_YELLOW;
            projectedProfit += FARM.calcActualProfit(d);
            projectedPollution += FARM.calcDecayPollution( d);
          }
          else if (pushed == houseB) {
            hc = HOUSE_GRAY;
            projectedProfit += HOUSE.calcActualProfit(d);
            projectedPollution += HOUSE.calcDecayPollution(d);
          }
          else if (pushed == forestB) {
            hc = #1EC610;
            projectedProfit += FOREST.calcActualProfit(d);
            projectedPollution += FOREST.calcDecayPollution(d);
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
    text("Simple sum of all pollution: " + waterS.sumTotalPollution(), XPOS + 20, YPOS + SIZE_Y*TILE_HEIGHT + 90);
    text("Total pollution entering river after distance decay: " + nfc(waterS.sumDecayPollution(),2), XPOS + 20, YPOS + SIZE_Y*TILE_HEIGHT + 110);
  }
  
  void showActualProfits() {
    /* Displays the money */
    int x = XPOS + SIZE_X*TILE_WIDTH + 40;
    int y = YPOSB + 460;
    fill(0);
    textFont(BIGFONT);
    text("Money: ", x, y);
    textFont(NUMERALFONT);
    text("$"+nfc(round(waterS.sumActualProfits())), x, y+36);
  }
  
  void showScore() {
    /* Displays the score */
    int x = XPOS + SIZE_X*TILE_WIDTH + 40;
    int y = YPOSB + 550;
    fill(0);
    textFont(BIGFONT);
    text("Score: ", x, y);
    textFont(NUMERALFONT);
    text(nfc(round(waterS.calcScore())), x, y+36);
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
    text("  Factories: " + waterS.countFactories() + " / " + FACTORY_QUOTA, x,y+30);
    text("  Farms: " + waterS.countFarms() + " / " + FARM_QUOTA, x,y+60);
    text("  Houses: " + waterS.countHouses() + " / " + HOUSE_QUOTA, x,y+90);
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
    sliderX = constrain(sliderX + waterS.sumDecayPollution()/scaleC, x, x+w);
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
    for (Tile t: waterS.getAllTiles()) {
      textFont(MESSAGEFONT);
      textSize(10);
      fill(0);
      textAlign(LEFT, TOP);
      int p = round(t.getBasePollution());
      if(p != 0) 
        text(p, t.getX()*TILE_WIDTH + XPOS+2, t.getY()*TILE_HEIGHT + YPOS+1);
   }
 }
 
 void showDecayPollution() {
   float total = 0.;
    for (Tile t: waterS.getAllTiles()) {
      textFont(MESSAGEFONT);
      textSize(10);
      fill(0);
      textAlign(LEFT, TOP);
      if(t.getBasePollution()!=0) 
        text(nfc(t.getDecayPollution(),1), t.getX()*TILE_WIDTH + XPOS+2, t.getY()*TILE_HEIGHT + YPOS+1);
      total += t.getDecayPollution();
   }
 }
 
 void showDist() {
    for (Tile t: waterS.getAllTiles()) {
      textFont(MESSAGEFONT);
      textSize(10);
      fill(0);
      textAlign(LEFT, TOP);
      if (!(t.getLandUse() instanceof River)) 
        text(nfc(t.distToRiver(),1), t.getX()*TILE_WIDTH + XPOS+2, t.getY()*TILE_HEIGHT + YPOS+1);
   }
 }
 
 void showProfit() {
    for (Tile t: waterS.getAllTiles()) {
      textFont(MESSAGEFONT);
      textSize(9);
      fill(0);
      textAlign(LEFT, TOP);
      if (round(t.getActualProfit())!=0) 
        text(round(t.getActualProfit()), t.getX()*TILE_WIDTH + XPOS+2, t.getY()*TILE_HEIGHT + YPOS+1);
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




 