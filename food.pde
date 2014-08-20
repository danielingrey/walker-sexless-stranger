//holds food data, child of Grid class

class Food extends Grid {
  int nourishment; //nourishment level of a food object increases death age of organism eating it 
  int toxicity; //toxicity decreases death age
  
  //constructor
  //inputs: (x,y) coordinates, bright variable
  Food(int px, int py, boolean bright) {
    super(bright, px, py); //call parent class and apply variables
    super.setColour(int(random(1,8))); //randomly choose a colour from the palette for the food
    //randomly set nourishment and toxicity of food    
    nourishment = int(random(1,8)); 
    toxicity = int(random(-10,1));    
  }

  int getNourishment() {
    return nourishment;
  }  
  
  int getToxicity() {
    return toxicity;
  }
  
}
