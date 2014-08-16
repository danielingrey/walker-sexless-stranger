//food data randomly appear
class Food {
  int nourishment;
  int toxicity;
  int stimulant;
  int aggression;
  int posX;
  int posY;
  color colour;
  
  Food(int px, int py, boolean bright) {
    color[] colB1 = {#0000CD,#CD0000,#CD00CD,#00CD00,#00CDCD,#CDCD00,#CDCDCD};
    color[] colB2 = {#0000FF,#FF0000,#FF00FF,#00FF00,#00FFFF,#FFFF00,#FFFFFF};
    if(!bright) colour = colB1[int(random(0,7))];
    else colour = colB2[int(random(0,7))];
    nourishment = int(random(1,8));
    toxicity = int(random(-10,1));
    stimulant = int(random(-10,10));
    aggression = int(random(-10,10));
  }
  
  color getColour() {
    return colour;
  }
  
}
