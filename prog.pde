ArrayList<Vector> vectors = new ArrayList<Vector>();

Segment segment = new Segment(0,0,800);

void setup(){
  size(800,800);
  background(255);
}

float t = 0;

void draw(){
  
  segment.render();
  for(Vector v : vectors){
    
    circle(v.x, v.y, 10 * abs(sin(t)));
    
  }
  
  t+= PI/24;
}

void keyPressed() {
  print(key);
  segment.sSplit();
}

void mouseClicked() {
  vectors.add(new Vector(mouseX, mouseY));
  segment.feedList(vectors);
}

class Segment{
  
  Vector argument;
  Segment[] childs = new Segment[4];
  
  int lifespan = 0;
  
  boolean isSplit = false;
  boolean isDisabled = false;
  
  ArrayList<Vector> coords;
  
  public Segment(int x, int y, int s){
    argument = new Vector(x,y,s);
    
  }
  
  public void sSplit(){

    if(!isSplit & !isDisabled){
      for(int i = 0; i < childs.length; i++){
        childs[i] = new Segment(0,0,0);
        childs[i].argument.x = argument.x + ((i%2) * argument.z / 2);
        childs[i].argument.y = argument.y + ((i/2) * argument.z / 2);
        childs[i].argument.z = argument.z / 2;
        childs[i].coords = coords;
        childs[i].isDisabled = true;
        childs[i].lifespan = lifespan + 1;
        for(Vector v : coords){
          if(childs[i].containsPoint(v)){
            childs[i].isDisabled = false;
          }
        }
        if(childs[i].lifespan<10){
          childs[i].sSplit();
        }
      }
      isSplit = true;
    } else if(!isDisabled) {
      for(int i = 0; i < childs.length; i++){
        childs[i].sSplit();
      }
    }
  }
  
  public void feedList(ArrayList<Vector> list){
    coords = list;
  }
  
  public boolean containsPoint(Vector point){
    return !isSplit & (point.x >= argument.x && point.x < argument.x + argument.z && point.y >= argument.y && point.y < argument.y + argument.z);
  }
  
  public void render(){
    if(!isSplit){
      fill(255);
      if(isDisabled) fill(127 - lifespan*2, lifespan * 45, lifespan * 30);
      rect(argument.x, argument.y, argument.z, argument.z);
    }else{
      for(int i = 0; i < childs.length; i++){
        childs[i].render();
      }
    }
  }
  
}

class Vector{
  
  public int x, y, z;
  
  public Vector(int x, int y, int z){
    this.x=x;
    this.y=y;
    this.z=z;
  }
  
  public Vector(int x, int y){
    this.x=x;
    this.y=y;
    this.z=0;
  }
  
}
