import processing.serial.*;


// Declaring a variable of type PImage
PImage img;  
int sum;
int firstRun = 1;
int iteration = 1;
long lastTime = 0;
long startTime;
long duration;
// RGB values
int[] ledValues = new int[300];
byte[] byteledValues = new byte[300];
Serial ardy;

void setup() {
  size(200,200);
  grid = new Cell[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Initialize each object
      grid[i][j] = new Cell(i*20,j*20,20,20,i+j,cellColor);
      cellColor = cellColor + 6;
    }
    //cellColor = cellColor 0;
  }
  // Make a new instance of a PImage by loading an image file
  img = loadImage("cat10x10.jpeg");

  ardy = new Serial(this, "/dev/tty.usbmodem411", 235400);
  //lastTime = millis();
  processPixels();
  transmitPixels();
}

void draw() {
  loadPixels(); 
  // Since we are going to access the image's pixels too  
  img.loadPixels(); 
  updatePixels();
  background(0);
  // The counter variables i and j are also the column and row numbers and 
  // are used as arguments to the constructor for each object in the grid.  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Oscillate and display each object
      grid[i][j].oscillate();
      //grid[i][j].pond();
      grid[i][j].display();
      
    }
  } 
}

void processPixels()
{
    loadPixels(); 
  // Since we are going to access the image's pixels too  
  img.loadPixels(); 
  for (int y = 1; y < 10; y = y + 1) {
    for (int x = 1; x < 10; x = x + 1) {
      int loc = (x + y*10)*3;
      float r = 0;
      float g = 0;
      float b = 0;
      // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
      if (loc < 100) {
        r = red(img.pixels[loc]);
        g = green(img.pixels[loc]);
        b = blue(img.pixels[loc]);
      }
      float rr, gg, bb;
      rr = 101;
      gg = 101;
      bb = 101;
      if (loc+2 <= 100)
      { 
        rr = red(img.pixels[loc+2]);
        gg = green(img.pixels[loc+2]);
        bb = blue(img.pixels[loc+2]);
      }
      
      // Image Processing would go here
      // If we were to change the RGB values, we would do it here, before setting the pixel in the display window.
      
      // Set the display pixel to the image pixel
      if (loc < 100) {
      pixels[loc] =  color(r,g,b);
      }
      if (loc+2 <= 100) 
      {
        pixels[loc+2] =  color(rr,gg,bb);
      }
      ledValues[loc] = int(r);
      ledValues[loc+1] = int(g);
      ledValues[loc+2] = int(b);
      if (loc+1 < 10) {
        ledValues[loc+2] = int(rr);
        ledValues[loc+1+2] = int(gg);
        ledValues[loc+2+2] = int(bb);
      }
      byteledValues[loc] = byte(round(ledValues[loc]/2^31)/8);
      byteledValues[loc+1] = byte(round(ledValues[loc+1]/2^31)/8);
      byteledValues[loc+2] = byte(round(ledValues[loc+2]/2^31)/8);
      //println(byte(byte(floor(ledValues[x][y][0]/2^31)/8 << 4) + byte(floor(ledValues[x+1][y][0]/2^31)/8)));
//      if (loc+width < pixels.length) {      
//        sum = pixels[loc]*(1/8) + pixels[loc+1]*(1/9) + pixels[loc-1]*(1/9) + pixels[loc+width]*(1/9) + pixels[loc+width+1]*(1/9) + pixels[loc+width-1]*(1/9) + pixels[loc-width]*(1/9) + pixels[loc-width+1]*(1/9) + pixels[loc-width-1]*(1/9);
//        pixels[loc] = color(r,g,b);
//      }

//      println("r"+int(r));
//      println("g"+int(g));
//      println("b"+int(b));
      //delay(50);
      
      

      

      //myDelay(1);
//      if (loc > 1) {
//      pixels[loc+1] =  color(r,g,b);
//      }
    }
  }
  transmitPixels();

}

void transmitPixels()
{
    startTime = millis();
    for (int y = 1; y < 10; y = y + 1) {
    for (int x = 1; x < 10; x = x + 1) {
      //ardy.write(byteledValues[x][y][0]);
      //ardy.write(byteledValues[x][y][1]);
      //ardy.write(byteledValues[x][y][2]);
    }}
    //ardy.write(byteledValues);
    println(byteledValues);
    duration = millis() - startTime;
    println(duration);
}


void myDelay(int ms)
{
   try
  {    
    Thread.sleep(ms);
  }
  catch(Exception e){}
}
// 2D Array of objects
Cell[][] grid;

// Number of columns and rows in the grid
int cols = 10;
int rows = 10;
int cellColor = 1;



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

