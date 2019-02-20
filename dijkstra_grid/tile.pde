class dir{
  int x;
  int y;
  
  dir(){
    x = 0;
    y = 0;
  }
  
  dir(int x_, int y_){
    x = x_;
    y = y_;
  }
  
  void set(int x_, int y_){
    x = x_;
    y = y_;
  }
}

class Tile {
  color col;
  int visited; //0=white, 1= grey, 2=darkgrey;
  
  int x;
  int y;
  int w;
  int h;
  dir pred;
  int slowf;
  int dist;

  Tile(int x_, int y_, int w_, int h_) {
    col = color(random(256), random(256), random(256), 255);
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    pred = new dir(0, 0); //0 no pred, 1, up, 2, down, -1, left, -2, right
    slowf = 0;
    dist = 0;
  } 

  void show() {
    
    fill((col >> 16) & 255 - 30*slowf, (col >> 8) & 255 - 30*slowf, col & 255, (col >> 24) & 255);
    
    stroke(0);
    rect(x, y, w, h);
  }

  void showPred() {
    fill(205);
    text(str(slowf), x+w/2, y+h/2);

    stroke(200, 0, 0, 255);
    line(x + w/2, y + h/2, x + w/2 + pred.x*w, y + h/2 + pred.y*h);
  }
}