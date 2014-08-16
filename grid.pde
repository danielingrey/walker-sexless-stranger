class Grid {
  boolean bright;
  //Organism org;
  //Food fd;
  int posX;
  int posY;
  color colour;
  color[] colBright = {#000000, #0000CD,#CD0000,#CD00CD,#00CD00,#00CDCD,#CDCD00,#CDCDCD};
  color[] colDark = {#000000, #0000FF,#FF0000,#FF00FF,#00FF00,#00FFFF,#FFFF00,#FFFFFF};
  
    
  Grid(boolean b, int px, int py) {
    bright = b;
    posX = px;
    posY = py;    
    if(bright) colour = colBright[0];
    println(hex(colBright[0]));
    if(!bright) colour = colDark[0];     
  }
  
  void setColour(int c) {
    
    if(bright) colour = colBright[c];
    else colour = colDark[c];
  }
  
  color getColour() {
    return colour;
  }
  
 /* color getColour(int cNum, int aNum) {
    if(bright) return colB1[cNum];
    else if(!bright) return colB2[cNum];
    return 0;    
  }
  /*Grid(boolean b, Food f) {
    bright = b;
    fd = f;
  }
  
  Grid(boolean b) {
    bright = b;
  }*/
  
  boolean getBright() {
    return bright;
  }
  
  /*Organism getOrg() {
    return org;
  }
  
  Food getFood() {
    return fd;
  }*/
  
  
}
