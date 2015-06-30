class Drop {
    float x, y;                      // Drop coordinates
    float speed;                     // Drop speed
    int type;                        // Drop type 0:water; 1:dirty 
    PImage img;                      // Drop image
    boolean dirty;                 // Drop dirtyness
 
    Drop() {
        if(random(0,100) < DIRTY_DROP_PERC) {
          dirty = true;
          img = loadImage("dirtydrop.png");
        } else {
          dirty = false;
          img = loadImage("waterdrop.png");
        }
        x = random(width - img.width);
        y = DROP_Y;             
        speed = random(SPEED_MIN, SPEED_MAX);
    }
    
   boolean dirty() {
      return dirty;
   }
   
   void splat() {
      if (dirty) {
        img = loadImage("dirtysplat.png");
      } else {
        img = loadImage("watersplat.png");
      } 
   }
   
   void draw() {
      image(img,x,y); 
   }
}
