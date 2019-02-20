class Tile {
  color col;

  int x;
  int y;

  int w;
  int h;

  int pred; //predecessor
  int dist;
  int stamp;

  Tile(int x_, int y_, int w_, int h_) {
    col = color(random(256), random(256), random(256), 255);
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    pred = 0; //0 no pred, 1, up, 2, down, -1, left, -2, right
    dist = 0;
  }

  void show() {
    fill(col);
    stroke(0);
    rect(x, y, w, h);
  }

  void showPred() {

    stroke(200, 0, 0, 255);
    fill(255, 255, 255, 255);
    strokeWeight(2);
    text(str(dist), x + w/2 - 7, y + h/2 - 2);
    text(str(stamp), x + w/2 - 7, y + h/2 + 10);

    switch(pred) {
    case -2:
      line(x + w/2, y + h/2, x + w/2 + w, y + h/2);
      break;

    case -1:
      line(x + w/2, y + h/2, x + w/2 - w, y + h/2);
      break;

    case 1:
      line(x + w/2, y + h/2, x + w/2, y + h/2 - h);
      break;

    case 2:
      line(x + w/2, y + h/2, x + w/2, y + h/2 + h);
      break;
    default:

      break;
    }
    strokeWeight(1);
  }
}
