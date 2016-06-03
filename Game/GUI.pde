import controlP5.*;

void drawGrid(int s) {
  /* Draws a square tile grid of linear dimension s units */
  int w = 20;    //width of a tile
  int h = 20;    //height of a tile
  int xpos = 40;   //xpos and ypos determines the position of the top left corner of the map.  
  int ypos = 40;
                      //*** Note that these must also be changed for the other drawGrid and drawTile
  for (int x=xpos; x < s*w+xpos; x+=w) {
    for (int y=ypos; y < s*h+ypos; y+=h) {
      rect(x, y, w, h);
    }
  }
  //Draw axis labels.
  int xcount = 0;
  for (int x=xpos; x < s*w+xpos; x+=w){
    text(xcount, x+3, xpos-7);
    xcount ++;
  }
  int ycount = 0;
  for (int y=ypos; y < s*h+ypos; y+=h){
    text(ycount, ypos-21, y+15);
    ycount ++;
  }
}

void drawGrid(int x, int y) {
  /* Draws a tile grid of dimension x*y units */
  int w = 20;    //width of a tile
  int h = 20;    //height of a tile
  int xpos = 40;   //xpos and ypos determines the position of the top left corner of the map.
  int ypos = 40;
  for (int x_=xpos; x_ < x*w+xpos; x_+=w) {
    for (int y_=ypos; y_ < y*h+ypos; y_+=h) {
      rect(x_, y_, w, h);
    }
  }
}

void drawTile(int x, int y, color c) {
  /* Draws a tile at Location <x, y> on game map, fill color c */
  int w = 20;    //width of a tile
  int h = 20;    //height of a tile
  int xpos = 40;   //xpos and ypos determines the position of the top left corner of the map.
  int ypos = 40;
  fill(c);
  rect(x*w + xpos, y*w + ypos, w, h);
  fill(255);    //resets to white.
}

//**** Implements a command text box for interaction  ****//
String command;
String locXstr;
String locYstr;
ControlP5 cp5;

void commandBox() {
  PFont font = createFont("Arial", 16, true);
  cp5 = new ControlP5(this);
  
  cp5.addTextfield("input command")
     .setPosition(20, 480)
     .setSize(200,40)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255))
     ;
  
  cp5.addTextfield("Location X")
     .setPosition(20, 560)
     .setSize(80,40)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255))
     ;
     
  cp5.addTextfield("Location Y")
   .setPosition(160, 560)
   .setSize(80,40)
   .setFont(font)
   .setFocus(true)
   .setColor(color(255))
   ;
}

//**** Implements a textlabe for game instructions  ****//
Textlabel instructions;

void showInstructions() {
  instructions = cp5.addTextlabel("label")
                    .setMultiline(true)
                    .setSize(380, 400)
                    .setText("Choose an action:" + 
                    "\nTo construct a factory, type FC into INPUT"+
                    "\nTo build a farm, type FM into INPUT"+
                    "\nTo remove a land use, type RM into INPUT"+
                    "\n\nThen enter the X and Y coordinates and hit enter."+
                    "\n\nNotes: \n*Do not hit enter while cursor in input boxes. Click outside of the box before hitting enter"+
                    "\n*Doesn't catch errors. Bad coordinate inputs crashes game"+
                    "\n*I don't know why this font looks like crap")
                    //.setPosition(s*w+xpos,s*h+ypos)  The auto-positioning method when these vars are GUI class fields
                    .setPosition(460,100)
                    .setColorValue(0)
                    .setFont(createFont("Arial",16, true))
                    ;
}