//**** MOUSE INTERACTION  ****//  -----------------------------------------------
Tile selected = null;    //The current Tile that is selected. null if no Tile selected
Button pushed = null;   //The current button that is pushed. null if none is pushed.
Toggle toggled = null;   //The current toggle. null if none toggled
boolean showSlider = false;

int mousePX;    // Mouse press positions
int mousePY;
int mouseRX;   //Mouse release positions
int mouseRY;

class Controller{
  final HighlightController HIGHLIGHT_CONTROLLER = new HighlightController();
  
  Watershed waterS;
  GUI view;
  
  Controller(Watershed ws, GUI g) {
    waterS = ws;
    view = g;
  }
  
  void eventLoop() {
    HIGHLIGHT_CONTROLLER.run();
    calcAddInfo();
  }
  
  boolean mouseOverMap(){
    /* Returns true if the mouse position is over the Watershed map. false otherwise. */
    int[] xRange = {XPOS, XPOS + SIZE_X*TILE_WIDTH};
    int[] yRange = {YPOS, YPOS + SIZE_Y*TILE_HEIGHT};
    return ((mouseX > xRange[0] && mouseX < xRange[1]) && (mouseY > yRange[0] && mouseY < yRange[1]));
  }
  
  boolean mouseOverButton(){
    /* Returns true if mouse is over a button, false otherwise. */
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
    /* Returns Button mouse is over, null if mouse not over any button*/
    Button over = null;
    if (view.factoryB.isOver()) over = view.factoryB;
    if (view.farmB.isOver()) over = view.farmB;
    if (view.houseB.isOver()) over = view.houseB;
    if (view.forestB.isOver()) over = view.forestB;
    if (view.demolishB.isOver()) over = view.demolishB;
    if (view.resetB.isOver()) over = view.resetB;
    return over;
  }
  
  int[] converter(int xraw, int yraw) {
    /*Converts raw coordinates x and y in frame to tile locations   */
    if (mouseOverMap()){
      int xloc = 0;
      int yloc = 0;
      xloc = (xraw-XPOS)/TILE_WIDTH;
      yloc = (yraw-YPOS)/TILE_HEIGHT;
      int[] out = {xloc, yloc};
      return out;
    } else return new int[] {0,0};
  }
  
  class HighlightController {
    void highlightSingleTile() {
      /* Decides which Tile to highlight when mouse is over map */
      if (control.mouseOverMap() && !mousePressed) {
        int[] pos = control.converter(mouseX, mouseY);
        Tile t = waterS.getTile(pos[0], pos[1]);
        color highlightColor;
        if (inAddMode() && (!t.isRiver()))   //Change highlight color when in add mode but not over River
          highlightColor = pushed.baseColor;
        else highlightColor = DEFAULT_HIGHLIGHT;
        highlight(t, highlightColor);
      }
    }
    
    void highlightManyTiles() {
      /* Decides what Tiles to highlight when mouse is dragged */
      if (mousePressed && mouseOverMap()) {         //When no button is pushed
        int[] posP = control.converter(mousePX, mousePY);   //tile coordinate when mouse is pressed
        int[] posC = control.converter(mouseX, mouseY);     //current tile coordinate
        color highlightColor;
        if ((posP[0] >= 0 && posP[0] <SIZE_X) && (posP[1] >= 0 && posP[1] < SIZE_Y)) {
          for (int x = min(posP[0], posC[0]); x <= max(posP[0], posC[0]); x++) {
            for (int y = min(posP[1], posC[1]); y <= max(posP[1], posC[1]); y++) {
              Tile t = waterS.getTile(x, y);
              if (inAddMode() && (!t.isRiver()))   //Change highlight color when in add mode but not over River
                highlightColor = pushed.baseColor;
              else highlightColor = DEFAULT_HIGHLIGHT;
             highlight(t, highlightColor);
            }
          }// for all tiles to highlight
        }// if tile range is valid
      }
    } 
    
    void highlight(Tile t, color highlightColor){
      /* Instructs GUI the Tile to highlight and its color */
       view.GAME_BOARD.highlightTile(t, highlightColor);
    }
    
