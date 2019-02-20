
System dp;
System2 dp2;

void setup(){
  size(1280, 720);
  
  dp = new System(1.0, 0.0, 1.0, 0.0);
  dp2 = new System2(width/8, height/2 + 100, width/8+100, height/2);
}

void draw(){
  background(204);
  //dp.update();
  dp.updateRK4();
  dp.show();
  
  
  dp2.update();
  dp2.show();
}