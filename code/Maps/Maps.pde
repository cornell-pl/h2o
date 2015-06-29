
ImageMarker mark;
UnfoldingMap map, map1, map2;
ZoomLevelUI zoom, zoom1, zoom2;

final String site = "04234000";
final float PAN_RATE = 15;
final float ROTATION_RATE = .02;

void setup() {
    size(800, 600);
    map1 = google_map();
    map2 = ms_map();
    map = map1;
    Location loc = location(site);
    ImageMarker mark = marker(loc);
    MapUtils.createDefaultEventDispatcher(this, map1, map2);
    zoom1 = zoom_ui(map1);
    zoom2 = zoom_ui(map2);
    zoom = zoom1;
    map1.zoomAndPanTo(loc, 10);
    map2.zoomAndPanTo(loc, 10);
    map1.addMarkers(mark);
    map2.addMarkers(mark);
    map1.setTweening(true);
    map2.setTweening(true);
}

void keyHandler() {
    if (key == '1') { 
        map = map1;
        zoom = zoom1;
    } else if (key == '2') {
        map = map2;  
        zoom = zoom2; 
    } else if (key == 'q' || key == 'Q') {
        map.rotate(ROTATION_RATE);     
    } else if (key == 'e' || key == 'E') {
        map.rotate(-ROTATION_RATE);
    } else if (key == 'w' || key == 'W') {
        map.panBy(0,PAN_RATE);
    } else if (key == 'a' || key == 'A') {
        map.panBy(PAN_RATE,0);
    } else if (key == 's' || key == 'S') {
        map.panBy(0,-PAN_RATE);
    } else if (key == 'd' || key == 'D') {
        map.panBy(-PAN_RATE,0);
    } 
}

void draw() {
  if (keyPressed) {
     keyHandler(); 
  }
  map.draw();
}

