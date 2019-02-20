
Tilemap level;

void setup() {
  size(1600, 900);
  level = new Tilemap(32, 18);
}

void draw() {
  background(1);
  level.show();
}

void keyPressed() {
  switch(key) {
  case 'b':
    level.toggleDJK();
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