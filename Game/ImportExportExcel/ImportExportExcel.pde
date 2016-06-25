import java.io.*;
import org.apache.poi.ss.usermodel.Sheet;

/* This program allows rivers to be designed into excel. 
*For a given excel file, this prints an array of all river coordintes, to be copied directly into Game.pde */


String[][] saving;
String str;
void setup() {
  // import excel data to a 2d string:
  saving = importExcel("/Users/Zhang/Documents/Cornell 2016 Summer/h2ogame/Game/River designs.xlsx");
  printForestCoords();
  println(""); println(""); println(""); 
  printRiverCoords();
  println(""); println(""); println(""); 
  printFactoryCoords();
  println(""); println(""); println(""); 
  printFarmCoords();
  println(""); println(""); println(""); 
  printHouseCoords();
}
void draw() {
   
}

void keyPressed() {
  //export a 2d string to an excel file:
  // exportExcel(a 2D string, a new filepath/name);
  exportExcel(saving, "PLACE FILEPATH & FILE NAME HERE");
}

int countRiverTiles() {
  int count = 0;
  for (int x=0; x<30; x++) {
    for (int y=0; y<30; y++) {
      if (saving[x][y].equals("r")) {
        count++; 
      }
    }
  }
  return count;
}

int countForestTiles() {
  int count = 0;
  for (int x=0; x<30; x++) {
    for (int y=0; y<30; y++) {
      if (saving[x][y].equals("f")) {
        count++; 
      }
    }
  }
  return count;
}

int countFactoryTiles() {
  int count = 0;
  for (int x=0; x<30; x++) {
    for (int y=0; y<30; y++) {
      if (saving[x][y].equals("fc")) {
        count++; 
      }
    }
  }
  return count;
}

int countFarmTiles() {
  int count = 0;
  for (int x=0; x<30; x++) {
    for (int y=0; y<30; y++) {
      if (saving[x][y].equals("fm")) {
        count++; 
      }
    }
  }
  return count;
}

int countHouseTiles() {
  int count = 0;
  for (int x=0; x<30; x++) {
    for (int y=0; y<30; y++) {
      if (saving[x][y].equals("hs")) {
        count++; 
      }
    }
  }
  return count;
}


void printRiverCoords() {
  int[][] rCoords = new int[countRiverTiles()][2];
  int i = 0;
  for (int y=0; y<30; y++) {
    for (int x=0; x<30; x++) {
      if (saving[x][y].equals("r")) {
        rCoords[i][0] = y;
        rCoords[i][1] = x;
        i++;
      }
    }
  }
  int count = countRiverTiles();
  println("Printing river tiles:  #"+count);
  print("{");
  for (int x = 0; x<count; x++) {
    int[] c = rCoords[x];
    if (x == count-1) {      //the last coordinate. Do not print a trailing comma.
      print(" {", c[0], ",", c[1],"}");
    } else {
      print(" {", c[0], ",", c[1],"}, ");
    }
  }
  print(" }");
}

void printForestCoords() {
  int[][] rCoords = new int[countForestTiles()][2];
  int i = 0;
  for (int y=0; y<30; y++) {
    for (int x=0; x<30; x++) {
      if (saving[x][y].equals("f")) {
        rCoords[i][0] = y;
        rCoords[i][1] = x;
        i++;
      }
    }
  }
  int count = countForestTiles();
  println("Printing forest tiles:  #"+count);
  print("{");
  for (int x = 0; x<count; x++) {
    int[] c = rCoords[x];
    if (x == count-1) {      //the last coordinate. Do not print a trailing comma.
      print(" {", c[0], ",", c[1],"}");
    } else {
      print(" {", c[0], ",", c[1],"}, ");
    }
  }
  print(" }");
}

void printFactoryCoords() {
  int[][] rCoords = new int[countFactoryTiles()][2];
  int i = 0;
  for (int y=0; y<30; y++) {
    for (int x=0; x<30; x++) {
      if (saving[x][y].equals("fc")) {
        rCoords[i][0] = y;
        rCoords[i][1] = x;
        i++;
      }
    }
  }
  int count = countFactoryTiles();
  println("Printing factory tiles:  #"+count);
  print("{");
  for (int x = 0; x<count; x++) {
    int[] c = rCoords[x];
    if (x == count-1) {      //the last coordinate. Do not print a trailing comma.
      print(" {", c[0], ",", c[1],"}");
    } else {
      print(" {", c[0], ",", c[1],"}, ");
    }
  }
  print(" }");
}

void printFarmCoords() {
  int[][] rCoords = new int[countFarmTiles()][2];
  int i = 0;
  for (int y=0; y<30; y++) {
    for (int x=0; x<30; x++) {
      if (saving[x][y].equals("fm")) {
        rCoords[i][0] = y;
        rCoords[i][1] = x;
        i++;
      }
    }
  }
  int count = countFarmTiles();
  println("Printing farm tiles:  #"+count);
  print("{");
  for (int x = 0; x<count; x++) {
    int[] c = rCoords[x];
    if (x == count-1) {      //the last coordinate. Do not print a trailing comma.
      print(" {", c[0], ",", c[1],"}");
    } else {
      print(" {", c[0], ",", c[1],"}, ");
    }
  }
  print(" }");
}

void printHouseCoords() {
  int[][] rCoords = new int[countHouseTiles()][2];
  int i = 0;
  for (int y=0; y<30; y++) {
    for (int x=0; x<30; x++) {
      if (saving[x][y].equals("hs")) {
        rCoords[i][0] = y;
        rCoords[i][1] = x;
        i++;
      }
    }
  }
  int count = countHouseTiles();
  println("Printing house tiles:  #"+count);
  print("{");
  for (int x = 0; x<count; x++) {
    int[] c = rCoords[x];
    if (x == count-1) {      //the last coordinate. Do not print a trailing comma.
      print(" {", c[0], ",", c[1],"}");
    } else {
      print(" {", c[0], ",", c[1],"}, ");
    }
  }
  print(" }");
}