    void run(){
      highlightSingleTile();
      highlightManyTiles();
    }
  }
  
  
  void calcAddInfo(){
    /* Determines if in add mode, calculated projected values, instructs INFO_BOX to display them */
    float projectedProfit = 0;
    float projectedPollution = 0;
    if (control.mouseOverMap() && inAddMode()) {
      for (Tile t : view.GAME_BOARD.getHighlightedTiles()){
        float d = t.distToRiver();
        if (! t.isRiver()){
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
      view.INFO_BOX.setProjected(projectedProfit, projectedPollution);
    }
  }
  
  
  void pushUnpushButtons() {
    if (mouseOverButton()) {
      Button b = getOverButton();
      if (b != view.resetB && b != view.demolishB){
        if (pushed == b) {
         view.FEEDBACK_BOX.setModeMessage("");
          pushed = null;
        } else {
          pushed = b;
          view.FEEDBACK_BOX.setModeMessage("Add " + b.label + " mode is selected");
          view.FEEDBACK_BOX.setActionMessage("");
         }
      }
      else if(b == view.demolishB) {   //When demolish button is clicked on
        if (pushed == view.demolishB) {
           view.FEEDBACK_BOX.setModeMessage("");
          pushed = null;
        } else {
          pushed = view.demolishB;
          view.FEEDBACK_BOX.setModeMessage("Demolish mode is selected");
          view.FEEDBACK_BOX.setActionMessage("");
        }
      }
      else if(b == view.resetB) {  //When reset button is clicked on
        if (pushed == view.resetB) {
          view.FEEDBACK_BOX.setModeMessage("Restarting game");
          view.FEEDBACK_BOX.setActionMessage("");
          WS = new Watershed(SIZE_X, SIZE_Y);      //
          graphics.waterS = WS;                
          pushed = null;
          selected = null;
          view.FEEDBACK_BOX.setModeMessage("");
          view.FEEDBACK_BOX.setActionMessage("Game is reset");
        }else {
          pushed = view.resetB;
          view.FEEDBACK_BOX.setModeMessage("Do you want to reset the map? Click button again to reset.");
          view.FEEDBACK_BOX.setActionMessage("Click anywhere to cancel.");
        }
      }
    }
    //Unpress button if clicked out of map but not on sliders and toggles
    if (! mouseOverMap() && !mouseOverButton() && !view.factoryS.over && !view.farmS.over && !view.houseS.over && !view.forestS.over && !view.showPolT.over && !view.showDecayPolT.over && !view.showDistT.over && !view.showProfitT.over){
      //Unpress reset button if it is pressed and user clicks outside the button
      if (pushed == view.resetB && ! view.resetB.isOver()) {
        view.FEEDBACK_BOX.setModeMessage("");
        view.FEEDBACK_BOX.setActionMessage("");
      }
      pushed = null;
      view.FEEDBACK_BOX.setModeMessage("");
    }
  }
      
  void unselect(){
    if (! mouseOverMap() && !view.factoryS.over && !view.farmS.over && !view.houseS.over && !view.forestS.over && !view.showPolT.over && !view.showDecayPolT.over && !view.showDistT.over && !view.showProfitT.over && !view.sliderT.over)
      selected = null;    //Unselect when I click outside map
  }
  
  void selectTile(){
    if (control.mouseOverMap() && mouseButton == LEFT){ 
      int[] posP = control.converter(mousePX, mousePY);
      int[] posR = control.converter(mouseRX, mouseRY);
      if (pushed == null) {
      selected = WS.getTile(posR[0],posR[1]);     //Select tile if no button is pushed and clicked inside map
      } 
      if (pushed != null) 
        selected = null;     //Remove selection when building things
    }
    if (mouseButton == RIGHT) {    //Right mouse button to cancel selection and button pushed
      view.FEEDBACK_BOX.setModeMessage("");
      pushed = null;
      selected = null;
    }
  }
  
  void addStuff(){
    if (control.mouseOverMap() && mouseButton == LEFT && inAddMode()){    //Left mouse button to add
      int[] posP = control.converter(mousePX, mousePY);     //Mouse press position
      int[] posR = control.converter(mouseRX, mouseRY);    //Mopuse release position
      LandUse olu = null;  //Original landuse of tile
      int count = 0;    //Number of landUses add/removed
      String thing = "";  
      boolean s = false;
      int i = 0; 
      int j = 0;      
      for (int x = min(posP[0], posR[0]); x <= max(posP[0], posR[0]); x++) {
        for (int y = min(posP[1], posR[1]); y <= max(posP[1], posR[1]); y++) {
          if (pushed == view.factoryB) {        //If factory button is in pressed state
            s = WS.addFactory(x, y);      //count++ only when true
            if (s) {
              count ++;   //increment and save coordinates if successful
              i = x;
              j = y;
            }
            thing = "Factory";
            if (count > 1) thing = "Factories";
          } 
          else if (pushed == view.farmB) {        //If farm button is in pressed state
            s = WS.addFarm(x, y);
             if (s) {
              count ++;
              i = x;
              j = y;
            }
            thing = "Farm";
            if (count > 1) thing = "Farms";
          }
          else if (pushed == view.houseB) {        //If house button is in pressed state
            s = WS.addHouse(x, y);
             if (s) {
              count ++;
              i = x;
              j = y;
            }
            thing = "House";
            if (count > 1) thing = "Houses";
          }
          else if (pushed == view.forestB) {        //If forest button is in pressed state
            s = WS.addForest(x, y);
            if (s) {
              count ++;
              i = x;
              j = y;
            }
            thing = "Forest";
            if (count > 1) thing = "Forests";
          }
          else if(pushed == view.demolishB) {    //If demolish button is in pressed state
            LandUse temp = waterS.getTile(x,y).getLandUse();
            s = WS.removeLandUse(x,y);
             if (s) {
              count ++;
              i = x;
              j = y;
            }
            if (s) olu = temp;   //remember previous landuse if successful
          }
        }
      }   //for all Tiles to add landuse
      
      // Set messages to display
      if (count > 1) {
        view.FEEDBACK_BOX.setActionMessage("Built " + Integer.toString(count) + " " + thing);    
        if (pushed == graphics.demolishB) 
          view.FEEDBACK_BOX.setActionMessage("Removed land use at " + Integer.toString(count) + " locations");
      }  //count > 1
      else if (count == 1){
        view.FEEDBACK_BOX.setActionMessage("Added a " + thing + " at " + "<" +(i)+ ", " +(j)+ ">");  
        if (pushed == graphics.demolishB) 
          view.FEEDBACK_BOX.setActionMessage("Removed " + olu.toString() + " at " + "<" +(i)+ ", " +(j)+ ">");  
      }  // count == 1
      else {
        view.FEEDBACK_BOX.setActionMessage("Cannot build " +thing+ " in river. Nothing is added.");
        if (pushed == graphics.demolishB) 
          view.FEEDBACK_BOX.setActionMessage("Nothing to remove");
      } //count == 0
    } //if mouseOverMap() and mouseButton == LEFT
  }
}


void mousePressed() {  
  mousePX = mouseX; mousePY = mouseY;
  control.pushUnpushButtons();
  control.unselect();
}

void mouseDragged(){
}

void mouseReleased() {
  mouseRX = mouseX;
  mouseRY = mouseY;
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