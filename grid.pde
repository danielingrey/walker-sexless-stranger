//Holds information for Grid locations, Parent of Organism and Food classes

class Grid {
  boolean bright; //is this grid object bright or not bright
  //(x,y) coordinates of object in main grid 
  int posX; 
  int posY; 
  color colour; //colour of this object
  color[] colBright = {#000000, #0000CD,#CD0000,#CD00CD,#00CD00,#00CDCD,#CDCD00,#CDCDCD}; //bright colour palette
  color[] colDark = {#000000, #0000FF,#FF0000,#FF00FF,#00FF00,#00FFFF,#FFFF00,#FFFFFF};  //not bright colour palette
  
  //constructor
  //inputs: bright/not bright variable, (x,y) coordinates  
  Grid(boolean b, int px, int py) {
    bright = b;
    posX = px;
    posY = py;
    //choose colour palette based on bright variable      
    if(bright) colour = colBright[0];   
    if(!bright) colour = colDark[0];     
  }
  
  //set the colour of the object
  //input: integer corresponding to array location in colour palette
  void setColour(int c) {    
    if(bright) colour = colBright[c];
    else colour = colDark[c];
  }
  
  color getColour() {
    return colour;
  }  
  
  boolean getBright() {
    return bright;
  }  
  
  void setXY(int x, int y) {
    posX = x;
    posY = y;
  }
  
}
