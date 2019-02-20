

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
  color end;
  color path1;
  color path2;

  boolean doBfs;
  boolean doDfs;
  int holdTime;
  int fCount;

  int bfs_sx;
  int bfs_sy;
  ArrayList<int[]> bfs_q;
  boolean bfs_srt;
  boolean bfs_fin;
  int longest;
  int bfs_ex;
  int bfs_ey;

  int dfs_sx;
  int dfs_sy;
  ArrayList<int[]> dfs_q;
  boolean dfs_srt;
  boolean dfs_fin;
  int timestamp;



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
    start = color(150, 0, 0, 255);
    path1 = color(80, 10, 10, 255);
    path2 = color(50, 10, 10, 255);
    end = color(200, 0, 0, 255);

    doBfs = false;
    doDfs = true;

    map = new Tile[x][y];
    frameRate(80);
    holdTime = int(2 * frameRate);
    fCount = holdTime;

    bfs_srt = false;
    bfs_fin = false;
    dfs_srt = false;
    dfs_fin = false;

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
        map[i][j].pred = 0;
        map[i][j].dist = 0;
        map[i][j].stamp = 0;
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

  void initBFS() {
    /*
    node color: white: undiscovered, grey: enqueued, darkgrey: dequeued.
     color every node white, remember every predecessor, and distance from start node.
     BFS: select a start node. enqueue it. while the queue is not empty, node_ = dequeue().
     enqueue all undiscovered neighbors of node_ (plus maybe optional processing on the nodes).
     (optional processing on node_)
     */

    bfs_sx = int(random(x));
    bfs_sy = int(random(y));
    bfs_q = new ArrayList();
    bfs_fin = false;
    longest = 0;

    allWhite();

    addObstruction();
    map[bfs_sx][bfs_sy].col = start;
    map[bfs_sx][bfs_sy].dist = 0;
    
    bfs_ex = int(random(x));
    bfs_ey = int(random(y));
    map[bfs_ex][bfs_ey].stamp = 1;
    //map[bfs_lx][bfs_ly].col = end;

    int[] temp = {bfs_sx, bfs_sy};
    bfs_q.add(temp);
  }

  void bfsStep() {
    map[bfs_sx][bfs_sy].col = start;
    if (!bfs_srt) {
      initBFS();
      bfs_srt = true;
    }

    if (!bfs_fin) {
      int bfs_x = bfs_q.get(0)[0];
      int bfs_y = bfs_q.get(0)[1];
      int dist = map[bfs_x][bfs_y].dist;

      bfs_q.remove(0);
      map[bfs_x][bfs_y].col = darkGrey;
      
      if (map[bfs_x][bfs_y].stamp == 1) {
        backtrack(bfs_x, bfs_y, path1);
      }

      //check all neighbors of node ----------------------------------------------
      if ((bfs_x != 0) && map[bfs_x-1][bfs_y].col == white) {

        map[bfs_x-1][bfs_y].col = grey;
        map[bfs_x-1][bfs_y].dist = dist+1;
        map[bfs_x-1][bfs_y].pred = -2;
        int[] temp = {bfs_x-1, bfs_y};
        bfs_q.add(temp);
      }
      if ((bfs_x != (x-1)) && map[bfs_x+1][bfs_y].col == white) {

        map[bfs_x+1][bfs_y].col = grey;
        map[bfs_x+1][bfs_y].dist = dist+1;
        map[bfs_x+1][bfs_y].pred = -1;
        int[] temp = {bfs_x+1, bfs_y};
        bfs_q.add(temp);
      }
      if ((bfs_y != 0) && map[bfs_x][bfs_y-1].col == white) {

        map[bfs_x][bfs_y-1].col = grey;
        map[bfs_x][bfs_y-1].dist = dist+1;
        map[bfs_x][bfs_y-1].pred = 2;
        int[] temp = {bfs_x, bfs_y-1};
        bfs_q.add(temp);
      }
      if ((bfs_y != (y-1)) && map[bfs_x][bfs_y+1].col == white) {

        map[bfs_x][bfs_y+1].col = grey;
        map[bfs_x][bfs_y+1].dist = dist+1;
        map[bfs_x][bfs_y+1].pred = 1;
        int[] temp = {bfs_x, bfs_y+1};
        bfs_q.add(temp);
      }

      if (bfs_q.size() == 0) {
        backtrack(bfs_x, bfs_y, path2);
        bfs_srt = false;
        bfs_fin = true;
        doDfs = true;
        doBfs = false;
        fCount = 0;
        frameRate(80);
        holdTime = 2*80;
      }
    }
  }

  void backtrack(int x_, int y_, color col) {
    int x = x_; int y = y_;
    while (map[x][y].dist > 0) {
      map[x][y].col = col;
      switch(map[x][y].pred) {
      case -2:
        x++;
        break;
      case -1:
        x--;
        break;
      case 1:
        y--;
        break;
      case 2:
        y++;
        break;
      }
    }
  }

  void initDFS() {
    dfs_sx = int(random(x));
    dfs_sy = int(random(y));
    dfs_q = new ArrayList();
    dfs_fin = false;
    timestamp = 0;

    int[] temp = {dfs_sx, dfs_sy};
    dfs_q.add(temp);

    allWhite();

    addObstruction();
    map[dfs_sx][dfs_sy].col = start;
  }

  void dfsStep() {
    if (!dfs_srt) {
      initDFS();
      dfs_srt = true;
    }

    if (!dfs_fin) {
      int l = dfs_q.size() - 1;
      int dfs_x = dfs_q.get(l)[0];
      int dfs_y = dfs_q.get(l)[1];

      timestamp++;


      if ((dfs_x != (x-1)) && map[dfs_x+1][dfs_y].col == white) {


        map[dfs_x+1][dfs_y].col = grey;
        map[dfs_x+1][dfs_y].stamp = timestamp;
        map[dfs_x+1][dfs_y].pred = -1;
        int[] temp = {dfs_x+1, dfs_y};
        dfs_q.add(temp);
      } else if ((dfs_y != (y-1)) && map[dfs_x][dfs_y+1].col == white) {

        map[dfs_x][dfs_y+1].col = grey;
        map[dfs_x][dfs_y+1].stamp = timestamp;
        map[dfs_x][dfs_y+1].pred = 1;
        int[] temp = {dfs_x, dfs_y+1};
        dfs_q.add(temp);
      } else if ((dfs_x != 0) && map[dfs_x-1][dfs_y].col == white) {

        map[dfs_x-1][dfs_y].col = grey;
        map[dfs_x-1][dfs_y].stamp = timestamp;
        map[dfs_x-1][dfs_y].pred = -2;
        int[] temp = {dfs_x-1, dfs_y};
        dfs_q.add(temp);
      } else if ((dfs_y != 0) && map[dfs_x][dfs_y-1].col == white) {

        map[dfs_x][dfs_y-1].col = grey;
        map[dfs_x][dfs_y-1].stamp = timestamp;
        map[dfs_x][dfs_y-1].pred = 2;
        int[] temp = {dfs_x, dfs_y-1};
        dfs_q.add(temp);
      } else {
        dfs_q.remove(l);
        map[dfs_x][dfs_y].col = darkGrey;
        map[dfs_x][dfs_y].dist = timestamp;
      }


      if (dfs_q.size() == 0) {
        map[dfs_sx][dfs_sy].col = start;
        dfs_srt = false;
        dfs_fin = true;
        doBfs = true;
        doDfs = false;
        fCount = 0;
        frameRate(50);
        holdTime = 2*50;
      }
    }
  }

  void toggleBfs() {
    doBfs = !doBfs;
    doDfs = false;
  }

  void toggleDfs() {
    doDfs = !doDfs;
    doBfs = false;
  }

  void show() {
    if (fCount > holdTime) {
      if (doBfs) level.bfsStep();
      else if (doDfs) level.dfsStep();
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