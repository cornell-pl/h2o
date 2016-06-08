import controlP5.*;

class GUI {
  int tileWidth = 20;   //width of a tile in pixels
  int tileHeight = 20;    //height of a tile in pixels
  int xpos = 40;   //xpos and ypos determines the position of the top left corner of the map, in pixels
  int ypos = 40;
  int sizeX;
  int sizeY;

  GUI(int x, int y) {
    sizeX = x; sizeY = y;
    showInstructions();
    commandBox();     //Initializes the textfields
  }
  
  void render() {
    /* Draws each frame   */
    for (Tile[] tileRow : WS.gameMap) {
      for (Tile t: tileRow) {
        graphics.drawTile(t.getX(), t.getY(), t.getLandT().getIcon());
      }
    }
    axisLabels();
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
  
  
  //**** Implements a command text box for interaction  ****//  -----------------------------------------------
  String command;
  int locX;
  int locY;
  
  void commandBox() {
    /* Initializes command boxes and labesl */
    PFont font = createFont("Arial", 16, true);
    
    cp5.addTextfield("input command")
       .setPosition(xpos + sizeX*tileWidth + 40, 320)
       .setSize(200,40)
       .setFont(font)
       .setFocus(true)
       .setColor(color(255))
       ;
    
    cp5.addTextfield("Location X")
       .setPosition(xpos + sizeX*tileWidth + 40, 400)
       .setSize(80,40)
       .setFont(font)
       .setFocus(false)
       .setColor(color(255))
       ;
       
    cp5.addTextfield("Location Y")
     .setPosition(xpos + sizeX*tileWidth + 200, 400)
     .setSize(80,40)
     .setFont(font)
     .setFocus(false)
     .setColor(color(255))
     ;
  }
  
  // Getter methods for input into text fields
  void grabCommands() {
    /* Grabs input from the command boxes, ensures they are valid, and stores them*/
    command = cp5.get(Textfield.class,"input command").getText();
    String locXstr = cp5.get(Textfield.class,"Location X").getText();
    String locYstr = cp5.get(Textfield.class,"Location Y").getText();
    
    try {
      locX = Integer.parseInt(locXstr);
      if (locX < 0 || locX > sizeX - 1) throw new NumberFormatException();  // input value out of range
    } catch (NumberFormatException e) {
        println("Error: Location X not a valid number");
    }
    try {
      locY = Integer.parseInt(locYstr);
      if (locY < 0 || locY > sizeY - 1) throw new NumberFormatException();  // input value out of range
    } catch (NumberFormatException e) {
        println("Error: Location Y not a valid number");
    }
  }
  
  String getCommand() {
    return command;
  }
  
  int getLocX() {
    return locX;
  }
  int getLocY() {
    return locY;
  }
 
  //**** Implements a textlabel for game instructions  ****//  -----------------------------------------------
  Textlabel instructions;
  void showInstructions() {
    instructions = cp5.addTextlabel("label")
                      .setMultiline(true)
                      .setSize(380, 200)
                      .setText("Choose an action:" + 
                      "\nTo construct a factory, type FC into INPUT"+
                      "\nTo build a farm, type FM into INPUT"+
                      "\nTo remove a land use, type RM into INPUT"+
                      "\n\nThen enter the X and Y coordinates and hit enter."+
                      "\n\nNotes: \n*Do not hit enter while cursor in input boxes. Click outside of the box before hitting enter"+
                      "\n*I don't know why this font looks like crap")
                      .setPosition(xpos + sizeX*tileWidth + 40, 100)
                      .setColorValue(0)
                      .setFont(createFont("Arial",16, true))
                      ;
  }
}