DisplayGrid disp;
ArrayList<Organism> orgs; //holds organisms
ArrayList<Food> food;
int popSize = 50; //initial starting population
int foodSize = 30; 
int gNum = 3; //number of genders
int cNum = 7; //number of colours
int raNum = 8; //max reproduction age
int crNum = 2; //can organism reproduce
int daNum = 16; //max death age
int aNum = 16; //max genetic aggression of organism
int sNum = 8; //max genetic speed of organism
color[] colBright0 = {#000000,#0000CD,#CD0000,#CD00CD,#00CD00,#00CDCD,#CDCD00,#CDCDCD}; //palette dark
color[] colBright1 = {#000000,#0000FF,#FF0000,#FF00FF,#00FF00,#00FFFF,#FFFF00,#FFFFFF}; //palette light
boolean[][] gridBright; // light or dark
//Grid[][] grid;
int id = 0; //identity of organism
float xoff = 0.0;
int w = 32;

void setup() {
  size(256*4,192*4);
  orgs = new ArrayList<Organism>();
  food = new ArrayList<Food>();
  gridBright = new boolean[32][24]; //256/8,192/8
  disp = new DisplayGrid();
  //grid = new Grid[32][24];  
  for (int x = 0; x < 32; x++) {    
    float yoff = 0.0;
    for (int y = 0; y < 24; y++) {  
      float hm = map(noise(xoff,yoff),0,1,0,255);      
      int col;
      if(hm < 128) {
        col = 0; //colBright0[0]
        gridBright[x][y] = false;
        //grid[x][y] = new Grid(false);
      } else {
        col =  255; //colBright1[0]
        gridBright[x][y] = true;
        //grid[x][y] = new Grid(true);
      }      
       //fill(color(col));
        //stroke(col);      
       // rect(x*w, y*w, w, w);
      yoff += 0.09;
    }
    xoff += 0.09;
  }
  for(int i = 0; i < 24; i++) {
    for(int j = 0; j < 32; j++) {
      //println(gridBright[j][i]);
    }
  }
  //frameRate(17);  
  populate();
  
  for(int i = 0; i < 32; i++) {
    for(int j = 0; j < 24; j++) {
      //println(gridBright[i][j]);
    }
  }
  disp.refreshDisplay();
}

void draw() {
  
}
  
public void populate() {
  boolean bright;  
  ArrayList<Position> pos = new ArrayList<Position>();  
  for(int i = 0; i < 32; i++) {
    for(int j = 0; j < 24; j++) {
      pos.add(new Position(i,j));
    }
  }  
  //Organism[] startingPop = new Organism[popSize];
  int posX;
  int posY;
  int max = 0;  
  for(int i = 0; i < popSize; i++) {        
    int[] genes = new int[7]; 
    for(int j = 0; j < 7; j++){
      if(j==0) max = gNum;
      if(j==1) max = cNum;
      if(j==2) max = raNum;
      if(j==3) max = crNum;
      if(j==4) max = daNum;
      if(j==5) max = aNum;
      if(j==6) max = sNum;
      float rand = random(0,max);
      genes[j] = int(rand);
    }
    float rand = random(0,pos.size());
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
    orgs.add(new Organism(genes, posX, posY, gridBright[posX][posY], id));
    //grid[posX][posY] = new Grid(bright, orgs.get(i));
    id++;
    //println(orgs.get(i));
    disp.updateGridPos(orgs.get(i).getSex(),orgs.get(i).getColour(),posX*8,posY*8);
    //startingPop[i] = org;
  }
  for(int i = 0; i < foodSize; i++) {
    float rand = random(0,pos.size());
    Position p = pos.remove(int(rand));
    posX = p.getX();
    posY = p.getY();
    food.add(new Food(posX,posY,gridBright[posX][posY]));
    disp.updateGridPos("food",food.get(i).getColour(),posX*8,posY*8);
  }
   
}



