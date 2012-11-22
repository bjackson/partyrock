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
int[][][] ledValues;
Serial ardy;

void setup() {
  size(128,128);
  // Make a new instance of a PImage by loading an image file
  img = loadImage("stop.jpeg");

  ardy = new Serial(this, "/dev/tty.usbmodem641", 57600);
  lastTime = millis();
  transmitPixels();
}

void draw() {
  loadPixels(); 
  // Since we are going to access the image's pixels too  
  img.loadPixels(); 
  updatePixels();
    
}

void transmitPixels()
{
    loadPixels(); 
  // Since we are going to access the image's pixels too  
  img.loadPixels(); 
  startTime = millis();
  for (int y = 1; y < height; y = y + 1) {
    for (int x = 1; x < width; x = x + 1) {
      int loc = x + y*width;
      
      // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
      float r = red(img.pixels[loc]);
      float g = green(img.pixels[loc]);
      float b = blue(img.pixels[loc]);
      
      // Image Processing would go here
      // If we were to change the RGB values, we would do it here, before setting the pixel in the display window.
      
      // Set the display pixel to the image pixel
      pixels[loc] =  color(r,g,b); 
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
