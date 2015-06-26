
ImageMarker mark;
UnfoldingMap map, map1, map2;
ZoomLevelUI zoom, zoom1, zoom2;

final String site = "04234000";

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
}

void keyPressed() {
    if (key == '1') { 
        map = map1;
        zoom = zoom1;
    } else if (key == '2') {
        map = map2;  
        zoom = zoom2; 
    }
}

void draw() {
  map.draw();
}

