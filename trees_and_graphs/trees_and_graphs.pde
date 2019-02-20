float t = 0;
float dt = 0.05;

Graph graf = new Graph(36, 1280, 720);

boolean doMotionUpdates = true;
color asdf = #FFFFFF;



void setup() {
  size(1280, 720);
  //graf.printArray();
}



void draw() {
  delay(25);
  background(#FF9933);

  if (doMotionUpdates) { graf.update(dt, t); }
  graf.draww();

  t += dt;
}