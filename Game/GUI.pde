class GUI {
  int tileWidth = 20;   //width of a tile in pixels
  int tileHeight = 20;    //height of a tile in pixels
  int xpos = 40;   //xpos and ypos determines the position of the top left corner of the map, in pixels
  int ypos = 40;
  int sizeX;
  int sizeY;

  GUI(int x, int y) {
    sizeX = x; sizeY = y;
  }
  
  void render() {
    /* Single function for all graphics.
    * Draws each frame   */
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
}