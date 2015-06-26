import java.util.*;

/* CONSTANTS */
final int BOARD_SIZE = 400;        // Size of the game board
final int LIVES = 5;               // Number of "lives" each player gets
final int LIVES_TEXT_X = 10;       // X-coordinate of lives text on board
final int LIVES_TEXT_Y = 25;       // Y-coordinate of lives text on board
final int LIVES_DROP_X = 50;       // X-coordinate of first lives waterdrop on board
final int LIVES_DROP_Y = 5;        // Y-coordinate of first lives waterdrop on board
final int SCORE_TEXT_X = 10;       // X-coordinate of score text on board
final int SCORE_TEXT_Y = 60;       // X-coordinate of score text on board
final int DROP_Y = -50;            // Y-coordinate of waterdrops on board
final int SPEED_MIN = 1;           // Minimum waterdrop speed
final int SPEED_MAX = 5;           // Maximum waterdrop speed
final int FLOOR_Y = 390;           // Threshold below which waterdrops are considered not caught
final int DROP_ADD_FREQ = 97;      // How frequently to add new water drops
final int FONT_SIZE = 36;          // Size of game over text

/* GLOBAL VARIABLES */
Set drops;                         // Set of current water drops
int lives;                         // Number of "lives" left
int score;                         // Current score 
PImage bucket, waterdrop, splat;   // Images

/* DROP DATA STRUCTURE */
class Drop {
    float x, y;                      // Drop coordinates
    float speed;                     // Drop speed

    // Drop constructor
    Drop() {
        x = random(width - waterdrop.width);
        y = DROP_Y;             
        speed = random(SPEED_MIN, SPEED_MAX); 
    }
}

/* SETUP BOARD */
void setup() {
    size(BOARD_SIZE, BOARD_SIZE);
    smooth();
    score = 0;
    lives = LIVES;
    bucket = loadImage("bucket.png");
    waterdrop = loadImage("waterdrop.png");
    splat = loadImage("splat.png");
    drops = new HashSet();
}

/* HELPER FUNCTIONS */
// Check if d has been caught
boolean caught(Drop d) {
    return (d.x >= mouseX - bucket.width / 2 && 
            d.x + waterdrop.width <= mouseX - bucket.width / 2 + bucket.width &&
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
            image(waterdrop, LIVES_DROP_X + waterdrop.width * i, LIVES_DROP_Y);    
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
                score++;
                image(splat,d.x,d.y);
                iter.remove();
            } else if (dropped(d)) {
                // Otherwise if d dropped, decrement lives
                lives--;
                image(splat,d.x,d.y);
                iter.remove();
            } else {
                // Otherwise, just redraw d at its new position
                image(waterdrop,d.x,d.y); 
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
