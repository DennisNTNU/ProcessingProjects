
class Segment {
  PVector root;
  PVector hand;
  float len;
  float angle;
  Segment child = null;
  Segment parent = null;
  
  Segment(float x, float y, float len_, float angle_){
    root = new PVector(x, y);
    len = len_;
    angle = angle_;
    hand = new PVector(x + len*cos(angle), y + len*sin(angle));
  }
  
  Segment(Segment parent_, float len_, float angle_){
    root = parent_.hand.copy();
    len = len_;
    angle = angle_;
    hand = new PVector(root.x + len*cos(angle), root.y + len*sin(angle));
  }
  
  void show(){
    stroke(255);
    line(root.x, root.y, hand.x, hand.y);
    
  }
  
}