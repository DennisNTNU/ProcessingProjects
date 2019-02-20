class Tile {
  color col;
  int type;
  boolean walkable;

  Tile() {
    col = color(0, 0, 0, 255);
    type = -1;
    walkable = true;
  }
}

class Background {
  int x;
  int y;
  Tile[][] map;
  int[] exitTile = {-1, -1};

  Background(int x_, int y_) {
    x = x_;
    y = y_;
    map = new Tile[x][y];

    //initializing each tile
    for (int j = 0; j < y; j++) {
      for (int i = 0; i < x; i++) {
        addRandomTile(i, j);
      }
    }
  }

  void addRandomTile(int i, int j) {
    map[i][j] = new Tile();
    map[i][j].col = color(int(random(256)));

    if ((map[i][j].col & 255) < 127) {
      map[i][j].walkable = false;
    }
  }

  void addTile(int i, int j, color col) {
    map[i][j].col = col;

    if ((col & 255) == 72 && ((col & (255 << 8)) >> 8) == 68 && ((col & (255 << 16)) >> 16) == 254) {
      exitTile[0] = i;
      exitTile[1] = j;
    }

    int colAverage = ((col & 255) + ((col & (255 << 8)) >> 8) + ((col & (255 << 16)) >> 16))/3;

    if (colAverage <= 127) {
      map[i][j].walkable = false;
    } else {
      map[i][j].walkable = true;
    }
  }

  void terskel() {
    for (int j = 0; j < y; j++) {
      for (int i = 0; i < x; i++) {
        if ((map[i][j].col & 255) < 127) {
          map[i][j].col = color(51);
        } else {
          map[i][j].col = color(205);
        }
      }
    }
  }

  void show() {
    for (int j = 0; j < y; j++) {
      for (int i = 0; i < x; i++) {
        stroke(map[i][j].col);
        fill(map[i][j].col);
        rect(i * width / x, j * height / y, width / x, height / y);
      }
    }
  }

  void load(int levelNumber) {
    PImage input = loadImage("levels/level" + levelNumber + ".bmp");
    input.loadPixels();

    for (int j = 0; j < y; j++) {
      for (int i = 0; i < x; i++) {
        addTile(i, j, input.pixels[j*x+i]);
      }
    }

    printbinary(map[0][0].col);
  }

  void export() {
    PImage output = createImage(x, y, ARGB);
    output.loadPixels();
    printbinary(map[4][5].col);
    //int temp;

    for (int j = 0; j < y; j++) {
      for (int i = 0; i < x; i++) {
        //map[i][j].col &= (255 + (255 << 8) + (255 << 16));
        //temp = map[i][j].col & 255;
        //map[i][j].col |= (255 << 24);
        //map[i][j].col |= (temp << 8) + (temp << 16);
        output.pixels[j*x + i] = map[i][j].col;
      }
    }
    output.updatePixels();

    printbinary(map[4][5].col);

    output.save("randomLevel_"+str(hour())+"_"+str(minute())+"_"+str(second())+".bmp");
    println("Map saved");
  }
}