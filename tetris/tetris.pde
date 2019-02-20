

Game tetris;

void setup() {
  size(1280, 720);
  tetris = new Game();
}

void draw() {
  background(0);

  tetris.update();
  tetris.show();
}

void keyPressed() {

  switch(key) {

  case 'a':
    tetris.left();
    break;

  case 'd':
    tetris.right();
    break;

  case 'e':
    tetris.rot();
    break;

  case 's':
    tetris.speed = 3;
    break;
  }
}

void keyReleased() {
  switch(key) {
  case 's':
    tetris.speed = tetris.normalSpeed;
    break;
  }
}