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
int[][][] ledValues = new int[128][128][3];
byte[][][] byteledValues = new byte[128][128][3];
Serial ardy;

void setup() {
  size(128,128);
  // Make a new instance of a PImage by loading an image file
  img = loadImage("cat.jpeg");

  ardy = new Serial(this, "/dev/tty.usbmodem411", 57600);
  lastTime = millis();
  processPixels();
  transmitPixels();
}

void draw() {
  loadPixels(); 
  // Since we are going to access the image's pixels too  
  img.loadPixels(); 
  updatePixels();
    
}

void processPixels()
{
    loadPixels(); 
  // Since we are going to access the image's pixels too  
  img.loadPixels(); 
  for (int y = 1; y < height; y = y + 4) {
    for (int x = 1; x < width; x = x + 4) {
      int loc = x + y*width;
      
      // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
      float r = red(img.pixels[loc]);
      float g = green(img.pixels[loc]);
      float b = blue(img.pixels[loc]);
      
      float rr = red(img.pixels[loc+2]);
      float gg = green(img.pixels[loc+2]);
      float bb = blue(img.pixels[loc+2]);
      
      
      // Image Processing would go here
      // If we were to change the RGB values, we would do it here, before setting the pixel in the display window.
      
      // Set the display pixel to the image pixel
      pixels[loc] =  color(r,g,b);
      if (loc+2 < pixels.length) {
      pixels[loc+2] =  color(rr,gg,bb);
      }
      ledValues[x][y][0] = int(r);
      ledValues[x][y][1] = int(g);
      ledValues[x][y][2] = int(b);
      if (loc+2 < pixels.length) {
        ledValues[x+2][y][0] = int(rr);
        ledValues[x+2][y][1] = int(gg);
        ledValues[x+2][y][2] = int(bb);
      }
      byteledValues[x][y][0] = byte(floor(ledValues[x][y][0]/2^31)/8 << 4 + floor(ledValues[x+1][y][0]/2^31)/8);
      byteledValues[x][y][1] = byte(floor(ledValues[x][y][1]/2^31)/8 << 4 + floor(ledValues[x+1][y][1]/2^31)/8);
      byteledValues[x][y][2] = byte(floor(ledValues[x][y][2]/2^31)/8 << 4 + floor(ledValues[x+1][y][2]/2^31)/8);
      println(byte(byte(floor(ledValues[x][y][0]/2^31)/8 << 4) + byte(floor(ledValues[x+1][y][0]/2^31)/8)));
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
    for (int y = 1; y < height; y = y + 4) {
    for (int x = 1; x < width; x = x + 4) {
      //ardy.write(byteledValues[x][y][0]);
      //ardy.write(byteledValues[x][y][1]);
      //println(byteledValues[x][y][2]);
    }}
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
