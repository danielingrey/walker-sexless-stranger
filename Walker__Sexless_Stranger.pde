DisplayGrid disp;
//ArrayList<Organism> orgs; //holds organisms
//ArrayList<Food> food;
//ArrayList<Grid> grid;
//PImage img;
int popSize = 200; //initial starting population
int foodSize = 50; 
int gNum = 3; //number of genders
int cNum = 7; //number of colours
int raNum = 8; //max reproduction age
int crNum = 2; //can organism reproduce
int daNum = 100; //max death age
int aNum = 16; //max genetic aggression of organism
int sNum = 8; //max genetic speed of organism
/*color[] colBright0 = {
  #000000, #0000CD, #CD0000, #CD00CD, #00CD00, #00CDCD, #CDCD00, #CDCDCD
}; //palette dark
color[] colBright1 = {
  #000000, #0000FF, #FF0000, #FF00FF, #00FF00, #00FFFF, #FFFF00, #FFFFFF
};*/ //palette light
//boolean[][] gridBright; // light or dark
Grid[][] g;
//int id = 0; //identity of organism
float xoff = 0.0;
int w = 32;
int count = 0;

void setup() {
  //size(1024, 768);
   orientation(LANDSCAPE);
  //frameRate(17);  //17
  //orgs = new ArrayList<Organism>();
 // food = new ArrayList<Food>();
  //grid = new ArrayList<Grid>();
  g = new Grid[32][24];
  for (int i = 0; i < 32; i++) {
    for (int j = 0; j < 24; j++) {
    }
  }
  //gridBright = new boolean[32][24]; //256/8,192/8
  //img = loadImage("male.png");
  disp = new DisplayGrid();
  //grid = new Grid[32][24];  
  for (int x = 0; x < 32; x++) {    
    float yoff = 0.0;
    for (int y = 0; y < 24; y++) {  
      float hm = map(noise(xoff, yoff), 0, 1, 0, 255);      
      //int col;
      if (hm < 128) {
        //col = 0; //colBright0[0]
        //gridBright[x][y] = false;
        g[x][y] = new Grid(false, x, y);
      } else {
        //col =  255; //colBright1[0]
        //gridBright[x][y] = true;
        g[x][y] = new Grid(true, x, y);
      }      
      //fill(color(col));
      //stroke(255);      
      //rect(x*w, y*w, w, w);
      yoff += 0.09;
    }
    xoff += 0.09;
  }
 // for (int i = 0; i < 24; i++) {
   // for (int j = 0; j < 32; j++) {
      //println(gridBright[j][i]);
    //}
 // }
  
  populate();

 // for (int i = 0; i < 32; i++) {
   // for (int j = 0; j < 24; j++) {
      //println(gridBright[i][j]);
    //}
 // }
  disp.refreshDisplay();
  
  
   
}

void draw() {
   count = 0;
   for(int x = 0; x < 32; x++) {
    for(int y = 0; y < 24; y++) {
      if(g[x][y] instanceof Organism) {
        if( ((Organism)g[x][y]).getAge() >= ((Organism)g[x][y]).getDeathAge() ) {
          g[x][y] = new Grid(g[x][y].getBright(), x, y);
          disp.updateGridPos("empty", g[x][y].getColour(), x*8, y*8);
        } else {        
        ((Organism)g[x][y]).incAge();
        step((Organism)g[x][y]);
        }
      } else if (!(g[x][y] instanceof Organism || g[x][y] instanceof Food) && foodSize < 50) {
        float r = random(1);
        if(r < 0.05) {
          g[x][y] = new Food(x,y,g[x][y].getBright());
          disp.updateGridPos("food", g[x][y].getColour(), x*8, y*8);
          foodSize++;
        }
      }       
    }
    //println(foodSize);
  }
   
 disp.refreshDisplay();
 for(int x = 0; x < 32; x++) {
    for(int y = 0; y < 24; y++) {
      if(g[x][y] instanceof Organism) {
        ((Organism)g[x][y]).setStepped(false);
        count++;
      }        
    }
  }
  //println(count);
}

