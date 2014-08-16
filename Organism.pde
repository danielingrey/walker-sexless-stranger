class Organism {
//PImage photo;  
  int[] genotype; //genotype
  String sex; //organism gender
  int reproAge; //age organism can achieve reproduction
  boolean canRepro; //can the organism reproduce?
  int deathAge; //age organism will die of natural causes
  int aggro; //agressiveness of organism
  int speed; //how fast organism can travel
  color colour; //colour of organism
  int hunger; //level of hunger
  int posX; //x position on grid
  int posY; //x position on grid
  color[][] shape; //pixel data for display
  int id;
  
  Organism(int[] genes, int px, int py, boolean bright, int _id) {    
    String[] genders = {"male", "female", "asexual"};
    color[] colB1 = {#0000CD,#CD0000,#CD00CD,#00CD00,#00CDCD,#CDCD00,#CDCDCD};
    color[] colB2 = {#0000FF,#FF0000,#FF00FF,#00FF00,#00FFFF,#FFFF00,#FFFFFF};   
    genotype = genes;
    sex = genders[genotype[0]];
    if(!bright) colour = colB1[genotype[1]];
    else colour = colB2[genotype[1]];
    reproAge = genotype[2];
    if (genotype[3] == 1) canRepro = true;
    else canRepro = false;
    deathAge = genotype[4];
    aggro = genotype[5];
    speed = genotype[6];
    posX = px;
    posY = py;
    id = _id; 
    //pixelData();   
  }
  
  void setColour(color c, int x, int y) {       
    colour = c;
  }  
  
  /*void pixelData() {
     photo = loadImage(sex + ".png");
     for(int i = 0; i < 8; i++) {
       for(int j = 0; j < 8; j++) {
         if(hex(photo.pixels[i]) == "FFFFFFFF") shape[i][j] = colour;
         else shape[i][j] = #000000;
       }
     }
  }*/
  
  boolean attack(Organism org) {
    return aggro > 5;
  }
  
  boolean runAway(Organism org) {
    return aggro < 1;
  }
  
  color getColour(){
    return colour;
  }
  
  String getSex() {
    return sex;
  }
  
  void step() {
    
  }
  
  String toString() {
    return str(id);
  }
  
  color[][] getShape() {
    return shape;
  }
  
  /*boolean canStep() {
    
  }*/
  
  /*void eat(Food fd) {
    hunger += fd.getNourishment();
    deathAge += fd.getToxicity();
    aggro += fd.getPsychoactive("aggression");
    speed += fd.getPsychoactive("stimulant");
  }
  
  public void step(int dirX, int dirY) {
    posX += dirX;
    posY += dirY;
  }*/
}

