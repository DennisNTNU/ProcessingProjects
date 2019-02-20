

class Tilemap {
  int x;
  int y;
  int tileWidth;
  int tileHeight;

  color white;
  color grey;
  color darkGrey;
  color black;
  color start;

  boolean doDJK;
  int holdTime;
  int fCount;



  int djk_sx;
  int djk_sy;
  ArrayList<int[]> djk_q;
  boolean djk_srt;
  boolean djk_fin;



  Tile[][] map;

  Tilemap(int x_, int y_) {
    x = x_;
    y = y_;
    tileWidth = width / x;
    tileHeight = height / y;

    white = color(235, 235, 235, 255);
    grey = color(127, 127, 127, 255);
    darkGrey = color(60, 60, 60, 255);
    //brown = color(76, 57, 29, 255);
    black = color(0, 0, 0, 255);
    start = color(200, 200, 0, 255);

    doDJK = true;

    map = new Tile[x][y];
    frameRate(90);
    holdTime = int(2 * frameRate);
    fCount = holdTime;

    djk_srt = false;
    djk_fin = false;

    for (int j = 0; j < y; j++) {
      for (int i = 0; i < x; i++) {
        map[i][j] = new Tile(i*tileWidth, j*tileHeight, tileWidth, tileHeight);
      }
    }
  }

  void allWhite() {
    for (int j = 0; j < y; j++) {
      for (int i = 0; i < x; i++) {
        map[i][j].col = white;
        map[i][j].pred.set(0, 0);
        map[i][j].dist = 1000;
        map[i][j].slowf = int(random(3));
      }
    }
  }

  void addObstruction() {
    for (int i = 0; i < 6; i++) {
      addObstructionLine();
    }
  }

  void addObstructionLine() {
    float px1 = int(random(x));
    float py1 = int(random(y));

    float px2 = int(random(x));
    float py2 = int(random(y));

    float dx = (px2 - px1);
    float dy = (py2 - py1);

    float norm = sqrt(dx*dx + dy*dy);
    dx /= norm;
    dy /= norm;

    while (sign(dx)*px1 < sign(dx)*px2) {
      map[int(px1)][int(py1)].col = black;
      px1 += dx;
      py1 += dy;
    }
    /*
    for (int i = 0; i < 8; i++) {
     map[(2*x)/4][y/4 + i].col = black;
     }
     for (int i = 0; i < 6; i++) {
     map[(2*x)/4 + i][y/4 + 5].col = black;
     }*/
  }

  void initDJK() {

    djk_sx = int(random(x));
    djk_sy = int(random(y));
    djk_q = new ArrayList();
    djk_fin = false;

    allWhite();

    addObstruction();
    map[djk_sx][djk_sy].col = start;
    map[djk_sx][djk_sy].dist = 0;

    int[] temp = {djk_sx, djk_sy};
    djk_q.add(temp);
  }

  void djkStep() {
    map[djk_sx][djk_sy].col = start;
    if (!djk_srt) {
      initDJK();
      djk_srt = true;
    }

    if (!djk_fin) {
      int djk_x = djk_q.get(0)[0];
      int djk_y = djk_q.get(0)[1];

      djk_q.remove(0);
      map[djk_x][djk_y].col = darkGrey;

      //check all neighbors of node ----------------------------------------------
      if ((djk_x != 0) && map[djk_x-1][djk_y].col == white) {

        map[djk_x-1][djk_y].col = grey;
        map[djk_x-1][djk_y].pred.set(1, 0);
        int[] temp = {djk_x-1, djk_y};
        djk_q.add(temp);
      }
      if ((djk_x != (x-1)) && map[djk_x+1][djk_y].col == white) {

        map[djk_x+1][djk_y].col = grey;
        map[djk_x+1][djk_y].pred.set(-1, 0);
        int[] temp = {djk_x+1, djk_y};
        djk_q.add(temp);
      }
      if ((djk_y != 0) && map[djk_x][djk_y-1].col == white) {

        map[djk_x][djk_y-1].col = grey;
        map[djk_x][djk_y-1].pred.set(0, 1);
        int[] temp = {djk_x, djk_y-1};
        djk_q.add(temp);
      }
      if ((djk_y != (y-1)) && map[djk_x][djk_y+1].col == white) {

        map[djk_x][djk_y+1].col = grey;
        map[djk_x][djk_y+1].pred.set(0, -1);
        int[] temp = {djk_x, djk_y+1};
        djk_q.add(temp);
      }

      if (djk_q.size() == 0) {
        djk_srt = false;
        djk_fin = true;

        fCount = 0;
        holdTime = int(2*frameRate);
      }
    }
  }


  void toggleDJK() {
    doDJK = !doDJK;
  }

  void show() {
    if (fCount > holdTime) {
      if (doDJK) level.djkStep();
    } else {
      fCount++;
    }

    for (int j = 0; j < y; j++) {
      for (int i = 0; i < x; i++) {
        map[i][j].show();
      }
    }

    for (int j = 0; j < y; j++) {
      for (int i = 0; i < x; i++) {
        map[i][j].showPred();
      }
    }
  }
}