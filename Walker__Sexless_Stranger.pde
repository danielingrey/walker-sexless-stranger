//Walker, Sexless Stranger
//A small ecosystem running on a "sort of" ZX Spectrum emulator
//Author: Daniel Ingrey

DisplayGrid disp; //used for GUI display

int popSize = 200; //initial starting population
int foodSize = 50; //initial starting number of food

//the following variables are used for an organism's genotype
int gNum = 3; //number of genders
int cNum = 7; //number of colours
int raNum = 8; //max reproduction age
int crNum = 2; //can organism reproduce
int daNum = 100; //max death age
int aNum = 16; //max genetic aggression of organism

Grid[][] g; //array of Grid objects. A grid object can be an organism, food or empty

float xoff = 0.0; //x offset used for perlin noise


void setup() {
  size(256*4, 192*4); //ZX Spectrum displays were 256 / 192 pixels. As this appears too small on modern machines it is upscaled by 4 times to 1024*768
  frameRate(17);  //17 frames per second is one of the frame rates ZX's ran at  
  g = new Grid[32][24];    
  disp = new DisplayGrid();
  
  //create perlin noise "terrain". This sets Grid objects to either bright or not bright based on the perlin noise output. 
  for (int x = 0; x < 32; x++) {    
    float yoff = 0.0;
    for (int y = 0; y < 24; y++) {
      float hm = noise(xoff,yoff);        
      if (hm < 0.5) {        
        g[x][y] = new Grid(false, x, y);
      } else {        
        g[x][y] = new Grid(true, x, y);
      }
      yoff += 0.09; //an offset of 0.09 works well to create large enough bright or not bright areas for seperate ecosystems
    }
    xoff += 0.09;
  }
  
  populate(); //fill grid with organisms and food before running the program

  disp.refreshDisplay(); //refresh the display window
}

//draw is run every frame, the actions of every organism are carried out before each new frame
void draw() {
   //this loop goes over each grid position to look for organisms and on finding one will give them instructions  
   for(int x = 0; x < 32; x++) {
    for(int y = 0; y < 24; y++) {
      if(g[x][y] instanceof Organism) { //organism found at (x,x)        
        if( ((Organism)g[x][y]).getAge() >= ((Organism)g[x][y]).getDeathAge() ) { //if the organism has reached or surpassed, as can happen if eating toxic food, its death age, it is removed from the Grid 
          g[x][y] = new Grid(g[x][y].getBright(), x, y); //replace organism with empty Grid
          disp.updateGridPos("empty", g[x][y].getColour(), x*8, y*8); //update corresponding position for the display GUI
        } else { //organism isn't dead yet        
        ((Organism)g[x][y]).incAge(); //increment its age
        step((Organism)g[x][y]); //perform instruction
        }
      } else if (!(g[x][y] instanceof Organism || g[x][y] instanceof Food) && foodSize < 50) { //if a Grid position is empty and there are less than 50 pieces of food, there is a chance new food will be placed  
        float r = random(1);
        if(r < 0.05) { //chance of food being placed in position
          g[x][y] = new Food(x,y,g[x][y].getBright()); //place food
          disp.updateGridPos("food", g[x][y].getColour(), x*8, y*8);
          foodSize++;
        }
      }       
    }    
  }
  
 disp.refreshDisplay(); //refresh display after performing instructions
 
 //search grid for organisms, reset their "stepped" variable so they can perform an instruction next frame
 for(int x = 0; x < 32; x++) {
    for(int y = 0; y < 24; y++) {
      if(g[x][y] instanceof Organism) {
        ((Organism)g[x][y]).setStepped(false);       
      }        
    }
  }  
}

//create a starting population of organisms and food
public void populate() {   
  ArrayList<Position> pos = new ArrayList<Position>(); 
  for (int i = 0; i < 32; i++) {
    for (int j = 0; j < 24; j++) {
      pos.add(new Position(i, j)); // add a new position object to the array list for each (x,y) on the grid 
    }
  } 
 
  //the following places initial population of organisms in starting positions
  int posX; //x starting coordinate
  int posY; //y starting coordinate 
  for (int i = 0; i < popSize; i++) {        
    int[] genes = new int[6]; //create a variabe to hold each organism's genotype
    for (int j = 0; j < 6; j++) {      
      genes = setGenotype(j, genes); //create genotype
    }    
    float rand = random(0, pos.size());
    Position p = pos.remove(int(rand)); //randomly remove a Position object from the ArrayList. The remove() function ensures multiple organisms can't pick the same (x,y)
    posX = p.getX(); 
    posY = p.getY();    

    g[posX][posY] = (Organism) new Organism(genes, posX, posY, g[posX][posY].getBright()); //create and place a new organism (phenotype) on the Grid based on the genotype variable genes
   
    String sex =  ((Organism)g[posX][posY]).getSex();    
    disp.updateGridPos(sex, g[posX][posY].getColour(), posX*8, posY*8); //update display GUI for new organism
   
  }
  
  //next food is placed
  for (int i = 0; i < foodSize; i++) {
    float rand = random(0, pos.size()); //same ArrayList, variable pos, is used so food isn't placed in an (x,y) containing an organism
    Position p = pos.remove(int(rand));
    posX = p.getX();
    posY = p.getY();
    g[posX][posY] = (Food) new Food(posX, posY, g[posX][posY].getBright());   
    disp.updateGridPos("food", g[posX][posY].getColour(), posX*8, posY*8);
  }
  
}

