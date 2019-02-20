
class Game {

  Tilemap field;

  int currentBlockType;
  ArrayList<Intpos> currentBlock;

  int normalSpeed;
  int speed;
  int tick;
  int score;

  boolean gameOver;

  boolean[] down;
  boolean[] press;

  color red = color(235, 0, 0, 255);
  color gre = color(0, 235, 0, 255);
  color pur = color(235, 0, 235, 255);
  color blu = color(0, 0, 235, 255);
  color ora = color(235, 127, 0, 255);
  color ble = color(127, 127, 235, 255);
  color yel = color(235, 235, 0, 255);
  color backgrnd = color(205, 205, 205, 255);

  Game() {
    gameOver = false;
    field = new Tilemap(350, 700);
    currentBlock = new ArrayList();
    down = new boolean[4];
    press = new boolean[4];
    normalSpeed = 60;
    speed = 60;
    tick = 0;
    score = 0;
    addBlock();
  }

  void addBlock() {
    currentBlockType = int(random(7));
    switch(currentBlockType) {
    case 0:
      currentBlock.add(new Intpos(4, 0));
      currentBlock.add(new Intpos(4, 1));
      currentBlock.add(new Intpos(3, 1));
      currentBlock.add(new Intpos(3, 2));
      setColor(red);

      break;
    case 1:
      currentBlock.add(new Intpos(3, 0));
      currentBlock.add(new Intpos(3, 1));
      currentBlock.add(new Intpos(4, 1));
      currentBlock.add(new Intpos(4, 2));
      setColor(gre);
      break;
    case 2:
      currentBlock.add(new Intpos(3, 0));
      currentBlock.add(new Intpos(3, 1));
      currentBlock.add(new Intpos(4, 1));
      currentBlock.add(new Intpos(3, 2));
      setColor(pur);
      break;
    case 3:
      currentBlock.add(new Intpos(3, 0));
      currentBlock.add(new Intpos(4, 0));
      currentBlock.add(new Intpos(3, 1));
      currentBlock.add(new Intpos(3, 2));
      setColor(blu);
      break;
    case 4:
      currentBlock.add(new Intpos(3, 0));
      currentBlock.add(new Intpos(4, 0));
      currentBlock.add(new Intpos(4, 1));
      currentBlock.add(new Intpos(4, 2));
      setColor(ora);
      break;
    case 5:
      currentBlock.add(new Intpos(3, 0));
      currentBlock.add(new Intpos(3, 1));
      currentBlock.add(new Intpos(3, 2));
      currentBlock.add(new Intpos(3, 3));
      setColor(ble);
      break;
    case 6:
      currentBlock.add(new Intpos(3, 0));
      currentBlock.add(new Intpos(3, 1));
      currentBlock.add(new Intpos(4, 0));
      currentBlock.add(new Intpos(4, 1));
      setColor(yel);
      break;
    default:
      break;
    }

    for (int i = 0; i < currentBlock.size(); i++) {
      gameOver |= field.map[currentBlock.get(i).x][currentBlock.get(i).y].occupied;
    }
  }

  void setColor(color col) {

    for (int i = 0; i < currentBlock.size(); i++) {
      field.setCol(int(currentBlock.get(i).x), int(currentBlock.get(i).y), col);
    }
  }

  void removeColor() {
    for (int i = 0; i < currentBlock.size(); i++) {
      field.setCol(int(currentBlock.get(i).x), int(currentBlock.get(i).y), backgrnd);
    }
  }

  void descendBlock() {
    removeColor();
    int a;
    int b;
    for (int i = 0; i < currentBlock.size(); i++) {
      a = currentBlock.get(i).x;
      b = currentBlock.get(i).y;

      if (b == 19 || field.map[a][b+1].occupied) {
        placeBlock();
        return;
      }
    }


    for (int i = 0; i < currentBlock.size(); i++) {
      currentBlock.get(i).y++;
    }
    setColor(getColor(currentBlockType));
  }


  void placeBlock() {
    setColor(getColor(currentBlockType));
    int a;
    int b;
    for (int i = 0; i < currentBlock.size(); i++) {
      a = currentBlock.get(i).x;
      b = currentBlock.get(i).y;
      field.map[a][b].occupied = true;
    }
    currentBlock.remove(0);
    currentBlock.remove(0);
    currentBlock.remove(0);
    currentBlock.remove(0);

    checkCompleteLine();

    addBlock();
  }

  void handleInput() {
  }

  void keyPress(char in) {
    switch(in) {

    case 'a':
      down[0] = true;
      break;

    case 'd':
      down[1] = true;
      break;

    case 'r':
      down[2] = true;
      break;

    case 's':
      down[3] = true;
      break;
    }
  }

  void keyRelease(char in) {

    switch(in) {
    case 'a':
      down[0] = false;
      break;

    case 'd':
      down[1] = false;
      break;

    case 'r':
      down[2] = false;
      break;

    case 's':
      down[3] = false;
      break;
    }
  }

