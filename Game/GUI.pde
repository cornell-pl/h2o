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
}