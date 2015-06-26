import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.ui.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.marker.AbstractMarker;
import de.fhpotsdam.unfolding.providers.Google;
import de.fhpotsdam.unfolding.providers.Microsoft;
import processing.core.PConstants;
import processing.core.PGraphics;
import processing.core.PImage;

public class ImageMarker extends AbstractMarker {

  PImage img;

  public ImageMarker(Location location, PImage img) {
    super(location);
    this.img = img;
  }

  @Override
  public void draw(PGraphics pg, float x, float y) {
    pg.pushStyle();
    pg.imageMode(PConstants.CORNER);
    // The image is drawn in object coordinates, i.e. the marker's origin (0,0) is at its geo-location.
    pg.image(img, x - 11, y - 37);
    pg.popStyle();
  }

  @Override
  protected boolean isInside(float checkX, float checkY, float x, float y) {
    return checkX > x && checkX < x + img.width && checkY > y && checkY < y + img.height;
  }

}

float coord(String w) {
  int x = int(w);
  float s = float(x % 100) / 3600f;
  float m = float((x / 100) % 100) / 60f;
  float d = float(x / 10000);
  return (d + m + s);    
}

Location location(String site) {
  String url = "http://waterdata.usgs.gov/nwis/inventory/?site_no=" + site + "&agency_cd=USGS&format=rdb";
  String[] lines = loadStrings(url);
  for(String line : lines) {
    if(line.startsWith("USGS")) {
      String[] fields = split(line, "\t");
      return new Location(coord(fields[6]), -1f * coord(fields[7]));
    }
  }
  return new Location(0f,0f);  
}

UnfoldingMap google_map() {
   return new UnfoldingMap(this, new Google.GoogleTerrainProvider()); 
}
UnfoldingMap ms_map() {
   return new UnfoldingMap(this, new Microsoft.AerialProvider());
}

ZoomLevelUI zoom_ui(UnfoldingMap map) {
  return new ZoomLevelUI(this, map);
}

ImageMarker marker(Location loc) {
  return new ImageMarker(loc, loadImage("http://www.google.com/mapfiles/marker.png", "png"));
}
  
