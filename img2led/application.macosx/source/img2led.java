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
Serial ardy;

public void setup() {
  //size(640,480);
  // Make a new instance of a PImage by loading an image file
  img = loadImage("ieeeskate.jpg");

  ardy = new Serial(this, "/dev/tty.usbmodem641", 9600);
  lastTime = millis();

}

public void draw() {
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

      println(PApplet.parseInt(r));
      println(PApplet.parseInt(g));
      println(PApplet.parseInt(b));
      //delay(50);
      ardy.write(PApplet.parseInt(r));
      ardy.write(PApplet.parseInt(g));
      ardy.write(PApplet.parseInt(b));
      //myDelay(1);
//      if (loc > 1) {
//      pixels[loc+1] =  color(r,g,b);
//      }
    }
  }
  updatePixels();
  if (firstRun == 1) {
    for (int y = 1; y < height; y = y + 2) {
    for (int x = 1; x < width; x = x + 2) {
      int loc = x + y*width;
      
      float r = red(img.pixels[loc]);
      float g = green(img.pixels[loc]);
      float b = blue(img.pixels[loc]);
      
      pixels[loc] = color(r,g,b);
      //arduino.write(65);
      
    }
    }
  }
    
}

public void myDelay(int ms)
{
   try
  {    
    Thread.sleep(ms);
  }
  catch(Exception e){}
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