//this function is called within for loops to randomly generate genotypes
//Inputs: current index, i, from for loop
//empty array to hold genotype
//Output: filled array holding genotype
int[] setGenotype(int i, int[] genes) {
      int max = 0;
      if (i==0) max = gNum;
      if (i==1) max = cNum;
      if (i==2) max = raNum;
      if (i==3) max = crNum;
      if (i==4) max = daNum;
      if (i==5) max = aNum;     
      float rand = random(0, max);
      genes[i] = int(rand);
      return genes;
}

//this funtion chooses a neighbouring Grid location for the organism to move to
//Input: an Organism object
void step(Organism org) {    
    if(!org.getStepped()) { //checks the organism hasn't made a step this frame        
      ArrayList<Position> pos = new ArrayList<Position>(); //create Position ArrayList of possible Grid locations to move to
      //get current (x,y) of organism
      int posX = org.getX(); 
      int posY = org.getY();     
      for(int x = posX-1; x <= posX+1; x++) {
        for(int y = posY-1; y <= posY+1; y++) {
          if(x == posX && y == posY) { 
            //this is the current location the organism is in, as we want a step to be performed to a neighbour Grid location we don't add it to the ArrayList
            //so do nothing
          } else {  
            pos.add(new Position(x,y)); //add all neighbouring Grid locations to the ArrayList
            
          }
        }
      } 
        
      float rand = random(0, pos.size());       
      Position p = pos.remove(int(rand)); //choose a random neighbouring Grid location to move to
      if(withinBounds(p.getX(),p.getY())) performStep(org, p.getX(),p.getY()); //check it's not outside the bounds of the array then perform an instruction
    }     
}

//this function carries out the possible instructions for an organism
//inputs: an Organism object
//Target coordinates x and y 
void performStep(Organism o, int x, int y){  
  o.setStepped(true); //set the stepped variable to true, so organism can't step again this frame
  //organisms can't move from bright Grid locations to not bright, and vice versa
  if(g[x][y].getBright() == o.getBright()) {        
    if(g[x][y] instanceof Organism) {
       //if the target location contains an Organism that has the same gender as the one moving, or the moving organism is male or female and the target is asexual (or vice versa), it might kill it 
       if( ((Organism)g[x][y]).getSex().equals(o.getSex()) || ( ((Organism) g[x][y]).getSex().equals("male") && o.getSex().equals("asexual")) || ( ((Organism) g[x][y]).getSex().equals("female") && o.getSex().equals("asexual")) || 
                 ( ((Organism) g[x][y]).getSex().equals("asexual") && o.getSex().equals("male")) || ( ((Organism) g[x][y]).getSex().equals("asexual") && o.getSex().equals("female"))) {
          //check if organisms aggression is high enough to attack         
          if(o.attack((Organism)g[x][y])) {           
            g[x][y] = (Organism) o; //move attacking organism to target location, "killing" the Organism there by replacing it on the grid
            g[o.getX()][o.getY()] = new Grid(o.getBright(), o.getX(), o.getY()); //create an empty grid where the organism has moved from
            disp.updateGridPos(((Organism)g[x][y]).getSex(), ((Organism)g[x][y]).getColour(), x*8, y*8); //update display
            disp.updateGridPos("empty", g[o.getX()][o.getY()].getColour(), o.getX()*8, o.getY()*8);
            ((Organism)g[x][y]).setXY(x,y); //set the organism's new (x,y)
           }
      //check if the target location has an organism of the opposite gender, and that both are able to reproduce     
      } else if( ( (((Organism)g[x][y]).getSex().equals("male") && o.getSex().equals("female")) || (((Organism)g[x][y]).getSex().equals("female") && o.getSex().equals("male")) ) && (((Organism)g[x][y]).canReproduce() && o.canReproduce()) ) {        
        int[] childGenes = reproduce(o, ((Organism)g[x][y])); //create new genes based on the two parent genes
        Position p = birthSpot(o.getX(), o.getY(), o.getBright()); //pick a neighbouring Grid location to "give birth" to the new organism
        g[p.getX()][p.getY()] = new Organism(childGenes, p.getX(), p.getY(), o.getBright()); //create child organism in position        
        disp.updateGridPos(((Organism)g[p.getX()][p.getY()]).getSex(), ((Organism)g[p.getX()][p.getY()]).getColour(), ((Organism)g[p.getX()][p.getY()]).getX()*8, ((Organism)g[p.getX()][p.getY()]).getY()*8); //update display        
      }
    } else if( g[x][y] instanceof Food) { //if target location contains food eat it      
      o.eat((Food)g[x][y]); //eat the food
      g[x][y] = (Organism) o; //move Organism to food's original location 
      g[o.getX()][o.getY()] = new Grid(o.getBright(), o.getX(), o.getY()); //create empty Grid where the organism has moved from
      disp.updateGridPos(((Organism)g[x][y]).getSex(), ((Organism)g[x][y]).getColour(), x*8, y*8); //update display
      disp.updateGridPos("empty", g[o.getX()][o.getY()].getColour(), o.getX()*8, o.getY()*8);
      ((Organism)g[x][y]).setXY(x,y); //set the organism's new (x,y)
      foodSize--; //decrement food count on the grid     
    } else if( g[x][y] instanceof Grid) { //if the target location is empty      
      if(o.getSex().equals("asexual")) { //if the organism is asexual there is a random chance of it reproducing         
        float r = random(1);
        if( r < 0.05 && o.getSex().equals("asexual") ) {     
          int[] childGenes = selfReproduce(o); //get child genes from organism
          Position p = birthSpot(o.getX(), o.getY(), o.getBright()); //pick a birth position
          g[p.getX()][p.getY()] = new Organism(childGenes, p.getX(), p.getY(), o.getBright()); //place child organism
          disp.updateGridPos(((Organism)g[p.getX()][p.getY()]).getSex(), ((Organism)g[p.getX()][p.getY()]).getColour(), ((Organism)g[p.getX()][p.getY()]).getX()*8, ((Organism)g[p.getX()][p.getY()]).getY()*8); //update display
        }
      }
      //move to empty grid position, update display     
      g[x][y] = (Organism) o; 
      g[((Organism)g[x][y]).getX()][((Organism)g[x][y]).getY()] = new Grid(o.getBright(), o.getX(), o.getY());      
      disp.updateGridPos("empty", g[o.getX()][o.getY()].getColour(), o.getX()*8, o.getY()*8);
      disp.updateGridPos(((Organism)g[x][y]).getSex(), ((Organism)g[x][y]).getColour(), x*8, y*8);
      ((Organism)g[x][y]).setXY(x,y); 
      
      }   
    }
  }

