// Declaring a variable of type PImage
PImage img;  

void setup() {
  size(960,717);
  // Make a new instance of a PImage by loading an image file
  img = loadImage("ieeeskate.jpg");
}

void draw() {
  loadPixels(); 
  // Since we are going to access the image's pixels too  
  img.loadPixels(); 
  for (int y = 0; y < height; y = y + 4) {
    for (int x = 0; x < width; x = x + 4) {
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
        pixels[loc+width] =  color(r,g,b);
        for (int widthMultiplier = 1; widthMultiplier <  4; widthMultiplier++) {
          pixels[loc+width*widthMultiplier] =  color(r,g,b);
          pixels[loc+width*widthMultiplier+1] =  color(r,g,b);
          pixels[loc+width*widthMultiplier+2] =  color(r,g,b);
          pixels[loc+width*widthMultiplier+3] =  color(r,g,b);
          pixels[loc+width*widthMultiplier+4] =  color(r,g,b);
        }
      pixels[loc+1] =  color(r,g,b);
      pixels[loc+2] =  color(r,g,b);
      pixels[loc+3] =  color(r,g,b);
      pixels[loc+4] =  color(r,g,b);
      }

      
//      if (loc > 1) {
//      pixels[loc+1] =  color(r,g,b);
//      }
    }
  }
  updatePixels();
}
