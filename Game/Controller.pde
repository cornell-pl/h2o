//**** MOUSE INTERACTION  ****//  -----------------------------------------------
Tile selected = null;    //The current Tile that is selected. null if no Tile selected
Button pushed = null;   //The current button that is pushed. null if none is pushed.
Toggle toggled = null;   //The current toggle. null if none toggled
boolean showSlider = false;

int mousePX;    // Mouse press positions
int mousePY;
int mouseRX;   //Mouse release positions
int mouseRY;

Button mouseOverButton = null;

class Controller{
  Watershed waterS;
  GUI view;
  
  Controller(Watershed ws, GUI g) {
    waterS = ws;
    view = g;
  }
  
  void eventLoop() {
    highlightSingleTile();
    highlightManyTiles();
    preAddInfo();
  }
  
  boolean mouseOverMap(){
    /* Helper function: Returns true if the mouse position is over the Watershed map. false otherwise. */
    int[] xRange = {XPOS, XPOS + SIZE_X*TILE_WIDTH};
    int[] yRange = {YPOS, YPOS + SIZE_Y*TILE_HEIGHT};
    return ((mouseX > xRange[0] && mouseX < xRange[1]) && (mouseY > yRange[0] && mouseY < yRange[1]));
  }
  
  boolean mouseOverButton(){
    return view.factoryB.isOver() ||
           view.farmB.isOver() ||
           view.houseB.isOver() ||
           view.forestB.isOver() ||
           view.demolishB.isOver() ||
           view.resetB.isOver();
  }
  
  boolean inAddMode(){
    /* Returns true if an adder button is pushed (includes demolish). False otherwise */
    return pushed == view.factoryB ||
           pushed == view.farmB ||
           pushed == view.houseB ||
           pushed == view.forestB ||
           pushed == view.demolishB;
  }
  
