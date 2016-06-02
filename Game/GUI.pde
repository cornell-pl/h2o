import controlP5.*;

void drawGrid(int s) {
  /* Draws a square tile grid of linear dimension s units */
  int w = 20;    //width of a tile
  int h = 20;    //height of a tile
  int xpos = 10;   //xpos and ypos determines the position of the top left corner of the map.
  int ypos = 10;
  for (int x=xpos; x < s*w+xpos; x+=w) {
    for (int y=ypos; y < s*h+ypos; y+=h) {
      rect(x, y, w, h);
    }
  }
}

void drawGrid(int x, int y) {
  /* Draws a tile grid of dimension x*y units */
  int w = 20;    //width of a tile
  int h = 20;    //height of a tile
  int xpos = 10;   //xpos and ypos determines the position of the top left corner of the map.
  int ypos = 10;
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
  int xpos = 10;   //xpos and ypos determines the position of the top left corner of the map.
  int ypos = 10;
  fill(c);
  rect(x*w + xpos, y*w + ypos, w, h);
  fill(255);    //resets to white.
}

//**** Implements a command text box for interaction  ****//
String command;
int locX;
int locY;
ControlP5 cp5;

void commandBox() {
  cp5 = new ControlP5(this);
  PFont font = createFont("arial", 18);
  
  cp5.addTextfield("input command")
     .setPosition(20, 450)
     .setSize(200,40)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255))
     ;
  
  cp5.addTextfield("Location X")
     .setPosition(20, 550)
     .setSize(80,40)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255))
     ;
     
  cp5.addTextfield("Location Y")
   .setPosition(160, 550)
   .setSize(80,40)
   .setFont(font)
   .setFocus(true)
   .setColor(color(255))
   ;
}

void doStuff(String textValue) {
  if (textValue == "addFC") {
  }
}