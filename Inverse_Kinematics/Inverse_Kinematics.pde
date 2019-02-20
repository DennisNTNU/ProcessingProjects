float time = 0;
float dt = 0.02;

ArrayList<Tentacle> tentacles;

void setup() {
  size(1280, 720);
  tentacles = new ArrayList<Tentacle>();
  
  float da = TWO_PI / 40;
  for (float a = 0; a < TWO_PI; a += da) {
    float x = width/2 + 200*cos(a);
    float y = height/2 + 200*sin(a);
    tentacles.add(new Tentacle(x,y, int(10 + random(5))));
  }
}


void draw() {
  background(51);
  time += dt;
  
  for (Tentacle t : tentacles) {
    t.update();
    t.show(); 
    
  }
  

}