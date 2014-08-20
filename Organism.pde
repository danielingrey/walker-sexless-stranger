//holds data for organism objects
//Organism is a child of the Grid class
//organism objects are the phenotypes based on the genotypes inputted to their constructor

class Organism extends Grid {
  int age = 0; //age of organism
  int[] genotype; //genotype
  String sex; //organism gender
  String[] genders = {"male", "female", "asexual"}; //genders
  int reproAge; //age organism can reach reproduction (not implemented yet..)  
  boolean canRepro; //can the organism reproduce?
  int deathAge; //age organism will die of natural causes
  int aggro; //agression of organism  
  boolean stepped = false; //has the organism taken its turn yet
  
  //constructor
  //inputs: genotype, (x,y) coordinates, bright or not bright variable
  Organism(int[] genes, int px, int py, boolean bright) {  
    super(bright, px, py); //call parent class and set variables
    super.setColour(genes[1]+1); //call parent class and set colour based on corresponding genotype array location. 1 is added to the number as 0 is black on both colour palettes       
    genotype = genes;
    sex = genders[genotype[0]]; //apply gender type based on genotype   
    reproAge = genotype[2]; //set reproduction age (not implemented as of yet...)
    if (genotype[3] == 1) canRepro = true; //set if the organism can reproduce
    else canRepro = false;
    deathAge = genotype[4]; //set death age
    aggro = genotype[5];   //set aggression
  }   
 
  //checks if an organism can attack another organism
  //input: current organism
  //output: true if its aggression is high enough, false otherwise
  boolean attack(Organism org) {
    return aggro > 8;
  } 
  
  public String getSex() {
    return sex;
  }
  
  void incAge() {
    age++;
  }
  
  int getAge() {
    return age;
  }
  
  int getDeathAge() {
    return deathAge;
  }
  
  boolean getStepped() {
    return stepped;
  }
  
  void setStepped(boolean b) {
    stepped = b;
  }
  
  //eat food. A piece of food effects an organism's deathAge both positively and negatively
  //Input: food
  void eat(Food fd) {
    deathAge += fd.getNourishment();
    deathAge += fd.getToxicity();   
  }
  
  int getX() {
    return posX;
  }
  
  int getY() {
    return posY;
  }
  
  int[] getGenes() {
    return genotype;
  }  
  
  boolean canReproduce() {
    return canRepro;
  }
}

