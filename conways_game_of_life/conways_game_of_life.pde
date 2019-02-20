CellGrid cellGrid;
int framerate = 15;


void setup(){
  size(800, 800);
  frameRate(framerate);
  background(255);
  
  cellGrid = new CellGrid(80, 80);
  
}

void draw(){
  
  
  cellGrid.update();
  
  if (mousePressed) {
    cellGrid.click(mouseX, mouseY);
  }
  
  cellGrid.render();
  
}

void keyReleased(){
  if (key == int('p')) {
    println(cellGrid.updating);
    cellGrid.updating = !cellGrid.updating;
    if(cellGrid.updating){
      frameRate(framerate);
    }else{
      frameRate(120);
    }
  }
}