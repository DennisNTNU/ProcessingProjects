class Fireworks {
  ArrayList<Firework> fireworks_;

  Fireworks(int num) {
    fireworks_ = new ArrayList();
    
    for (int i = 0; i < num; i++) {
      fireworks_.add(new Firework());
    }
  }
  
  void update(float dt){
    
    for (int i = 0; i < fireworks_.size(); i++) {
      fireworks_.get(i).update(dt);
      if(fireworks_.get(i).life <= 0.0){
        fireworks_.remove(i);
        fireworks_.add(i, new Firework());
      }
    }
    
  }
  
  void show(){
    for (int i = 0; i < fireworks_.size(); i++) {
      fireworks_.get(i).show();
    }
    
  }
}