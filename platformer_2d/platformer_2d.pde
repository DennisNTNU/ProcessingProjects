float dt = 0.5;

Level level;

void setup() {
  size(1280, 720);
  frameRate(48);

  level = new Level(2*16, 2*9);
  
  printbinary(color(51));
  printbinary(color(205));
  printbinary(color(205) & 255);
  
  color col = color(155,155,155,2);
  
  int colAverage = ((col & 255) + ((col & (255 << 8)) >> 8) + ((col & (255 << 16)) >> 16))/3;

  int val = color(156);

  println(colAverage);

  //printbinary(val);

  //println(1<<6 & 64);
  //println(color(val) & 255, (color(val) & (255<<8))>>8, (color(val) & (255<<16))>>16, (color(val) & (255<<24))>>24);
}

void draw() {
  background(51);
  dt = 48.0/frameRate;

  level.handleInput();
  level.update(dt);
  level.show();
}

void keyPressed() {
  level.keyDown(key);
}

void keyReleased() {
  level.keyUp(key);
}

void printbinary(int i) {
  for (int j = 31; j >= 0; j--) {
    print((i & (1 << j)) >> j);
    if (j%8 == 0) {
      print(" ");
    }
  }
  println(" ");
}