  Button getOverButton() {
    /* Returns Button mouse is over. */
     return mouseOverButton;
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
  
  void highlightSingleTile() {
    /* Tells GUI which Tile to highlight when mouse is over map */
    if (control.mouseOverMap() && !mousePressed) {
      int[] pos = control.converter(mouseX, mouseY);
      view.highlightThese.add(new int[] {pos[0], pos[1]});
      if (inAddMode() && (!waterS.getTile(pos[0], pos[1]).isRiver())){   //Change highlight color when in add mode but not over River
        view.highlightColor = pushed.baseColor;
      }else view.highlightColor = DEFAULT_HIGHLIGHT;
    }
  }
  
  void preAddInfo(){
    float projectedProfit = 0;
    float projectedPollution = 0;
    purchaseInfo = "";   //No button is pushed
    pollutionInfo = "";
    if (control.mouseOverMap() && inAddMode()) {
      for (int[] c : view.highlightThese){
        Tile t = waterS.getTile(c[0], c[1]);
        float d = t.distToRiver();
        if (! waterS.getTile(c[0], c[1]).isRiver()){
          if  (pushed == view.factoryB) {    
            projectedProfit += FACTORY.calcActualProfit(d);  
            projectedPollution += FACTORY.calcDecayPollution(d);
          } 
          else if (pushed == view.farmB) {
            projectedProfit += FARM.calcActualProfit(d);
            projectedPollution += FARM.calcDecayPollution( d);
          }
          else if (pushed == view.houseB) {
            projectedProfit += HOUSE.calcActualProfit(d);
            projectedPollution += HOUSE.calcDecayPollution(d);
          }
          else if (pushed == view.forestB) {
            projectedProfit += FOREST.calcActualProfit(d);
            projectedPollution += FOREST.calcDecayPollution(d);
          }   //Calculations for each button
        }else {    //Don't sum when over River
          projectedProfit += 0;
          projectedPollution += 0;
        }
      }
      if (pushed != view.demolishB) {
        if (projectedProfit > 0) purchaseInfo = "Money: + $" + nfc(round(projectedProfit));
        else purchaseInfo = "Money: - $" + nfc(abs(projectedProfit),2);
        if (projectedPollution > 0)pollutionInfo = "Pollution: + " + nfc(projectedPollution,2);
        else pollutionInfo = "Pollution: - " + nfc(abs(projectedPollution),2);
      }
    }
  }
  
  
  void highlightManyTiles() {
    /* Tells GUI what Tiles to highlight when mouse is dragged */
    if (mousePressed && mouseOverMap()) {         //When no button is pushed
      int[] posP = control.converter(mousePX, mousePY);   //tile coordinate when mouse is pressed
      int[] posC = control.converter(mouseX, mouseY);     //current tile coordinate
      if ((posP[0] >= 0 && posP[0] <SIZE_X) && (posP[1] >= 0 && posP[1] < SIZE_Y)) {
        for (int x = min(posP[0], posC[0]); x <= max(posP[0], posC[0]); x++) {
          for (int y = min(posP[1], posC[1]); y <= max(posP[1], posC[1]); y++) {
            view.highlightThese.add(new int[] {x,y});
          }
        }// for all tiles to highlight
      }// if tile range is valid
      if (inAddMode()){   //Change highlight color when in add mode
        view.highlightColor = pushed.baseColor;
      }else view.highlightColor = DEFAULT_HIGHLIGHT;
    }
  } 
  
  
  void pressButton() {
    if (mouseOverButton()) {
      Button b = getOverButton();
      if (b != view.resetB && b != view.demolishB){
        if (pushed == b) {
          message = "";
          pushed = null;
        } else {
          pushed = b;
          message = "Add " + b.label + " mode is selected";
          message2 = "";
         }
      }
      else if(b == view.demolishB) {   //When demolish button is clicked on
        if (pushed == view.demolishB) {
          message = "";
          pushed = null;
        } else {
          pushed = view.demolishB;
          message = "Demolish mode is selected";
          message2 = "";
        }
      }
      else if(b == view.resetB) {  //When reset button is clicked on
        if (pushed == view.resetB) {
          message = "Restarting game";
          message2 = "";
          WS = new Watershed(SIZE_X, SIZE_Y);      //
          graphics.waterS = WS;                
          pushed = null;
          selected = null;
          message = "Game is reset";
          message2 = "";
        }else {
          pushed = view.resetB;
          message = "Do you want to reset the map? Click button again to reset.";
          message2 = "Click anywhere to cancel.";
        }
      }
    }
  }
  
  void pressOnMap(){
    if (mouseOverMap()){     //When mouse clicked on tile
      mousePX = mouseX;
      mousePY = mouseY;
      if (pushed == view.resetB) {
        message2 = "";
        message = "";
        pushed = null;
      }
    }
  }
  
  void pressOutOfMap(){
    if (! mouseOverMap() && !mouseOverButton() && !view.factoryS.over && !view.farmS.over && !view.houseS.over && !view.forestS.over && !view.showPolT.over && !view.showDecayPolT.over && !view.showDistT.over && !view.showProfitT.over){
      if (pushed == view.resetB)
        message2 = "";
      pushed = null;
      message = "";
    }
  }
      
  void unselect(){
    if (! mouseOverMap() && !view.factoryS.over && !view.farmS.over && !view.houseS.over && !view.forestS.over && !view.showPolT.over && !view.showDecayPolT.over && !view.showDistT.over && !view.showProfitT.over)
      selected = null;    //Unselect when I click outside map
  }
  
  void selectTile(){
    if (control.mouseOverMap() && mouseButton == LEFT){ 
      mouseRX = mouseX;
      mouseRY = mouseY;
      int[] posP = control.converter(mousePX, mousePY);
      int[] posR = control.converter(mouseRX, mouseRY);
      if (pushed == null) {
      selected = WS.getTile(posR[0],posR[1]);     //Select tile if no button is pushed and clicked inside map
      } 
      if (pushed != null) 
        selected = null;     //Remove selection when building things
    }
    if (mouseButton == RIGHT) {    //Right mouse button to cancel selection and button pushed
      message = "";
      pushed = null;
      selected = null;
    }
  }
  
  void addStuff(){
    if (control.mouseOverMap() && mouseButton == LEFT){    //Left mouse button to add
      mouseRX = mouseX;
      mouseRY = mouseY;
      int[] posP = control.converter(mousePX, mousePY);
      int[] posR = control.converter(mouseRX, mouseRY);
      int count = 0;
      String thing = "";
      boolean s = false;
      for (int x = min(posP[0], posR[0]); x <= max(posP[0], posR[0]); x++) {
        for (int y = min(posP[1], posR[1]); y <= max(posP[1], posR[1]); y++) {
          if (pushed == graphics.factoryB) {        //If factory button is in pressed state
            s = WS.addFactory(x, y);      //count++ only when true
            if (s) count ++;
            thing = "Factories";
          } 
          else if (pushed == graphics.farmB) {        //If farm button is in pressed state
            s = WS.addFarm(x, y);
            if (s) count ++;
            thing = "Farms";
          }
          else if (pushed == graphics.houseB) {        //If house button is in pressed state
            s = WS.addHouse(x, y);
            if (s) count ++;
            thing = "Houses";
          }
          else if (pushed == graphics.forestB) {        //If forest button is in pressed state
            s = WS.addForest(x, y);
            if (s) count ++;
            thing = "Forests";
          }
          else if(pushed == graphics.demolishB) {    //If demolish button is in pressed state
            s = WS.removeLandUse(x,y);
            if (s) count ++;
          }
        }
      }
      if (count > 1 || (count == 1 && s == false)) {  //Different message if multiple objects 
        message2 = "Added " + Integer.toString(count) + " " + thing;    
        if (pushed == graphics.demolishB) message2 = "Removed land use at " + Integer.toString(count) + " locations";
      }    
    }
  }
}


void mousePressed() {  
  mousePX = mouseX; mousePY = mouseY;
  control.pressOnMap();
  control.pressButton();
  control.pressOutOfMap();
  control.unselect();
}

void mouseDragged(){
}

void mouseReleased() {
  control.selectTile();
  control.addStuff();
}

void mouseClicked() {
  if (graphics.showPolT.over) {
    if (toggled == graphics.showPolT) toggled = null;
    else toggled = graphics.showPolT;
  }else if (graphics.showDecayPolT.over) {
    if (toggled == graphics.showDecayPolT) toggled = null;
    else toggled = graphics.showDecayPolT;
  }else if (graphics.showDistT.over) {
    if (toggled == graphics.showDistT) toggled = null;
    else toggled = graphics.showDistT;
  }else if (graphics.showProfitT.over) {
    if (toggled == graphics.showProfitT) toggled = null;
    else toggled = graphics.showProfitT;
  }
  else if (graphics.sliderT.over) {
    if (showSlider == true) showSlider = false;
    else showSlider = true;
  }
}