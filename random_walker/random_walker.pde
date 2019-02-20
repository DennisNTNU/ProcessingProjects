RWalker w = new RWalker(50);
float t = 0.0;
float dt = 0.02;

void setup(){
  size(800, 800);
  background(255);
  stroke(30);
}

void draw(){
  background(255);
  t += dt;
  
  w.randomStep();
  w.draw();
  delay(100);
}