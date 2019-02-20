float time = 0;
float dt = 0.02;

Spinne spinne;

void setup() {
  size(1280, 720);
  
  spinne = new Spinne();
  
}

void draw() {
  background(51);
  stroke(215);
  time += dt;
  
  
  spinne.update();
  spinne.show();
}