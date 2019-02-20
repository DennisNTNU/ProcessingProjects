class Particle {
  float x;
  float y;
  float vx;
  float vy;
  float q;
  float m;
  float life;
  float xd;
  float yd;
  
  Particle() {
    x = 10;
    y = 10;
    vx = 0;
    vy = 0;
    q = 0;
    m = 1;
    life = 1;
    xd = 10;
    yd = 10;
  }
  Particle(float X, float Y) {
    x = X;
    y = Y;
    vx = 0;
    vy = 0;
    q = 0;
    m = 1;
    life = 1;
    xd = X;
    yd = Y;
  }
  Particle(float X, float Y, float Vx, float Vy) {
    x = X;
    y = Y;
    vx = Vx;
    vy = Vy;
    q = 0;
    m = 1;
    life = 1;
    xd = X;
    yd = Y;
  }
  Particle(float X, float Y, float Vx, float Vy, float Life) {
    x = X;
    y = Y;
    vx = Vx;
    vy = Vy;
    q = 0;
    m = 1;
    life = Life;
    xd = X;
    yd = Y;
  }
  void update(float ax, float ay, float dt){
    vx += dt * ax / m;
    vy += dt * ay / m;
    x += dt * vx;
    y += dt * vy;
    life -= dt;
  }
  void updateToDesPos(float dt){
    float ax = 2 * (xd - x) - 1.98 * vx;
    float ay = 2 * (yd - y) - 1.98 * vy;
    vx += dt * ax / m;
    vy += dt * ay / m;
    x += dt * vx;
    y += dt * vy;
    life -= dt;
  }
}

//#################################################################

class Node {
  Particle pos;
  float r;
  color rgba;
  
  int depth;
  int predecessor;
  
  int start = 0;
  int finish = 0;
  
  Node(){
    pos = new Particle();
    r = 3;
    rgba = #990022;
    depth = 0;
    predecessor = 0;
  }
  Node(float x, float y, float R, color Rgba){
    pos = new Particle(x, y);
    r = R;
    rgba = Rgba;
    depth = 0;
    predecessor = 0;
  }
  
  void update(float ax, float ay,float dt){
    pos.update(ax, ay, dt);
  }
  void updateDesPos(float dt){
    pos.updateToDesPos(dt);
  }
  void draww(int index){
    stroke(rgba);
    fill(rgba);
    textSize(10);
    ellipse(pos.x, pos.y, r, r);
    fill(0,0,0,255);
    textAlign(LEFT);
    text("Depth: " + str(depth) + "\nPre: " + str(predecessor) + "\nStart: " + str(start) + "\nFinish: " + str(finish), pos.x, pos.y - 3*r);
    fill(255 - red(rgba), 255 - green(rgba), 255 - blue(rgba), 255);
    textAlign(CENTER);
    text(str(index), pos.x, pos.y + 4);
  }
}