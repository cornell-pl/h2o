// Check if d has been caught
boolean caught(Drop d) {
    return (d.x >= mouseX - bucket.width / 2 && 
            d.x + d.img.width <= mouseX - bucket.width / 2 + bucket.width &&
            d.y >= FLOOR_Y - bucket.height &&
            d.y <= FLOOR_Y);
}

// Check if d has hit the floor
boolean splat(Drop d) {
    return (d.y >= SPLAT_Y);
}

// Check if d has been dropped
boolean dropped(Drop d) {
    return (d.y >= FLOOR_Y);
}
