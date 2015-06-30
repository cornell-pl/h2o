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
   
   // Check if d has been caught
   boolean caught() {
     return (x >= mouseX - bucket.width / 2 && 
             x + img.width <= mouseX - bucket.width / 2 + bucket.width &&
             y >= FLOOR_Y - bucket.height &&
             y <= FLOOR_Y);
     }

  // Check if d has hit the floor
  boolean splatted() {
      return (y >= SPLAT_Y);
  }

  // Check if d has been dropped
  boolean dropped() {
      return (y >= FLOOR_Y);
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
