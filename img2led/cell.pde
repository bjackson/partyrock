// A Cell object
class Cell {
  // A cell object knows about its location in the grid as well as its size with the variables x,y,w,h.
  float x,y;   // x,y location
  float w,h;   // width and height
  float angle; // angle for oscillating brightness
  float cellColor = 128;
  byte colorDirection = 1;
  float r;
  float g;
  float b;

  // Cell Constructor
  Cell(float tempX, float tempY, float tempW, float tempH, float tempAngle, float tempColor) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    angle = tempAngle;
    cellColor = tempColor;
  } 
  
  int redValue() {
    r = cellColor*random(1,1.4);
    if (r >= 255) {
      colorDirection = 0;
    } if (cellColor <= 2) {
      colorDirection = 1;
    }
    
    if (colorDirection == 1) {
      r = cellColor*random(1,1.4);
    } else if (colorDirection == 0) {
      r = cellColor*.909;
    }
    return int(r);
  }
  
  int greenValue() {
    g = cellColor*random(1,1.4);
    if (cellColor >= 255) {
      colorDirection = 0;
    } if (cellColor <= 2) {
      colorDirection = 1;
    }
    
    if (colorDirection == 1) {
      g = cellColor*random(1,1.4);
    } else if (colorDirection == 0) {
      cellColor = cellColor*.909;
    }
    return int(g);
  }
  
  int blueValue() {
    b = cellColor*random(1,1.4);
    if (cellColor >= 255) {
      colorDirection = 0;
    } if (cellColor <= 2) {
      colorDirection = 1;
    }
    
    if (colorDirection == 1) {
      b = cellColor*1.01;
    } else if (colorDirection == 0) {
      b = cellColor*.909;
    }
    return int(b);
  }
  
  // Oscillation means increase angle
  void oscillate() {
    angle += 0.05;
    cellColor = cellColor*1.101;
    if (cellColor >= 255) {
      colorDirection = 0;
    } if (cellColor <= 25) {
      colorDirection = 1;
      cellColor = 25*random(1,7);
    }
    
    if (colorDirection == 1) {
      cellColor = cellColor*1.07;
      cellColor++;
    } else if (colorDirection == 0) {
      cellColor = cellColor*.909;
      cellColor--;
    }
    }
  
  void pond() {
   x = x + y + 1;
   y = y - y + 1;
  }

  void display() {
    stroke(255);
    // Color calculated using sine wave
    if (cellColor == 0)
    r = cellColor*random(1,1.1);
    g = cellColor*random(1,1.1);
    b = cellColor*random(1,1.1);
    
//    if (r >= 240) {
//      r = r/2;
//    }
//
//    if (g >= 240) {
//      g = g/2;
//    }
//    
//    if (b >= 240) {
//      b = b/2;
//    }
//    
//    if (r < 20) {
//      r = r*4;
//    }
//
//    if (g < 20) {
//      g = g*4;
//    }
//    
//    if (b < 20) {
//      b = b*4;
//    }

    fill(127+127*sin(angle),r,g,b);
    //fill(127+127*sin(angle),cellColor*1.1,cellColor*1.15,cellColor*1.2);

    //println(cellColor);
    
    rect(x,y,w,h); 
  }
  

}
