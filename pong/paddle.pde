class Paddle{
  
  float x;
  float y;
  
  int w = 20;
  int h = 120;
  
  Paddle(float x_){
    x = x_;
    y = height/2;
  } 
  
  void show(){
    stroke(white);
    fill(white);
    rect(x-w/2, y-h/2, w, h);
  }
  
}