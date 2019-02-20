class Particle {
  float _x;
  float _y;
  float _vx;
  float _vy;
  float _life;
  Particle(){
    
  }
  Particle(float x, float y, float vx, float vy, float life){
    _x = x;
    _y = y;
    _vx = vx;
    _vy = vy;
    _life = life;
  }
  void update(float ax, float ay, float dt){
    _vx += dt*ax;
    _vy += dt*ay;
    _x += dt*_vx;
    _y += dt*_vy;
    _life -= dt;
  }
  float getx(){
    return _x;
  }
  float gety(){
    return _y;
  }
  float getvx(){
    return _vx;
  }
  float getvy(){
    return _vy;
  }
  float getLife(){
    return _life;
  }
}



class Particles {
  
  ArrayList<Particle> particles = new ArrayList<Particle>();
  
  Particles(){
    
  }
  void addParticle(float x, float y, float vx, float vy, float life) {
    particles.add(new Particle(x, y, vx, vy, life));
  }
  void update(float dt){
    for (int i = 0; i < particles.size(); i++) {
      particles.get(i).update(-0.1*particles.get(i).getvx(), -0.1*particles.get(i).getvy(), dt);
      if (particles.get(i).getLife() < 0) {
        particles.remove(i);
      }
    }
  }
  void drawParticles(){
    stroke(150 + random(102), 20 + random(50), 0, 100 + random(100));
    for (int i = 0; i < particles.size(); i++) {
      //point(particles.get(i).getx(), particles.get(i).gety(), 2.0);
      point(particles.get(i).getx(), particles.get(i).gety());
      fill(150 + random(102), 20 + random(50), 0, 100 + random(100));
      ellipse(particles.get(i).getx(), particles.get(i).gety(), 2, 2);
      noFill();
    }
    stroke(0, 0, 0, 255);
  }
}