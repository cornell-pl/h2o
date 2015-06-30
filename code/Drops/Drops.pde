import java.util.*;

// Process d, return true if d is still "alive" or false if not
boolean process(Drop d) {
  // Move d by its speed
  d.y += d.speed;
  
  // Draw the drop
  d.draw();
  
  // Return true;
  return true;
}

