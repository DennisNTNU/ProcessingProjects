
class Tilemap {
  int w;
  int h;

  Tile[][] map;

  Tilemap(int w_, int h_) {
    w = w_;
    h = h_;
    map = new Tile[10][20];
    
    int a = (width - w)/2;
    int b = (height - h)/2;
    
    int tile_w = w/10;
    int tile_h = h/20;
    
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 20; j++) {
        map[i][j] = new Tile(a + i*tile_w, b + j*tile_h, tile_w, tile_h);
      }
    }
  }
  
  void setCol(int x, int y, color col){
    map[x][y].col = col;
    
  }

  void show() {
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 20; j++) {
        map[i][j].show();
      }
    }
  }
}