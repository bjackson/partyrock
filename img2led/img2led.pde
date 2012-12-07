import processing.serial.*;


// Declaring a variable of type PImage
PImage img;  
int sum;
int firstRun = 1;
int iteration = 1;
long lastTime = 0;
long startTime;
long duration;
List gridList = new ArrayList();
int[] gridArray;
// RGB values
int[] ledValues = new int[300];
byte[] byteledValues = new byte[300];
Serial ardy;

void setup() {
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
        gridList.add((grid[i][j]).redValue());
        gridList.add((grid[i][j]).greenValue());
        gridList.add((grid[i][j]).blueValue());
    }
  }

  //gridArray = toIntArray(grid);

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
    //println(byteledValues);
    print(gridList);
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




