class Intpos {
  int x;
  int y;

  Intpos(int x_, int y_) {
    x = x_;
    y = y_;
  }

  Intpos copy() {

    return new Intpos(x, y);
  }

  void add(Intpos in) {
    x += in.x;
    y += in.y;
  }
  void sub(Intpos in) {
    x -= in.x;
    y -= in.y;
  }
  
  void print(){
    println(x, " ", y);
    
  }
}