//function for self reproduction of asexual organisms
//input: the asexual organism
//output: child genotype
int[] selfReproduce(Organism org) {
   //int max = 0;
  int[] genes = org.getGenes(); //copy genes from parent to child 
  for(int i =0; i < 6; i++) { //loop through the genotype array and mutate a gene if it falls within mutation probability bounds       
      float mutate = random(1); //random number between 0 and 1
      if(mutate < 0.05) { //if random number is less than 0.05 mutate this gene
        genes = setGenotype(i, genes);      
      }
    }
    return genes;
}

//function for male and female reproduction
//inputs: male organism
//female organism
//output: child genotype
int[] reproduce(Organism o1, Organism o2) {    
    int[] parent1Genes = o1.getGenes();
    int[] parent2Genes = o2.getGenes();
    int[] genes = new int[6]; //array to hold child genotype
    //int max = 0;     
    
    for(int i =0; i < 6; i++) {
      float r = random(0, 2); //for each gene in genotype randomly pick between one of the parents and copy that gene to child genotype    
      int gender = int(r);      
      if(gender == 0) {       
        genes[i] = parent1Genes[i];        
      } else if (gender == 1) {        
        genes[i] = parent2Genes[i];        
      }
      //mutate gene if within bounds
      float mutate = random(1); //random number between 0 and 1
      if(mutate < 0.05) { //if random number is less than 0.05 mutate this gene
        genes = setGenotype(i, genes);      
      }     
    }
    return genes;    
}

//choose a neighbouring position on the grid to "give birth" to a child organism
//input: parent organism's x and y coordinates (if two parent reproduction the coordinates are the Organism who is performing the step)
//boolean holding the Grid's bright or not bright value
//output: Position of where to place child organism
Position birthSpot(int pX, int pY, boolean br) {
  boolean birthed = false;
  ArrayList<Position> pos = new ArrayList<Position>();
  Position p = new Position(0,0);
  for(int x = pX-1; x <= pX+1; x++) {
      for(int y = pY-1; y <= pY+1; y++) {
          if(x == pX && y == pY) {
            //do nothing
          } else {          
            pos.add(new Position(x,y)); //add all neighbouring Grid positions to the array           
          }
        }
      }  
  while(!birthed && pos.size() > 0) { //while a suitable birthplace hasn't been found and there are still positions available in the ArrayList
     p = pos.remove(0); //remove position from the ArrayList
     if(withinBounds(p.getX(),p.getY())) {
       if( !(g[p.getX()][p.getY()] instanceof Organism) && g[p.getX()][p.getY()].getBright() == br ) { //if there is no organism in the Grid location and it holds the same bright value place child organism there    
         birthed = true;
       }
     }
  }
  if(birthed) { //if a suitable spot was found return the Position object
    return p;
  } else { //if no spot was found return the (x,y) coordinates of the parent (this will kill/replace the parent organism)
    p = new Position(pX,pY);
    return p;
  }
}

//check a position is within the array bounds
//input: x and y coordinates
//output: true if within bounds, false otherwise
boolean withinBounds(int x, int y) {
  return x >= 0 && x < 32 && y >= 0 && y < 24;
}
    
  


