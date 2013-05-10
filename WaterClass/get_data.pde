//This method uploads water data from a text file in the same folder
import java.util.Arrays;

Water[] getData(String site){
  String data[] = loadStrings(site);
  String year[];
  int len = data.length;
  Water[] waterData = new Water[len];
  
  for (int i = 0; i < len;i = i + 1){
     String[] d =  split(data[i],"\t");   
     waterData[i] = new Water(int(d[0]),int(d[1]),int(d[2]),
                          float(d[3]),float(d[4]));   
}

  Arrays.sort(waterData,new Sort()); 
  
  for (int i = 0; i< len;i = i+1){   
   waterData[i].rank = i + 1;
   waterData[i].ri = len/(i+1.);
   waterData[i].probability = (i+1.)/len;
  }
  return waterData;
}
