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
final int SPLAT_Y = 375;           // Threshold below which waterdrops are considered not caught
final int FLOOR_Y = 400;           // Threshold below which waterdrops are considered vanished
final int DROP_ADD_FREQ = 97;      // How frequently to add new water drops
final int FONT_SIZE = 36;          // Size of game over text
final int DIRTY_DROP_PERC = 20;    // Maximum number of dirty drops out of 100 drops 
