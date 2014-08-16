class Grid {
  boolean bright;
  Organism org;
  Food fd;
    
  Grid(boolean b, Organism o) {
    bright = b;
    org = o;
  }
  
  Grid(boolean b, Food f) {
    bright = b;
    fd = f;
  }
  
  Grid(boolean b) {
    bright = b;
  }
  
  boolean getBright() {
    return bright;
  }
  
  Organism getOrg() {
    return org;
  }
  
  Food getFood() {
    return fd;
  }
  
  
}
