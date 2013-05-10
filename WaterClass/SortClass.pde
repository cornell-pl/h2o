//This class allows one to use Arrays.sort(waterData,new Sort()); 
//To Sort an array of Water objects
//Based On method used here: http://www.openprocessing.org/sketch/50922
import java.util.Comparator;
class Sort implements Comparator{
  Sort(){
  }
  
  int compare(Object object1, Object object2){
    Water r1 = (Water) object1;
    Water r2 = (Water) object2;
    Float v1 = (Float) r1.streamFlow; //negated these to flip order
    Float v2 = (Float) r2.streamFlow;
    v1 = -v1;
    v2 = -v2;
    return v1.compareTo(v2);
  }
}
