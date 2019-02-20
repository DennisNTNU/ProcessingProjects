Cube player = new Cube();

float dt = 0.02;

void setup(){
  
  player.x = width/2;
  player.y = 0.9*height;

  size(1680, 720);
  
  frameRate(30);
}



void draw(){
  background(245);
  
  player.update(dt);
  player.draw();
}