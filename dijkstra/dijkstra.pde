
Tilemap level;

void setup() {
  size(1280, 720);
  level = new Tilemap(32, 18);
}

void draw() {
  background(51);
  level.show();
}

void keyPressed() {
  switch(key) {
  case 'b':
    level.toggleBfs();
    break;
  case 'd':
    level.toggleDfs();
    break;
  }
}

float sign(float x){
  if(x >= 0.0){
    return 1.0;
  }else{
    return -1.0;
  }
}