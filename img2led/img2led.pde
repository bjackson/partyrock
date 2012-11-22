import processing.serial.*;



// Declaring a variable of type PImage
PImage img;  
int sum;
int firstRun = 1;
int iteration = 1;
long lastTime = 0;
Serial ardy;

void setup() {
  size(640,480);
  // Make a new instance of a PImage by loading an image file
  img = loadImage("ieeeskate.jpg");

  ardy = new Serial(this, "/dev/tty.usbmodem641", 9600);
  lastTime = millis();

}

void draw() {
  loadPixels(); 
  // Since we are going to access the image's pixels too  
  img.loadPixels(); 

  for (int y = 1; y < height; y = y + 2) {
    for (int x = 1; x < width; x = x + 2) {
      int loc = x + y*width;
      
      // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
      float r = red(img.pixels[loc]);
      float g = green(img.pixels[loc]);
      float b = blue(img.pixels[loc]);
      
      // Image Processing would go here
      // If we were to change the RGB values, we would do it here, before setting the pixel in the display window.
      
      // Set the display pixel to the image pixel
      pixels[loc] =  color(r,g,b); 
      if (loc+width < pixels.length) {      
        sum = pixels[loc]*(1/8) + pixels[loc+1]*(1/9) + pixels[loc-1]*(1/9) + pixels[loc+width]*(1/9) + pixels[loc+width+1]*(1/9) + pixels[loc+width-1]*(1/9) + pixels[loc-width]*(1/9) + pixels[loc-width+1]*(1/9) + pixels[loc-width-1]*(1/9);
        pixels[sum] = color(r,g,b);
      }

      println(int(r));
      println(int(g));
      println(int(b));
      //delay(50);
      
      ardy.write("r" + int(r));
      ardy.write("g" + int(g));
      ardy.write("b" + int(b));
      //myDelay(1);
//      if (loc > 1) {
//      pixels[loc+1] =  color(r,g,b);
//      }
    }
  }
  updatePixels();
    
}

void myDelay(int ms)
{
   try
  {    
    Thread.sleep(ms);
  }
  catch(Exception e){}
}
