Water[] series;
int sizex = 600;
int sizey = 600;

float xmar = .1*sizex;
float ymar = .1*sizex;
float maxX = sizex - 2*xmar; 
float maxY = sizey/2 - 2*ymar;

int len ;
float yscale;
float xscale = maxX/3;
float xtmp;
float ytmp;
float maxsf;
float maxgh;

void setup(){
//FallCreek, Mass, Oregon, Schuylkill
series = getData("Schuylkill.txt");
len = series.length;
maxsf = 1.5*series[0].streamFlow;
maxgh = 2*series[0].gaugeHeight;
yscale = maxY/maxsf;

makeSemiLog(sizex,sizey,maxsf,maxgh);

//Fill graph 1
translate(0,-height/2); 
println(maxY);
strokeWeight(2);
fill(255);
for (int i = 0; i < len;i = i+1){
  xtmp = log(series[i].ri)/log(10)*xscale;
  ytmp = maxY - ((series[i].streamFlow))*yscale;
  println(xtmp);
  point(xtmp,ytmp);
}
//Fill Graph 2
translate(0,height/2); 
xscale = maxX/maxsf;
yscale = maxY/maxgh;
for (int i = 0; i < len;i = i+1){
  xtmp = ((series[i].streamFlow))*xscale;
  ytmp = maxY - ((series[i].gaugeHeight))*yscale;
  println(xtmp);
  point(xtmp,ytmp);
}
}
