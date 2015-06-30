void setup() {
    size(BOARD_SIZE, BOARD_SIZE);
    score = 0;
    lives = LIVES;
    bucket = loadImage("bucket.png");
    drops = new HashSet();
    scoredrop = loadImage("waterdrop.png");
}
