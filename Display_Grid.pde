class DisplayGrid {
  PImage photo;
  //PImage female;
  //PImage asexual;
 // PImage food;
  //PImage empty;
  color[][] display;  
 // color[] bright = {#000000,#0000CD,#CD0000,#CD00CD,#00CD00,#00CDCD,#CDCD00,#CDCDCD};
  //color[] dark = {#000000,#0000FF,#FF0000,#FF00FF,#00FF00,#00FFFF,#FFFF00,#FFFFFF};
  int[][] male;
  int[][] female;
  int[][] asexual;
  int[][] food;
  int[][] empty;  
    
  DisplayGrid() {
    //maleI = loadImage("male.png");
   // female = loadImage("female.png");
   // asexual = loadImage("asexual.png");
   // food = loadImage("food.png");
   // empty = loadImage("empty.png");
    display = new color[256][192];   
    male = new int[8][8];
    female = new int[8][8];
    asexual = new int[8][8];
    food = new int[8][8];
    empty = new int[8][8];    
    male = loadPixelData("male");
    female = loadPixelData("female");
    asexual = loadPixelData("asexual");
    food = loadPixelData("food");
   // empty = loadPixelData("empty");
    /*for(int i = 0; i < 8; i++) { //may not need
       for(int j = 0; j < 8; j++) {
         empty[i][j] = 0;
       }
    }*/
  }
  
  int[][] loadPixelData(String filename) {
    int[][] shape = new int[8][8];
     photo = loadImage(filename + ".png");
     photo.loadPixels();
    //if(filename.equals("male")) {
       for(int i = 0; i < 8; i++) {
       for(int j = 0; j < 8; j++) {
         //println(maleI.pixels[(j*8) + i]);
         //int pix = photo.pixels[(j*8) +1];
         if(photo.pixels[(j*8) + i] == -1) shape[i][j] = 1;
         else shape[i][j] = 0;
         //println(shape[i][j]);
       }
     }
     //}
          
     //photo = loadImage(name + ".png");
     //photo = "" + filename + ".png";
     /*for(int i = 0; i < 8; i++) {
       for(int j = 0; j < 8; j++) {
         //println(hex(photo.pixels[(j*8) + i]));
         if(hex(photo.pixels[(j*8) + i]).equals("FFFFFFFF")) shape[i][j] = 1;
         else shape[i][j] = 0;
         //println(shape[i][j]);
       }
     }*/
     return shape;
  }
  
  void updateGridPos(String tile, color col, int px, int py) {
    int x = 0;
    //println(py);
    //println(py+8);
    for(int i = px; i < px+8; i++) {
      int y = 0;      
      for(int j = py; j < py+8; j++){        
        //println(y);
        if(tile == "male") {
          display[i][j] = col * male[x][y];
          //println(male[x][y]);
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
  
  void refreshDisplay() {
    for(int i = 0; i < 256; i++) {
      for(int j = 0; j < 192; j++) {
        //println(hex(display[i][j]));
        stroke(display[i][j]);
        
        fill(display[i][j]);
        //rect(i*4, j*4, 4, 4);
        rect(i*2, j*2, 2, 2);
      }
    }
  }
  
}