  void rot() {
    removeColor();
    int temp;
    Intpos mid = currentBlock.get(1).copy();

    Intpos cb1 = currentBlock.get(0).copy();
    Intpos cb2 = currentBlock.get(1).copy();
    Intpos cb3 = currentBlock.get(2).copy();
    Intpos cb4 = currentBlock.get(3).copy();

    cb1.sub(mid);
    cb2.sub(mid);
    cb3.sub(mid);
    cb4.sub(mid);


    temp = cb1.x;
    cb1.x = cb1.y;
    cb1.y = -temp;

    temp = cb2.x;
    cb2.x = cb2.y;
    cb2.y = -temp;

    temp = cb3.x;
    cb3.x = cb3.y;
    cb3.y = -temp;

    temp = cb4.x;
    cb4.x = cb4.y;
    cb4.y = -temp;

    cb1.add(mid);
    cb2.add(mid);
    cb3.add(mid);
    cb4.add(mid);

    currentBlock.remove(0);
    currentBlock.remove(0);
    currentBlock.remove(0);
    currentBlock.remove(0);

    currentBlock.add(cb1);
    currentBlock.add(cb2);
    currentBlock.add(cb3);
    currentBlock.add(cb4);

    int x_correction = 0;
    int y_correction = 0;
    int a;
    int b;
    for (int i = 0; i < currentBlock.size(); i++) {
      a = currentBlock.get(i).x;
      b = currentBlock.get(i).y;
      if (a < x_correction) {
        x_correction = a;
      }

      if (b < y_correction) {
        y_correction = b;
      }
    }

    for (int i = 0; i < currentBlock.size(); i++) {
      currentBlock.get(i).x -= x_correction;
      currentBlock.get(i).y -= y_correction;
    }


    x_correction = 9;
    y_correction = 19;
    for (int i = 0; i < currentBlock.size(); i++) {
      a = currentBlock.get(i).x;
      b = currentBlock.get(i).y;
      if (a > x_correction) {
        x_correction = a;
      }

      if (b > y_correction) {
        y_correction = b;
      }
    }

    for (int i = 0; i < currentBlock.size(); i++) {
      currentBlock.get(i).x -= x_correction - 9;
      currentBlock.get(i).y -= y_correction - 19;
    }

    setColor(getColor(currentBlockType));
  }

  void checkCompleteLine() {
    boolean[] linesComplete = new boolean[20];
    for (int i = 0; i < 20; i++) {
      linesComplete[i] = true;
    }


    for (int j = 0; j < 20; j++) {
      for (int i = 0; i < 10; i++) {
        linesComplete[j] &= field.map[i][j].occupied;
      }
    }

    for (int i = 0; i < 20; i++) {
      if (linesComplete[i]) {
        removeLine(i);
      }
    }
  }

  void removeLine(int l) {
    for (int j = l; j >= 1; j--) {
      for (int i = 0; i < 10; i++) {
        field.map[i][j].col = field.map[i][j-1].col;
        field.map[i][j].occupied = field.map[i][j-1].occupied;
      }
    }
    for (int i = 0; i < 10; i++) {
      field.map[i][0].col = backgrnd;
      field.map[i][0].occupied = false;
    }
    score += 200;
    normalSpeed--;
  }

  void left() {
    int a;
    int b;

    for (int i = 0; i < currentBlock.size(); i++) {
      a = currentBlock.get(i).x;
      b = currentBlock.get(i).y;
      if (currentBlock.get(i).x == 0 || field.map[a-1][b].occupied) {
        return;
      }
    }

    removeColor();
    for (int i = 0; i < currentBlock.size(); i++) {
      currentBlock.get(i).x--;
    }
    setColor(getColor(currentBlockType));
  }

  void right() {
    int a;
    int b;

    for (int i = 0; i < currentBlock.size(); i++) {
      a = currentBlock.get(i).x;
      b = currentBlock.get(i).y;
      if (currentBlock.get(i).x == 9 || field.map[a+1][b].occupied) {
        return;
      }
    }

    removeColor();
    for (int i = 0; i < currentBlock.size(); i++) {
      currentBlock.get(i).x++;
    }
    setColor(getColor(currentBlockType));
  }
  
  void showBackground(){
    fill(backgrnd);
    stroke(backgrnd);
    rect((width-field.w)/2-50, (height-field.h)/2-10, field.w+100, field.h+20);
    
  }
  
  void showStats(){
    stroke(0);
    fill(0);
    text(score, 200, 200);
    
  }

  void showGameOver() {
    stroke(0);
    fill(0);
    text("GameOver", width/2, height/2);
  }

  void update() {
    if (!gameOver) {
      tick++;
      score += (60 - speed)/57;
      handleInput();
      if (tick >= speed) {
        tick = 0;
        descendBlock();
      }
    }
  }

  void show() {
    showBackground();
    field.show();
    showStats();
    if (gameOver) {
      showGameOver();
    }
  }

  color getColor(int block) {
    switch(block) {
    case 0:
      return red;
    case 1:
      return gre;
    case 2:
      return pur;
    case 3:
      return blu;
    case 4:
      return ora;
    case 5:
      return ble;
    case 6:
      return yel;
    default:
      return backgrnd;
    }
  }
}