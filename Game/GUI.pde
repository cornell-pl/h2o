static final int XPOS = 40;   //XPOS and ypos determines the position of the top left corner of the map, in pixels
static final int YPOS = 30;
static final int TILE_WIDTH = 26;   //width of a tile in pixels
static final int TILE_HEIGHT = 26;    //height of a tile in pixels
static final int XPOSB = XPOS + SIZE_X*TILE_WIDTH + 40;    //Drawing dimensions. XPOS and ypos are the coordinates of the top most button. 
static final int YPOSB = 60;    //All buttons scale with respect to these
static final color DEFAULT_HIGHLIGHT = #E5FCFC;   // Default color to highllight Tiles with

class GUI {
  Watershed waterS;
  
  final PFont AXISFONT = createFont("Calibri", 12);
  final PFont MESSAGEFONT = createFont("Calibri", 14);
  final PFont BIGFONT = createFont("Calibri-Bold", 20);
  final PFont NUMERALFONT = createFont("Courier", 30);
  
  final GameBoard GAME_BOARD = new GameBoard();
  final InfoBox INFO_BOX = new InfoBox();
  final FeedbackBox FEEDBACK_BOX = new FeedbackBox();
  final Dashboard DASHBOARD = new Dashboard();
  
  final Button FACTORY_BUTTON;
  final Button FARM_BUTTON;
  final Button HOUSE_BUTTON;
  final Button FOREST_BUTTON;
  final Button DEMOLISH_BUTTON;
  final Button RESET_BUTTON;
  
  final Toggle POLLUTION_TOGGLE;
  final Toggle DECAYPOL_TOGGLE;
  final Toggle DIST_TOGGLE;
  final Toggle PROFIT_TOGGLE;
  final Toggle SLIDER_TOGGLE;
  
  final Slider FACTORY_SLIDER;
  final Slider FARM_SLIDER;
  final Slider HOUSE_SLIDER;
  final Slider FOREST_SLIDER;
  
