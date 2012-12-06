// A Cell object
class Cell {
  // A cell object knows about its location in the grid as well as its size with the variables x,y,w,h.
  float x,y;   // x,y location
  float w,h;   // width and height
  float angle; // angle for oscillating brightness
  float cellColor;
  byte colorDirection = 1;

  // Cell Constructor
  Cell(float tempX, float tempY, float tempW, float tempH, float tempAngle, float tempColor) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    angle = tempAngle;
    cellColor = tempColor;
    
  } 
  
  // Oscillation means increase angle
  void oscillate() {
    angle += 0.1;
    cellColor = cellColor*1.1;
        if (cellColor >= 255) {
      colorDirection = 0;
    } if (cellColor <= 2) {
      colorDirection = 1;
    }
    
    if (colorDirection == 1) {
      cellColor = cellColor*1.01;
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
    fill(127+127*sin(angle),cellColor*random(1,1.3),cellColor*random(1,1.3),cellColor*random(1,1.3));
    //fill(127+127*sin(angle),cellColor*1.1,cellColor*1.15,cellColor*1.2);

    //println(cellColor);
    
    rect(x,y,w,h); 
  }
}