public void populate() {
  boolean bright;  
  ArrayList<Position> pos = new ArrayList<Position>();  
  for (int i = 0; i < 32; i++) {
    for (int j = 0; j < 24; j++) {
      pos.add(new Position(i, j));
    }
  }  
  //Organism[] startingPop = new Organism[popSize];
  int posX;
  int posY;
  int max = 0;  
  for (int i = 0; i < popSize; i++) {        
    int[] genes = new int[7]; 
    for (int j = 0; j < 7; j++) {
      if (j==0) max = gNum;
      if (j==1) max = cNum;
      if (j==2) max = raNum;
      if (j==3) max = crNum;
      if (j==4) max = daNum;
      if (j==5) max = aNum;
      if (j==6) max = sNum;
      float rand = random(0, max);
      genes[j] = int(rand);
    }
    //genes[0] = 2;
    float rand = random(0, pos.size());
    Position p = pos.remove(int(rand));
    posX = p.getX();
    posY = p.getY();
    //if(gridBright[posX][posY]) bright = true;
    //else bright = false;
    //if(grid[posX][posY].getBright()) bright = true;
    //else bright = false;
    //println(pos.size());
    //println("organism start posX: " + posX + " posY: " + posY);
    //println("sex: " + genes[0] + " col: " + genes[1] + " reproage:" + genes[2] + " canrepro:" + genes[3] + " deathage: " + genes[4] + " aggr: " + genes[5] + " speed: " + genes[6]);      
    //orgs.add(new Organism(genes, posX, posY, gridBright[posX][posY], id));

    g[posX][posY] = (Organism) new Organism(genes, posX, posY, g[posX][posY].getBright());
    //grid[posX][posY] = new Grid(bright, orgs.get(i));
    
    //println(g[posX][posY]);
    //println(orgs.get(i));
    String sex = new String();
    if(g[posX][posY] instanceof Organism) {    
      sex =  ((Organism)g[posX][posY]).getSex();
    }
    disp.updateGridPos(sex, g[posX][posY].getColour(), posX*8, posY*8);
    //disp.updateGridPos(orgs.get(i).getSex(),orgs.get(i).getColour(),posX*8,posY*8);
    //startingPop[i] = org;
  }
  for (int i = 0; i < foodSize; i++) {
    float rand = random(0, pos.size());
    Position p = pos.remove(int(rand));
    posX = p.getX();
    posY = p.getY();
    g[posX][posY] = (Food) new Food(posX, posY, g[posX][posY].getBright());
    //food.add(new Food(posX, posY, gridBright[posX][posY]));
    disp.updateGridPos("food", g[posX][posY].getColour(), posX*8, posY*8);
  }
  /*for (int i = 0; i < pos.size (); i++) {
    Position p = pos.remove(i);
    posX = p.getX();
    posY = p.getY();
    grid.add(new Grid(gridBright[posX][posY], posX, posY));
    disp.updateGridPos("empty", grid.get(i).getColour(), posX*8, posY*8);
  }*/
}

void step(Organism org) {
    if(!org.getStepped()) {
      //count++;
        
      ArrayList<Position> pos = new ArrayList<Position>();
      int posX = org.getX();
      int posY = org.getY();
      //println("X" + posX);
      //println("Y" + posY);
      for(int x = posX-1; x <= posX+1; x++) {
        for(int y = posY-1; y <= posY+1; y++) {
          if(x == posX && y == posY) {
            //do nothing
          } else {          
            pos.add(new Position(x,y));
            //println(pos.size());
          }
        }
      } 
        //println(pos.size());    
        float rand = random(0, pos.size());
        //Position p = new Position(0,0);
        Position p = pos.remove(int(rand));
        if(withinBounds(p.getX(),p.getY())) performStep(org, p.getX(),p.getY());
    }
     
}

