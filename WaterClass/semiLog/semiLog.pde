//This Draws a set of axes with a logarithmic scale on the x axis and linear scale on y


float xmarg;
float ymarg;
float ys;


void makeSemiLog(int sizex, int sizey,float maxsf,float maxgh){
    size(sizex,sizey);
    textAlign(CENTER);
    background(255,255,255); 
    xmarg = .1*sizex ;
    ymarg = .1*sizex;
    translate(xmarg,ymarg); 
    float maxX = width - 2*xmarg; 
    float maxY = height/2 - 2*ymarg;
    
   

// GRAPH 1    
    rect(0,0,maxX,maxY); 
    textSize(30);
    fill(0);
    text("Stream Flow vs. Rank Index",width/2-xmarg,-ymarg/4);
    textSize(16);
    text("Rank Index",width/2-xmarg,maxY+ymarg/2);
    
    translate(-xmarg/2,maxY/2);
    rotate(-PI/2.0);
    text("Stream Flow (cfs)",0,0);
    rotate(PI/2.0);
    translate(xmarg/2,-maxY/2);
    
    
    //Label x-axis
    for (int i = 0; i < 3; i = i +1){
      fill(0);
      textSize(12);
      text(str(pow(10,i)),log(pow(10,i))/log(10)*maxX/3,maxY+10);
    for (int j = 1; j < 10; j = j + 1){
     float xpt = log(j*pow(10,i))/log(10)*maxX/3;
     stroke(0,50);
     line(xpt,0,xpt,maxY);
     stroke(0,255);
   }
  }
  
  //label y-axis
   ys = maxY/maxsf;
   textSize(12);
   for (int i = 0;i < maxsf; i = i + 1000){    
    text(str(i),-17,maxY - i*ys);    
  }
  
  //Graph 2
  translate(0,height/2); 
   float minY2 = height/2 - .5*ymarg;
   float maxY2 = height - ymarg;
   fill(255);
  rect(0,0,maxX,maxY); 
  
  //label y-axis
  fill(0);
    textSize(30);
    text("Gauge Height vs. Stream Flow",width/2-xmarg,-ymarg/4);
    textSize(16);
    text("Stream Flow",width/2-xmarg,maxY+ymarg/2);
    
    translate(-xmarg/2,maxY/2);
    rotate(-PI/2.0);
    text("Gauge Height",0,0);
    rotate(PI/2.0);
    translate(xmarg/2,-maxY/2);
  
     float xs = maxX/maxsf;
   textSize(12);
   for (int i = 0;i < maxsf; i = i + 1000){    
    text(str(i), i*xs,maxY+10);
    stroke(0,50);
    line(i*xs,0,i*xs,maxY);  
  stroke(0,255);  
  }
  
   ys = maxY/maxgh;
   textSize(12);
   for (int i = 0;i < maxgh; i = i + 2){    
    text(str(i),-17,maxY - i*ys);    
  }
  
     
  
  
  
}
