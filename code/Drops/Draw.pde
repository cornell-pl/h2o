void draw() {
    background(255);
    fill(0);  
    if(lives > 0) {
        // If player still has lives left
      
        // Draw the lives
        text("Lives: ", LIVES_TEXT_X, LIVES_TEXT_Y);
        for (int i = 0; i < lives; i++) {
            image(scoredrop, LIVES_DROP_X + scoredrop.width * i, LIVES_DROP_Y);    
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
            boolean keep = process(d);
            if (!keep) {
              iter.remove();
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
