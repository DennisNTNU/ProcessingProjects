

class Player {
  Agent a;

  Player() {
    a = new Agent();
  }
  
  void update(PVector f, float dt){
    a.vel.x += dt * (f.x - 0.15*a.vel.x);
    a.vel.y += dt * (f.y - 0.15*a.vel.y);
    a.pos.x += dt * a.vel.x;
    a.pos.y += dt * a.vel.y;
  }
  
  void show(){
    a.show();
  }
  
}