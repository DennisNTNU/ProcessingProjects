class Segment {
  PVector a;
  PVector b = new PVector();

  float len;
  float angle;
  float weight;
  
  PVector target = new PVector();

  Segment(float x, float y, float len_, float weight_) {
    a = new PVector(x, y);
    len = len_;
    angle = 0;
    calculateB();
    weight = weight_;
    
    //target.set(b.x, b.y);
  }
  
  Segment(Segment parent, float len_, float weight_) {
    a = parent.b.copy();
    len = len_;
    angle = 0;
    calculateB();
    weight = weight_;
    
  }
  
  void follow(Segment child){
    float targetX = child.a.x;
    float targetY = child.a.y;
    follow(targetX, targetY);
  }
  
  void follow(float tx, float ty){
    target.set(tx, ty);
    PVector dir = PVector.sub(target, a);
    angle = dir.heading();
    
    dir.setMag(len);
    dir.mult(-1);
    
    a = PVector.add(target, dir);
  }
  
  void setA(PVector base){
    a = base.copy();
    calculateB();
  }

  void calculateB() {
    b.set(a.x + len*cos(angle), a.y + len*sin(angle));
  }
  
  void update(){
    calculateB();
  }
  
  void show() {
    stroke(255);
    strokeWeight(weight);

    line(a.x, a.y, b.x, b.y);
  }
}