void performStep(Organism o, int x, int y){
  //println("stepping");
  o.setStepped(true);
  if(g[x][y].getBright() == o.getBright()) {
    //println("bright is bright");
    if(g[x][y] instanceof Organism) {
       if( ((Organism)g[x][y]).getSex().equals(o.getSex()) || ( ((Organism) g[x][y]).getSex().equals("male") && o.getSex().equals("asexual")) || ( ((Organism) g[x][y]).getSex().equals("female") && o.getSex().equals("asexual")) ) {
      if(o.attack((Organism)g[x][y])) {
        //println("murder");
        String s = o.getSex();
        color c = o.getColour();
        g[x][y] = (Organism) o; 
        g[o.getX()][o.getY()] = new Grid(o.getBright(), o.getX(), o.getY());
        disp.updateGridPos(s, c, x*8, y*8);
        disp.updateGridPos("empty", g[o.getX()][o.getY()].getColour(), o.getX()*8, o.getY()*8);
        o.setXY(x,y);
       }  
      //try to kill it
        /*String s = o.getSex();
        color c = o.getColour();
        g[x][y] = (Organism) o; 
        g[o.getX()][o.getY()] = new Grid(o.getBright(), o.getX(), o.getY());
        disp.updateGridPos(s, c, x*8, y*8);
        disp.updateGridPos("empty", g[o.getX()][o.getY()].getColour(), o.getX()*8, o.getY()*8);
        o.setXY(x,y);*/
        //if kill it move to position, return true
        //if kill fails return false
      } else if( ( (((Organism)g[x][y]).getSex().equals("male") && o.getSex().equals("female")) || (((Organism)g[x][y]).getSex().equals("female") && o.getSex().equals("male")) ) && (((Organism)g[x][y]).canReproduce() && o.canReproduce()) ) {
        //println("new mf baby");
        int[] childGenes = reproduce(o, ((Organism)g[x][y]));
        Position p = birthSpot(o.getX(), o.getY(), o.getBright());
        g[p.getX()][p.getY()] = new Organism(childGenes, p.getX(), p.getY(), o.getBright());        
        disp.updateGridPos(((Organism)g[p.getX()][p.getY()]).getSex(), ((Organism)g[p.getX()][p.getY()]).getColour(), ((Organism)g[p.getX()][p.getY()]).getX()*8, ((Organism)g[p.getX()][p.getY()]).getY()*8);
        //make sweet love
        //swap genes to create baby
        //spawn baby in empty neighbouring grid location
        //return true if there's 
      }
    } else if( g[x][y] instanceof Food) {
      String s = o.getSex();
      color c = o.getColour();
      o.eat((Food)g[x][y]);
      g[x][y] = (Organism) o; 
      g[o.getX()][o.getY()] = new Grid(o.getBright(), o.getX(), o.getY());
      disp.updateGridPos(s, c, x*8, y*8);
      disp.updateGridPos("empty", g[o.getX()][o.getY()].getColour(), o.getX()*8, o.getY()*8);
      o.setXY(x,y);
      foodSize--;    
      //eat food
      //move to food location
    } else if( g[x][y] instanceof Grid) {
      //println("moving");
      //println("FROM X" + o.getX() + "Y" + o.getY());
     // println("TO X" + x + "Y" + y);
      if(o.getSex().equals("asexual")) {
        //println("as baby"); 
        float r = random(1);
        if( r < 0.09 && o.getSex().equals("asexual") ) {     
          int[] childGenes = selfReproduce(o);
          Position p = birthSpot(o.getX(), o.getY(), o.getBright());
          g[p.getX()][p.getY()] = new Organism(childGenes, p.getX(), p.getY(), o.getBright());
          disp.updateGridPos(((Organism)g[p.getX()][p.getY()]).getSex(), ((Organism)g[p.getX()][p.getY()]).getColour(), ((Organism)g[p.getX()][p.getY()]).getX()*8, ((Organism)g[p.getX()][p.getY()]).getY()*8);
        }
      }
     
      String s = o.getSex();
      color c = o.getColour();
      g[x][y] = (Organism) o; 
      g[((Organism)g[x][y]).getX()][((Organism)g[x][y]).getY()] = new Grid(o.getBright(), o.getX(), o.getY());      
      disp.updateGridPos("empty", g[o.getX()][o.getY()].getColour(), o.getX()*8, o.getY()*8);
      disp.updateGridPos(s, c, x*8, y*8);
      ((Organism)g[x][y]).setXY(x,y);
      //o.setXY(x,y); 
          
      //disp.updateGridPos("empty", g[o.getX()][o.getY()].getColour(), o.getX()*8, o.getY()*8);
      //g[x][y].setXY(x,y);     
      //o.setXY(x,y);
      //Organism orga = (Organism) g[x][y];
      //String s = o.getSex();
      //color c = o.getColour();
      //disp.updateGridPos("empty", g[o.getX()][o.getY()].getColour(), o.getX()*8, o.getY()*8);
      //disp.updateGridPos(s, c, x*8, y*8);
      
      }   
    }
  }

