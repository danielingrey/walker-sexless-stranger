//This class handles the display of graphics to the screen

class DisplayGrid {
  PImage photo; //variable to hold image file input 
  color[][] display; //holds pixel data for display
  //these variables hold visual data for organism phenotypes
  int[][] male; 
  int[][] female;
  int[][] asexual;
  
  int[][] food; //visual data for food  
  int[][] empty; //visual data for empty Grid locations  
  
  //constructor  
  DisplayGrid() {
    display = new color[256][192]; //initialise pixel display   
    //initialise visual data variables
    male = new int[8][8];
    female = new int[8][8];
    asexual = new int[8][8];
    food = new int[8][8];
    empty = new int[8][8];
    //convert image data from png files to array variables     
    male = loadPixelData("male");
    female = loadPixelData("female");
    asexual = loadPixelData("asexual");
    food = loadPixelData("food");
    empty = loadPixelData("empty");    
  }
  
  //takes input from .png files and converts them to integer arrays
  //Input: start of the file name minus extension
  //Output: array representation of inputted image  
  int[][] loadPixelData(String filename) {
     int[][] shape = new int[8][8];     
     photo = loadImage(filename + ".png"); //load image
     //loop over every pixel of the image
     for(int i = 0; i < 8; i++) {
       for(int j = 0; j < 8; j++) {
         //println(hex(photo.pixels[(j*8) + i]));
         if(hex(photo.pixels[(j*8) + i]).equals("FFFFFFFF")) shape[i][j] = 1; //if the current pixel is white set the corresponding int array location to 1
         else shape[i][j] = 0; //if it's not white set it to zero         
       }
     }
     return shape;
  }
  
  //updates the specified position within the Display grid
  //Inputs: the type of object as a string, the colour of the object, the object's (x,y) 
  void updateGridPos(String tile, color col, int px, int py) {
    int x = 0;    
    //for each pixel to display, multiply the colour by the corresponding variable held in the type's array (this will be either 0 or 1) 
    for(int i = px; i < px+8; i++) {
      int y = 0;      
      for(int j = py; j < py+8; j++){       
        if(tile == "male") {
          display[i][j] = col * male[x][y];           
        } else if(tile =="female") {
          display[i][j] = col * female[x][y];
        } else if(tile =="asexual") {
          display[i][j] = col * asexual[x][y];
        } else if(tile =="food") {
          display[i][j] = col * food[x][y];
        } else if(tile =="empty") {
          display[i][j] = col * empty[x][y];          
        }
       y++; 
      }
     x++; 
    }
  }
  
  //refreshes the whole display
  void refreshDisplay() {
    for(int i = 0; i < 256; i++) {
      for(int j = 0; j < 192; j++) {        
        stroke(display[i][j]); //use stroke and fill for rect to use to colour area of the GUI       
        fill(display[i][j]);
        rect(i*4, j*4, 4, 4); //multiply by 4 so that the pixels fill the screen. This also gives a blocky "Spectrum like" output
      }
    }
  }
  
}
