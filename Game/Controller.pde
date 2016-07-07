//**** MOUSE INTERACTION  ****//  -----------------------------------------------
Tile selected = null;    //The current Tile that is selected. null if no Tile selected
Button pushed = null;   //The current button that is pushed. null if none is pushed.
Toggle toggled = null;   //The current toggle. null if none toggled
boolean showSlider = false;


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


class Controller{
  Watershed waterS;
  GUI view;
  
  Controller(Watershed ws, GUI g) {
    waterS = ws;
    view = g;
  }
  
  void pressButton() {
    if (view.factoryB.over) {      //When factory button is clicked on
      if (pushed == view.factoryB) {
        message = "";
        pushed = null;
      } else {
        pushed = view.factoryB;
        message = "Add factory mode is selected";
        message2 = "";
       }
    }
    else if (view.farmB.over) {      //When farm button is clicked on
      if (pushed == view.farmB) {
        message = "";
        pushed = null;
      }else {
        pushed = view.farmB;
        message = "Add farm mode is selected";
        message2 = "";
       }
    }
    else if (view.houseB.over) {      //When house button is clicked on
      if (pushed == view.houseB) {
        message = "";
        pushed = null;
      } else {
        pushed = view.houseB;
        message = "Add house mode is selected";
        message2 = "";
      }
    }
    else if (view.forestB.over) {      //When forest button is clicked on
      if (pushed == view.forestB) {
        message = "";
        pushed = null;
      }else {
        pushed = view.forestB;
        message = "Add forest mode is selected";
        message2 = "";
      }
    }
    else if(view.demolishB.over) {   //When demolish button is clicked on
      if (pushed == view.demolishB) {
        message = "";
        pushed = null;
      } else {
        pushed = view.demolishB;
        message = "Demolish mode is selected";
        message2 = "";
      }
    }
    else if(view.resetB.over) {  //When reset button is clicked on
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
  
  void pressMapTile(){
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
    if (pushed == view.resetB)
      message2 = "";
    pushed = null;
    message = "";
  }
  
  void unselect(){
    if (! mouseOverMap() && !view.factoryS.over && !view.farmS.over && !view.houseS.over && !view.forestS.over && !view.showPolT.over && !view.showDecayPolT.over && !view.showDistT.over && !view.showProfitT.over)
      selected = null;    //Unselect when I click outside map
  }
}
  

void mousePressed() {  
  control.pressButton();
  control.pressMapTile();
  control.pressOutOfMap();
  control.unselect();
}

void mouseReleased() {
  if (mouseOverMap() && mouseButton == LEFT){    //Left mouse button to add
    mouseRX = mouseX;
    mouseRY = mouseY;
    int[] posP = converter(mousePX, mousePY);
    int[] posR = converter(mouseRX, mouseRY);
    selected = WS.getTile(posR[0], posR[1]);
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
    if (pushed == null) {
      selected = WS.getTile(posR[0],posR[1]);     //Select tile if no button is pushed and clicked inside map
    } 
    if (pushed != null) selected = null;     //Remove selection when building things
    
    if (count > 1 || (count == 1 && s == false)) {  //Different message if multiple objects 
      message2 = "Added " + Integer.toString(count) + " " + thing;    
      if (pushed == graphics.demolishB) message2 = "Removed land use at " + Integer.toString(count) + " locations";
    }    
  }
  if (mouseButton == RIGHT) {    //Right mouse button to cancel selection and button pushed
    message = "";
    pushed = null;
    selected = null;
  }
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