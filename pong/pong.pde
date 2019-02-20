Game game;
float dt;

color white = color(245);

void setup(){
  size(1024, 768);
  smooth(2);
  //frameRate(30);
  
  
  game = new Game();
}

void draw(){
  background(1);
  dt = 60.0/frameRate;
  
  game.update(dt);
  game.show();
}

void keyPressed(){
  game.keyPress(key);
}

void keyReleased(){
  game.keyRelease(key);
}