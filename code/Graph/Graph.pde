
String[] sites = { "01363556", "04233286", "04234000", "01474500", "14191000" };
String[] names = { "Esopus Creek", "Six Mile Creek", "Fall Creek", "Schuylkill River", "Willamette River" };
int index = 0;
XYChart chart1, chart2;
PFont font;
Water[] data;

Pair[] correlate(Water[] data) {
  Pair[] correlation = new Pair[data.length];
  for (int i = 0; i < data.length; i++) {
     correlation[i] = new Pair(data[i].discharge, data[i].gage);
  } 
  return correlation;
}

Pair[] intervals(Water[] data) {
  Pair[] intervals = new Pair[data.length];
  sort(data);
  for(int m = 0; m < data.length; m++) {
    intervals[m] = new Pair((data.length + 1.0) / m, data[m].discharge);
  }
  sort(intervals);
  return intervals;
}

void process_data() {
  Pair[] correlation = correlate(data);
  Pair[] intervals = intervals(data);
  chart1 = plot(correlation, false);
  chart2 = plot(intervals, true);
}

void mouseClicked() {  
  if(index < sites.length - 1) {
    String site = sites[++index];
    data = parse(site);
    process_data();
  }
}

void draw() {
  if (index >= 0 && index < sites.length) {
    draw_charts();
  }
}  
