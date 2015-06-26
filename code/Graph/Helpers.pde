import java.util.Arrays;
import java.lang.Math;
import org.gicentre.utils.stat.XYChart;

/* Data structure to represent a pair of floating-point numbers */
class Pair implements Comparable {
  float x1;
  float x2;
  
  Pair(float x1, float x2) {
    this.x1 = x1;
    this.x2 = x2;
  } 
  
  int compareTo(Object other) {
     Pair that = (Pair) other;
     return ((Float) that.x1).compareTo((Float) this.x1);
   }

  
  String toString() {
    return ("(" + x1 + "," + x2 + ")"); 
  }
}

/* Data structure to represent a year of peak water data */ 
class Water implements Comparable {
   int year;
   int month;
   int day;
   int discharge;
   float gage;
   
   Water(int year, int month, int day, int discharge, float gage) {
      this.year = year;
      this.month = month;
      this.day = day;
      this.discharge = discharge;
      this.gage = gage;
   }
   
   int compareTo(Object other) {
     Water that = (Water) other;
     return ((Integer) that.discharge).compareTo((Integer) this.discharge);
   }
   
   String toString() {
      return (year + "-" + month + "-" + day + "\t" + discharge + "\t" + gage);
   }
}

/* Parser that downloads the data for site from the USGS website, and converts it 
   into an array of Water objects */
Water[] parse(String site) {
   String url = "http://nwis.waterdata.usgs.gov/nwis/peak?site_no=" + site + "&agency_cd=USGS&format=rdb";
   String[] lines = loadStrings(url);
   int i = 0;
   for(String line : lines) {
     if(line.startsWith("USGS")) {
         i++;
      } 
    }

   Water[] rows = new Water[i];
   i = 0;

   for(String line : lines) {
     if(line.startsWith("USGS")) {
       String[] fields = split(line, "\t");
       String[] dates = split(fields[2], "-");
       rows[i++] = new Water(int(dates[0]), int(dates[1]), int(dates[2]), int(fields[4]), float(fields[6]));
     }  
   }
   return rows;
}

/* Helper function to calculates a linear fit using least-squares.
   That is, find coefficients a and b for the equation y = a + b x, 
   and return them in a pair.
   Hint see: http://en.wikipedia.org/wiki/Simple_linear_regression.
*/
Pair linearLeastSquares(Pair[] data) {
  float n = data.length;
  float s1 = 0;
  float s2 = 0;
  float s3 = 0;
  float s4 = 0;
  for (int i = 0; i < data.length; i++) {
     s1 += data[i].x1 * data[i].x2;
     s2 += data[i].x1;
     s3 += data[i].x2; 
     s4 += data[i].x1 * data[i].x1;
  }
  float b = (s1 - (s2 * s3 / n)) / (s4 - s4 / n);
  float a = (s3 / n) - b * (s2 / n);
  return new Pair(a,b);  
}

/* Calculate a logarithmic fit using least-squares.
   That is, find coefficients a and b for the equation y = a + b * ln x, 
   and return them in a pair.
   Hint: See http://mathworld.wolfram.com/LeastSquaresFittingLogarithmic.html
*/
Pair logarithmicLeastSquares(Pair[] data) {
   float n = data.length;
   float s1 = 0;
   float s2 = 0;
   float s3 = 0;
   float s4 = 0;
   for (int i = 0; i < data.length; i++) {
     float xi = data[i].x1;
     float yi = data[i].x2;
     s1 += yi * log(xi);
     s2 += yi;
     s3 += log(xi);
     s4 += log(xi) * log(xi);
   }
   float b = (n * s1 - s2 * s3) / (n * s4 - s4);
   float a = (s2 - b * s3) / n;
   return new Pair(a,b);
}



/* Helper function to plot a chart from an array of Pairs, and 
   a boolean variable controlling whether the X-axis is logarithmic. */
XYChart plot(Pair[] data, boolean semiLog) {
  XYChart chart = new XYChart(this);
  float[] xdata = new float[data.length];
  float[] ydata = new float[data.length];
  for (int i = 0; i < data.length; i++) {
    xdata[i] = data[i].x1;       
    ydata[i] = data[i].x2;       
  }

  chart.setPointColour(color(180,50,50,255));
  chart.setPointSize(8);
  chart.showXAxis(true);
  chart.setXFormat("#");
  if (semiLog) {
    chart.setLogX(semiLog);
    chart.setMinX(1.01);
    chart.setMaxX(100);      
  }
  chart.showYAxis(true);
  chart.setYFormat("#");
  chart.setMinY(0);
  chart.setData(xdata, ydata);
  return chart;
}

void sort(Object[] a) {
    Arrays.sort(a); 
}

void setup() {
  size(1000, 500);
  fill(128);
  index = 0;
  font = createFont("Helvetica", 14);
  textFont(font, 14);
  data = parse(sites[0]);
  process_data();
}

void draw_charts() {
    background(255);
    textFont(font, 18);
    text(names[index] + " (USGS Site #" + sites[index] + ")", 400, 50);
    textFont(font, 14);

    text("Measurements", 225, 100);
    rotate(-PI/2.0);
    text("Gage Height (ft)", -300, 25);
    rotate(PI/2.0);
    text("Discharge (cfs)", 225, 425);
    chart1.draw(50,100,400,300);
    
    text("Flood Frequency", 725, 100);
    rotate(-PI/2.0);
    text("Discharge (cfs)", -300, 500);
    rotate(PI/2.0);
    text("Recurrence (years)", 725, 425);
    chart2.draw(550,100,425,300);
}

