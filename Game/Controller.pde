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

  //if (mouseOverMap()){     //When mouse clicked on tile
  //  mousePX = mouseX;
  //  mousePY = mouseY;
  //  if (pushed == resetB) {
  //    message2 = "";
  //    message = "";
  //    pushed = null;
  //  }
  //}
  //else {
  //  if (pushed == resetB) {
  //    message2 = "";
  //  }
  //  pushed = null;
  //  message = "";
  //}
  //if (! mouseOverMap() && !factoryS.over && !farmS.over && !houseS.over && !forestS.over && !showPolT.over && !showDecayPolT.over && !showDistT.over && !showProfitT.over)
  //  selected = null;    //Unselect when I click outside map
}
//
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
        //if (pushed == factoryB) {        //If factory button is in pressed state
        //  s = WS.addFactory(x, y);      //count++ only when true
        //  if (s) count ++;
        //  thing = "Factories";
        //} 
        //else if (pushed == farmB) {        //If farm button is in pressed state
        //  s = WS.addFarm(x, y);
        //  if (s) count ++;
        //  thing = "Farms";
        //}
        //else if (pushed == houseB) {        //If house button is in pressed state
        //  s = WS.addHouse(x, y);
        //  if (s) count ++;
        //  thing = "Houses";
        //}
        //else if (pushed == forestB) {        //If forest button is in pressed state
        //  s = WS.addForest(x, y);
        //  if (s) count ++;
        //  thing = "Forests";
        //}
        //else if(pushed == demolishB) {    //If demolish button is in pressed state
        //  s = WS.removeLandUse(x,y);
        //  if (s) count ++;
        //}
      }
    }
    if (pushed == null) {
      selected = WS.getTile(posR[0],posR[1]);     //Select tile if no button is pushed and clicked inside map
    } 
    if (pushed != null) selected = null;     //Remove selection when building things
    
    if (count > 1 || (count == 1 && s == false)) {  //Different message if multiple objects 
      message2 = "Added " + Integer.toString(count) + " " + thing;    
      //if (pushed == demolishB) message2 = "Removed land use at " + Integer.toString(count) + " locations";
    }    
  }
  if (mouseButton == RIGHT) {    //Right mouse button to cancel selection and button pushed
    message = "";
    pushed = null;
    selected = null;
  }
}

void mouseClicked() {
  for (Button b: graphics.BPanel.getButtons()){
    b.press();
  }
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