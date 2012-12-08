import processing.core.*; 
import processing.data.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class img2led extends PApplet {




// Declaring a variable of type PImage
PImage img;  
int sum;
int firstRun = 1;
int iteration = 1;
long lastTime = 0;
long startTime;
long duration;
List gridList = new ArrayList();
int[] gridArray = new int[192];
byte[] gridByteArray = new byte[192];
// RGB values
int[] ledValues = new int[300];
byte[] byteledValues = new byte[300];
Serial ardy;

public void setup() {
  size(400,400);
  grid = new Cell[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Initialize each object
      grid[i][j] = new Cell(i*50,j*50,50,50,i+j,cellColor);
      cellColor = cellColor + 6;
    }
    //cellColor = cellColor 0;
  }
    for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // Oscillate and display each object
      grid[i][j].oscillate();
      //grid[i][j].pond();
      grid[i][j].display();
      
    }
  } 
  
  for(int i=0; i < cols; i++) {
    for(int j=0; j < rows; j++) {
        gridList.add(min((grid[i][j]).redValue(), 255));
        gridList.add(min((grid[i][j]).greenValue(), 255));
        gridList.add(min((grid[i][j]).blueValue(), 255));
    }
  }
  
    for(int i=0; i < cols; i++) {
    for(int j=0; j < rows; j++) {
        gridList.add(min((grid[i][j]).redValue(), 255));
        gridList.add(min((grid[i][j]).greenValue(), 255));
        gridList.add(min((grid[i][j]).blueValue(), 255));
    }
  }

  gridArray = toIntArray(gridList);
  for(int i=0; i < rows*cols; i++)
  {
    gridByteArray[i] = PApplet.parseByte(gridArray[i]);
  }
  
  //gridArray = toIntArray(grid);

  // Make a new instance of a PImage by loading an image file
  img = loadImage("cat10x10.jpeg");

  ardy = new Serial(this, "/dev/tty.usbmodem411", 115200);
  //lastTime = millis();
  processPixels();
  transmitPixels();
}

public void draw() {
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

public void processPixels()
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
      ledValues[loc] = PApplet.parseInt(r);
      ledValues[loc+1] = PApplet.parseInt(g);
      ledValues[loc+2] = PApplet.parseInt(b);
      if (loc+1 < 10) {
        ledValues[loc+2] = PApplet.parseInt(rr);
        ledValues[loc+1+2] = PApplet.parseInt(gg);
        ledValues[loc+2+2] = PApplet.parseInt(bb);
      }
      byteledValues[loc] = PApplet.parseByte(round(ledValues[loc]/2^31)/8);
      byteledValues[loc+1] = PApplet.parseByte(round(ledValues[loc+1]/2^31)/8);
      byteledValues[loc+2] = PApplet.parseByte(round(ledValues[loc+2]/2^31)/8);
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

public void transmitPixels()
{
    startTime = millis();
    for (int y = 1; y < 10; y = y + 1) {
    for (int x = 1; x < 10; x = x + 1) {
      //ardy.write(byteledValues[x][y][0]);
      //ardy.write(byteledValues[x][y][1]);
      //ardy.write(byteledValues[x][y][2]);
    }}
    //ardy.write(byteledValues);
    //println(gridArray);
    ardy.write(gridByteArray);
    duration = millis() - startTime;
    println(duration);
}


public void myDelay(int ms)
{
   try
  {    
    Thread.sleep(ms);
  }
  catch(Exception e){}
}

public static int[] toIntArray(List<Integer> integerList) {
  int[] intArray = new int[integerList.size()];
  for (int i = 0; i < integerList.size(); i++) {
    intArray[i] = PApplet.parseInt(integerList.get(i));
  }
    return intArray;
}



// 2D Array of objects
Cell[][] grid;

// Number of columns and rows in the grid
int cols = 8;
int rows = 8;
int cellColor = 1;



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
  
  public int redValue() {
    r = cellColor*random(1,1.4f);
    if (r >= 255) {
      colorDirection = 0;
    } if (cellColor <= 2) {
      colorDirection = 1;
    }
    
    if (colorDirection == 1) {
      r = cellColor*random(1,1.4f);
    } else if (colorDirection == 0) {
      r = cellColor*.909f;
    }
    return PApplet.parseInt(r);
  }
  
  public int greenValue() {
    g = cellColor*random(1,1.4f);
    if (cellColor >= 255) {
      colorDirection = 0;
    } if (cellColor <= 2) {
      colorDirection = 1;
    }
    
    if (colorDirection == 1) {
      g = cellColor*random(1,1.4f);
    } else if (colorDirection == 0) {
      cellColor = cellColor*.909f;
    }
    return PApplet.parseInt(g);
  }
  
  public int blueValue() {
    b = cellColor*random(1,1.4f);
    if (cellColor >= 255) {
      colorDirection = 0;
    } if (cellColor <= 2) {
      colorDirection = 1;
    }
    
    if (colorDirection == 1) {
      b = cellColor*1.01f;
    } else if (colorDirection == 0) {
      b = cellColor*.909f;
    }
    return PApplet.parseInt(b);
  }
  
  // Oscillation means increase angle
  public void oscillate() {
    angle += 0.05f;
    cellColor = cellColor*1.101f;
    if (cellColor >= 255) {
      colorDirection = 0;
    } if (cellColor <= 25) {
      colorDirection = 1;
      cellColor = 25*random(1,7);
    }
    
    if (colorDirection == 1) {
      cellColor = cellColor*1.07f;
      cellColor++;
    } else if (colorDirection == 0) {
      cellColor = cellColor*.909f;
      cellColor--;
    }
    }
  
  public void pond() {
   x = x + y + 1;
   y = y - y + 1;
  }

  public void display() {
    stroke(255);
    // Color calculated using sine wave
    if (cellColor == 0)
    r = cellColor*random(1,1.1f);
    g = cellColor*random(1,1.1f);
    b = cellColor*random(1,1.1f);
    
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "img2led" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