int[] selfReproduce(Organism org) {
   int max = 0;
  int[] genes = org.getGenes();  
  for(int i =0; i < 7; i++) {     
      float mutate = random(1);
      if(mutate < 0.05) {
      if (i==0) max = gNum;
      if (i==1) max = cNum;
      if (i==2) max = raNum;
      if (i==3) max = crNum;
      if (i==4) max = daNum;
      if (i==5) max = aNum;
      if (i==6) max = sNum;
      float rand = random(0, max);
      genes[i] = int(rand);
      }
    }
    return genes;
}

int[] reproduce(Organism o1, Organism o2) {    
    int[] parent1Genes = o1.getGenes();
    int[] parent2Genes = o2.getGenes();
    int[] genes = new int[7]; 
    int max = 0; 
    Organism child;
    
    for(int i =0; i < 7; i++) {
      float r = random(0, 2);      
      int gender = int(r);
      //println(gender);
      if(gender == 0) {       
        genes[i] = parent1Genes[i];
         //println("gender1 " + genes[i]);
      } else if (gender == 1) {
        
        genes[i] = parent2Genes[i];
        //println("gender2 " + genes[i]);
      }
      float mutate = random(1);
      if(mutate < 0.05) {
      if (i==0) max = gNum;
      if (i==1) max = cNum;
      if (i==2) max = raNum;
      if (i==3) max = crNum;
      if (i==4) max = daNum;
      if (i==5) max = aNum;
      if (i==6) max = sNum;
      float rand = random(0, max);
      genes[i] = int(rand);
      }
    }
    return genes;    
}

Position birthSpot(int pX, int pY, boolean br) {
  boolean birthed = false;
  ArrayList<Position> pos = new ArrayList<Position>();
  Position p = new Position(0,0);
  for(int x = pX-1; x <= pX+1; x++) {
        for(int y = pY-1; y <= pY+1; y++) {
          if(x == pX && y == pY) {
            //do nothing
          } else {          
            pos.add(new Position(x,y));            
          }
        }
      }
  int pNum = 0;    
  while(!birthed && pos.size() > 0) {
     p = pos.remove(pNum);
     if(withinBounds(p.getX(),p.getY())) {
       if( !(g[p.getX()][p.getY()] instanceof Organism) && g[p.getX()][p.getY()].getBright() == br ) {     
         birthed = true;
       }
     }
  }
  if(birthed) {
    return p;
  } else { 
    p = new Position(pX,pY);
    return p;
  }
}

boolean withinBounds(int x, int y) {
  return x >= 0 && x < 32 && y >= 0 && y < 24;
}
    
  


