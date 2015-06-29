import java.util.*;

/* Screen coordinates have the origin in the top left corner,
   and positive x and y being left and down, respectively.
   
   --------> x
   |
   |
   |
   v
   y
   
*/

/* CONSTANTS */
final int BOARD_SIZE = 400;        // Size of the game board
final int LIVES = 5;               // Number of "lives" each player gets
final int LIVES_TEXT_X = 10;       // X-coordinate of lives text on board
final int LIVES_TEXT_Y = 25;       // Y-coordinate of lives text on board
final int LIVES_DROP_X = 50;       // X-coordinate of first lives waterdrop on board
final int LIVES_DROP_Y = 5;        // Y-coordinate of first lives waterdrop on board
final int SCORE_TEXT_X = 10;       // X-coordinate of score text on board
final int SCORE_TEXT_Y = 60;       // Y-coordinate of score text on board
final int DROP_Y = -50;            // Y-coordinate of waterdrops on board
final int SPEED_MIN = 1;           // Minimum waterdrop speed
final int SPEED_MAX = 5;           // Maximum waterdrop speed
final int FLOOR_Y = 390;           // Threshold below which waterdrops are considered not caught
final int DROP_ADD_FREQ = 97;      // How frequently to add new water drops
final int FONT_SIZE = 36;          // Size of game over text
final int DIRTY_DROP_PERC = 20;    // Maximum number of dirty drops out of 100 drops 

/* GLOBAL VARIABLES */
Set<Drop> drops;                   // Set of current water drops
int lives;                         // Number of "lives" left
int score;                         // Current score 
PImage bucket;              // bucket Image
PImage[] splats = new PImage[2];    //Splat Image 0:water;1:dirty
PImage[] waterdrops = new PImage[2]; // Drop images 0:water;1:dirty

/* DROP DATA STRUCTURE */
class Drop {
    float x, y;                      // Drop coordinates
    float speed;                     // Drop speed
    int type;                       // Drop type 0:water; 1:dirty 

    // Drop constructor
    Drop() {
        if(random(0,100) < DIRTY_DROP_PERC)
           type = 1;
        else
          type = 0;
        x = random(width - waterdrops[type].width);
        y = DROP_Y;             
        speed = random(SPEED_MIN, SPEED_MAX);
    }
}

/* SETUP BOARD */
void setup() {
    size(BOARD_SIZE, BOARD_SIZE);
    //smooth();
    score = 0;
    lives = LIVES;
    bucket = loadImage("bucket.png");
    waterdrops[0] = loadImage("waterdrop.png");
    waterdrops[1] = loadImage("dirtydrop.png");
    splats[0] = loadImage("watersplat.png");
    splats[1] = loadImage("dirtysplat.png");
    drops = new HashSet();
}

/* HELPER FUNCTIONS */
// Check if d has been caught
boolean caught(Drop d) {
    return (d.x >= mouseX - bucket.width / 2 && 
            d.x + waterdrops[d.type].width <= mouseX - bucket.width / 2 + bucket.width &&
            d.y >= FLOOR_Y - bucket.height &&
            d.y <= FLOOR_Y);
}

// Check if d has been dropped
boolean dropped(Drop d) {
    return (d.y >= FLOOR_Y);
}

/* DRAW BOARD */
void draw() {
    background(255);
    fill(0);  
    if(lives > 0) {
        // If player still has lives left
      
        // Draw the lives
        text("Lives: ", LIVES_TEXT_X, LIVES_TEXT_Y);
        for (int i = 0; i < lives; i++) {
            image(waterdrops[0], LIVES_DROP_X + waterdrops[0].width * i, LIVES_DROP_Y);    
        }

        // Draw the current score
        text("Score: " + score, SCORE_TEXT_X, SCORE_TEXT_Y);  
        if (millis() % DROP_ADD_FREQ == 0) {
            drops.add(new Drop());
        }

        // Draw the bucket
        int bucketx = mouseX - bucket.width / 2;
        int buckety = FLOOR_Y - bucket.height;
        image(bucket, bucketx, buckety); 
    
        // Draw each of the waterdrops
        Iterator iter = drops.iterator();
        while(iter.hasNext()) {       
            // Set d to the current water drop     
            Drop d = (Drop)iter.next();

            // Move d by its speed
            d.y += d.speed;

            if (caught(d)) {
                // If d caught, increment score
                if(d.type == 0){
                  score++;
                  image(splats[d.type],d.x,d.y);
                  iter.remove();
                }else{
                  lives--;
                  score--;
                  image(splats[d.type],d.x,d.y);
                  iter.remove();
                }
            } else if (dropped(d)) {
                // Otherwise if d dropped, decrement lives
                if(d.type == 0){
                  lives--;
                }
                image(splats[d.type],d.x,d.y);
                iter.remove();
            } else {
                // Otherwise, just redraw d at its new position
                image(waterdrops[d.type],d.x,d.y); 
            }
        }
    } else {
        // If the player does not have lives left

        textSize(FONT_SIZE);
        textAlign(CENTER);

        // Draw the game over screen
        fill(255,0,0);
        text("Game over!", width / 2, height / 2);

        // Draw the final score
        fill(0,0,0);
        text("Final score: " + score, width / 2, 5 * height / 8);
    }
}