  GUI(Watershed WS) {
    
    waterS = WS;
    FACTORY_BUTTON = new Button(XPOSB, YPOSB, TILE_WIDTH, TILE_HEIGHT, FACTORY_BROWN, #73A29C, #EA7E2F, "Factory");
    FARM_BUTTON = new Button(XPOSB, YPOSB + 60, TILE_WIDTH, TILE_HEIGHT, FARM_YELLOW, #73A29C, #F0AD1D, "Farm");
    HOUSE_BUTTON = new Button(XPOSB, YPOSB + 120, TILE_WIDTH, TILE_HEIGHT, HOUSE_GRAY, #73A29C, #90B3B4, "House");
    FOREST_BUTTON = new Button(XPOSB, YPOSB + 180, TILE_WIDTH, TILE_HEIGHT, FOREST_GREEN, #73A29C, #02A002, "Forest");
    DEMOLISH_BUTTON = new Button(XPOSB, YPOSB + 240, TILE_WIDTH, TILE_HEIGHT, DEMOLISH_BEIGE, #73A29C, #F5BB74, "Demolish");
    RESET_BUTTON = new Button(XPOSB+220, YPOS+TILE_HEIGHT*SIZE_Y-57, TILE_WIDTH + 5, TILE_HEIGHT + 5, #FFFFFF, #989795, #171717, "RESET MAP");
    
    POLLUTION_TOGGLE = new Toggle(XPOSB+180, YPOSB+450, "Show Pollution");
    DECAYPOL_TOGGLE = new Toggle(XPOSB+180, YPOSB+500, "Show decayPollution");
    DIST_TOGGLE = new Toggle(XPOSB+180, YPOSB+550, "Show distToRiver");
    PROFIT_TOGGLE = new Toggle(XPOSB+180, YPOSB+600, "Show Money");
    SLIDER_TOGGLE = new Toggle(XPOSB+160, YPOSB+240, "Show sliders");

    FACTORY_SLIDER = new Slider(FACTORY, XPOSB+140, YPOSB, 0, 20, FACTORY_BROWN);
    FARM_SLIDER = new Slider(FARM, XPOSB+140, YPOSB + 60, 0, 20, FARM_YELLOW);
    HOUSE_SLIDER = new Slider(HOUSE, XPOSB+140, YPOSB + 120, 0, 20, HOUSE_GRAY);
    FOREST_SLIDER = new Slider(FOREST, XPOSB+140, YPOSB + 180, -10, 10, FOREST_GREEN);
  }
  
  void render() {
    /* Draws all the graphics elements of each frame */   
    GAME_BOARD.display();
    INFO_BOX.display();
    FEEDBACK_BOX.display();
    DASHBOARD.display();
    
    drawDividers();
    
    POLLUTION_TOGGLE.display();
    DECAYPOL_TOGGLE.display();
    DIST_TOGGLE.display();
    PROFIT_TOGGLE.display();
    SLIDER_TOGGLE.display();
    
    FACTORY_BUTTON.display();
    FARM_BUTTON.display();
    HOUSE_BUTTON.display();
    FOREST_BUTTON.display();
    DEMOLISH_BUTTON.display();
    RESET_BUTTON.display();
    
    if (showSlider == true) {
      FACTORY_SLIDER.display();
      FARM_SLIDER.display();
      HOUSE_SLIDER.display();
      FOREST_SLIDER.display();
    }
  }

  void drawDividers(){ 
      noFill();
      stroke(204);
      strokeWeight(1);
      rect(XPOSB-20, YPOS, 392, TILE_HEIGHT*SIZE_Y);
      line(XPOSB-20, YPOSB+TILE_HEIGHT+5+270, XPOSB-20+392, YPOSB+TILE_HEIGHT+5+270);
  }
  
  class ButtonPanel {
    
  }

  class GameBoard {
    ArrayList<int[]>  highlightThese = new ArrayList<int[]>();    // A list containing all the Tiles that are to be highlighted, each element is of format {posX, posY, color}
    
    void GameBoard() {
    }
    
    void display() {
      drawGameBoard();
      drawAxisLabels();
      highlight();
      showSelectedTile();
      showToggleInfo();
    }
      
    void drawGameBoard(){
      /* Draws the game board */
      for (Tile t: waterS.getAllTiles()) 
        drawTile(t.getX(), t.getY(), t.getLandUse().getIcon(), 255);
    }
    
     void drawTile(int x, int y, color c, int t) {
      /* Draws a tile at Location <x, y> on game map, fill color c, transparency t */
      stroke(240);
      strokeWeight(0.5);
      fill(c, t);
      rect(x*TILE_WIDTH + XPOS, y*TILE_HEIGHT + YPOS, TILE_WIDTH, TILE_HEIGHT);
      fill(255);    //resets to white.
    } 
    
    void drawAxisLabels() {
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
    
    void highlight() {
      /* Hightlights Tile at position <x, y> with color hc (click and drag) */
      for (int [] e : highlightThese){
        drawTile(e[0], e[1], e[2], 100);
      }
      highlightThese = new ArrayList<int[]>();     //Clear list after highlighting all its Tiles
    }
    
    void showSelectedTile() {    
    /* Accents the selected tile */
      if (selected != null){
        drawTile(selected.getX(), selected.getY(), 255, 130);
        noFill();
        strokeWeight(1.5);
        stroke(245);
        rect(selected.getX()*TILE_WIDTH + XPOS, selected.getY()*TILE_HEIGHT + YPOS, TILE_WIDTH, TILE_HEIGHT);
      }
    }

    void highlightTile(Tile t, color hc) {
      highlightThese.add(new int[] {t.getX(), t.getY(), hc});
    }
    
    Tile[] getHighlightedTiles(){
      Tile[] tiles = new Tile[highlightThese.size()];
      int i = 0;
      for (int[] e : highlightThese){
        tiles[i] = waterS.getTile(e[0], e[1]);
        i++;
      }
    return tiles;
    }
    
    void showToggleInfo() {
      if (toggled == POLLUTION_TOGGLE) {
        showPollution();
      }else if (toggled == DECAYPOL_TOGGLE) {
        showDecayPollution();
      }else if (toggled == DIST_TOGGLE) {
        showDist();
      }else if (toggled == PROFIT_TOGGLE) {
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
  }// END OF GAMEBOARD NESTED CLASS

  class InfoBox{
    /* Draws box and displays selected Tile info and prePurchaseInfo */
    float projectedProfit = 0;
    float projectedPollution = 0;
    boolean showPrePurchase = false;
      
    void display(){
     /* Draws box and displays selected Tile info and prePurchaseInfo */
      stroke(255);
      strokeWeight(1);
      fill(255);
      rect(XPOS+455, YPOS + SIZE_Y*TILE_HEIGHT + 10, 200, 115);
      showPrePurchaseInfo();
      showTileInfo();
    }
    
    void showTileInfo() {    
      /* Displays information of selected Tile */
      if (selected != null) {
        fill(0);  //Color of text 
        textAlign(CORNER);
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

    void showPrePurchaseInfo(){
      /* Displays information about purchase when in add mode */
      if (showPrePurchase){
        String purchaseInfo = "";
        String pollutionInfo = "";
        if (pushed != DEMOLISH_BUTTON) {
          if (projectedProfit >= 0) purchaseInfo = "Money: + $" + nfc(round(projectedProfit));
          else purchaseInfo = "Money: - $" + nfc(abs(projectedProfit),2);
          if (projectedPollution >= 0)pollutionInfo = "Pollution: + " + nfc(projectedPollution,2);
          else pollutionInfo = "Pollution: - " + nfc(abs(projectedPollution),2);
        }
        if (GAME_BOARD.getHighlightedTiles().length == 1 && GAME_BOARD.getHighlightedTiles()[0].isRiver()){  
          purchaseInfo = ""; 
          pollutionInfo = "";
        }// Empty message when only one River Tile is highlighted
        
        textFont(MESSAGEFONT);
        fill(125);
        textAlign(CORNER);
        text(purchaseInfo, XPOS+470, YPOS + SIZE_Y*TILE_HEIGHT + 90);  
        text(pollutionInfo, XPOS+470, YPOS + SIZE_Y*TILE_HEIGHT + 110);
        showPrePurchase = false;
      }
    }
    
    void setProjected(float profit, float pollution){
      /* Sets the projected values and displays them */
      projectedProfit = profit;
      projectedPollution = pollution;
      showPrePurchase = true;
    }
  } //END OF NESTED CLASS INFO_BOX
  
  
  
  
  
  class FeedbackBox {
    String modeMessage = "";
    String actionMessage = "";
    
    void display() {
       /*Draws the feedback box and shows messages */
      stroke(255);
      fill(255);
      rect(XPOS, YPOS + SIZE_Y*TILE_HEIGHT + 10, 440, 115);
      fill(0);  //Color of text 
      textFont(MESSAGEFONT);
      textAlign(CORNER);
      text(modeMessage, XPOS + 20, YPOS + SIZE_Y*TILE_HEIGHT + 30);   
      text(actionMessage, XPOS + 20, YPOS + SIZE_Y*TILE_HEIGHT + 50);   
      text("Simple sum of all pollution: " + waterS.sumTotalPollution(), XPOS + 20, YPOS + SIZE_Y*TILE_HEIGHT + 90);
      text("Total pollution entering river after distance decay: " + nfc(waterS.sumDecayPollution(),2), XPOS + 20, YPOS + SIZE_Y*TILE_HEIGHT + 110);
    }
    
    void setModeMessage(String m){
      modeMessage = m;
    }
    
    void setActionMessage(String m){
      actionMessage = m;
    }
  }//END OF NESTED CLASS FEEDBACK_BOX
  
  
  class Dashboard {
    Dashboard(){
    }
    
    void display(){
      showActualProfits();
      showScore();
      showBuildQuota();
      showPollutionSlider();
    }
    
    void showActualProfits() {
      /* Displays the money */
      int x = XPOS + SIZE_X*TILE_WIDTH + 40;
      int y = YPOSB + 460;
      fill(0);
      textFont(BIGFONT);
      textAlign(CORNER);
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
      textAlign(CORNER);
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
      textAlign(CORNER);
      text("Quota: ", x, y);
      textFont(MESSAGEFONT);
      textSize(16);
      text("  Factories: " + waterS.countFactories() + " / " + FACTORY_QUOTA, x,y+30);
      text("  FARM_SLIDER: " + waterS.countFARM_SLIDER() + " / " + FARM_QUOTA, x,y+60);
      text("  HOUSE_SLIDER: " + waterS.countHOUSE_SLIDER() + " / " + HOUSE_QUOTA, x,y+90);
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
  }//END OF NESTED CLASS DASHBOARD
}//END OF GUI CLASS