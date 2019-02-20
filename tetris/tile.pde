

class Tile {

  PVector pos;
  int w;
  int h;
  color col;
  boolean occupied;

  Tile() {
    pos = new PVector(0, 0);
    w = 0;
    h = 0;
    col = color(255, 255, 255, 255);
    occupied = false;
  }
  Tile(float x, float y, float w_, float h_) {
    pos = new PVector(x, y);
    w = int(w_);
    h = int(h_);
    col = color(205, 205, 205, 255);
    occupied = false;
  }

  void show() {
    //stroke(0);
    noStroke();
    fill(col);
    rect(pos.x, pos.y, w, h);
    fill(col+(10<<16)+(10<<8)+(10<<0));
    rect(pos.x+2, pos.y+2, w-4, h-4);
    if (occupied) {
      fill(255, 255, 255, 155);
      rect(pos.x+2, pos.y+2, w-4, 4);
      rect(pos.x + w - 6, pos.y + 6, 4, 4);
    }
  }
}