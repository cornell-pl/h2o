import java.util.*;

// Process d, return true if d is still "alive" or false if not
boolean process(Drop d) {
  // Move d by its speed
  d.y += d.speed;
  if (caught(d)) {
    // If d caught, increment score unless dirty
    if(d.dirty()) {
      lives--;
      score--;
    } else{
      score++;
    }
    return false;
  } else if (dropped(d)) {
    // If d dropped, decrement lives unless dirty
    if(!d.dirty()) {
      lives--;
    }
    return false;
  } else if (splat(d)) {
    // Otherwise if d splatted, slow down, change image, and draw
    d.speed=0.5;
    d.splat();
    d.draw();
    return true;
  } else {              
    // Otherwise, just redraw d at its new position
    d.draw();
    return true;
  }
}

