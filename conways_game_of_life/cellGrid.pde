class CellGrid{
  
  int cellsX;
  int cellsY;
  boolean[][][] grid;
  boolean updating;
  int bufferIndex = 0;
  
  CellGrid(int _cellsX, int _cellsY){
    cellsX = _cellsX;
    cellsY = _cellsY;
    grid = new boolean[cellsX+2][cellsY+2][2];
    updating = false;
    
    
    for(int i = 0; i < cellsX+2; i++){
      for(int j = 0; j < cellsY+2; j++){
        grid[i][j][bufferIndex] = false;
        grid[i][j][bufferIndex+1] = false;
      }
    }
    
    for(int i = 1; i < cellsX+1; i++){
      for(int j = 1; j < cellsY+1; j++){
        grid[i][j][bufferIndex] = random(0,1) > 0.7;
        //grid[i][j][bufferIndex] = false;
      }
    }
  }
  
  int numLiveNeighbours(int i, int j){
    int x = 0;
    x += int(grid[i+1][j][bufferIndex%2]);
    x += int(grid[i+1][j+1][bufferIndex%2]);
    x += int(grid[i][j+1][bufferIndex%2]);
    x += int(grid[i-1][j+1][bufferIndex%2]);
    x += int(grid[i-1][j][bufferIndex%2]);
    x += int(grid[i-1][j-1][bufferIndex%2]);
    x += int(grid[i][j-1][bufferIndex%2]);
    x += int(grid[i+1][j-1][bufferIndex%2]);
    return x;
  }
  
  void update(){
    
    if(updating){
      for(int i = 1; i < cellsX+1; i++){
        for(int j = 1; j < cellsY+1; j++){
          
          int n = numLiveNeighbours(i, j);
          
          if (grid[i][j][bufferIndex%2]) {
            if (n < 2 || n > 3) {
              grid[i][j][(bufferIndex+1)%2] = false;
            }else{
              grid[i][j][(bufferIndex+1)%2] = true;
            }
          } else if (n == 3) {
            grid[i][j][(bufferIndex+1)%2] = true;
          } else {
            grid[i][j][(bufferIndex+1)%2] = false;
          }
          
        }
      }
      bufferIndex++;
    }
  }
  
  void click(int x, int y){
    int i = x * cellsX / width + 1;
    int j = y * cellsY / height + 1;
    if (i >= cellsX+1) i = cellsX;
    if (j >= cellsY+1) j = cellsY;
    
    grid[i][j][(bufferIndex)%2] = true;
      
  }
  
  void render(){
    background(255);
    stroke(0);
    fill(0);
    for(int i = 1; i < cellsX+1; i++){
       for(int j = 1; j < cellsY+1; j++){
        if(grid[i][j][bufferIndex%2]){
          rect(float(width*(i-1))/cellsX, float(height*(j-1))/cellsY, width/cellsX, height/cellsY);
        }
      }
    }
  }
  
  
  
  
}