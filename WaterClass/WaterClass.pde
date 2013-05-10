//This Class Describes One Year's worth of Data

class Water {
int year;
int month;
int day;
float streamFlow;
float gaugeHeight;
int rank;
float ri;
float probability;

Water(int year_, int month_, int day_, 
          float streamFlow_, float gaugeHeight_){
          year = year_;
          month = month_;
          streamFlow = streamFlow_;
          gaugeHeight = gaugeHeight_;
          rank = 0;
          ri = 0;       
          probability = 0;   
          }
}
