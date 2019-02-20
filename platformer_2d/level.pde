

class Level {
  Background b;
  Background b1;
  Player p;
  InputManager im;
  PVector force;
  float gravity;
  int currentLevel;

  boolean levelSaved = false;

  boolean groundCollision = false;
  boolean ceilCollision = false;
  boolean leftCollision = false;
  boolean rightCollision = false;

  int numUpdates = 0;
  
  int[] collisionTileUL = {-1, -1};
  int[] collisionTileUR = {-1, -1};
  int[] collisionTileLL = {-1, -1};
  int[] collisionTileLR = {-1, -1};

  Level(int x, int y) {
    b = new Background(x, y);
    p = new Player();
    im = new InputManager();
    force = new PVector(0, 0);
    gravity = 2;
    currentLevel = 1;
    b.load(currentLevel);
  }

  void update(float dt) {

    im.update();
  
    if(numUpdates % 30 == 0){
      println(b.exitTile[0], " ", b.exitTile[1], " | ", reachedExit());
    }


    force.y += gravity;

    p.update(force, dt);
    force.x = 0;
    force.y = 0;

    correctPosition(p.a);
    correctPosition(p.a);

    collisionHandling();

    numUpdates++;
  }

  void correctPosition(Agent a) {

    //getting the tile indices of the corners of the player
    collisionTileUL[0] = int((a.pos.x - a.boundingBox.x/2) / ( width / b.x));
    collisionTileUL[1] = int((a.pos.y - a.boundingBox.y/2) / (height / b.y));

    collisionTileUR[0] = int((a.pos.x + a.boundingBox.x/2) / ( width / b.x));
    collisionTileUR[1] = int((a.pos.y - a.boundingBox.y/2) / (height / b.y));

    collisionTileLL[0] = int((a.pos.x - a.boundingBox.x/2) / ( width / b.x));
    collisionTileLL[1] = int((a.pos.y + a.boundingBox.y/2) / (height / b.y));

    collisionTileLR[0] = int((a.pos.x + a.boundingBox.x/2) / ( width / b.x));
    collisionTileLR[1] = int((a.pos.y + a.boundingBox.y/2) / (height / b.y));

    PVector ULcorrection = new PVector(0, 0);
    PVector URcorrection = new PVector(0, 0);
    PVector LLcorrection = new PVector(0, 0);
    PVector LRcorrection = new PVector(0, 0);

    //calculate the correction displacements for each tile, if the tile is a non walkable tile
    if (!isTileWalkable(collisionTileUL[0], collisionTileUL[1])) {
      ULcorrection.x = (collisionTileUL[0] + 1) *  width / b.x - (a.pos.x - a.boundingBox.x/2);
      ULcorrection.y = (collisionTileUL[1] + 1) * height / b.y - (a.pos.y - a.boundingBox.y/2);
    }
    if (!isTileWalkable(collisionTileUR[0], collisionTileUR[1])) {
      URcorrection.x = collisionTileUR[0]       *  width / b.x - (a.pos.x + a.boundingBox.x/2);
      URcorrection.y = (collisionTileUR[1] + 1) * height / b.y - (a.pos.y - a.boundingBox.y/2);
    }
    if (!isTileWalkable(collisionTileLL[0], collisionTileLL[1])) {
      LLcorrection.x = (collisionTileLL[0] + 1) *  width / b.x - (a.pos.x - a.boundingBox.x/2);
      LLcorrection.y = collisionTileLL[1]       * height / b.y - (a.pos.y + a.boundingBox.y/2);
    }
    if (!isTileWalkable(collisionTileLR[0], collisionTileLR[1])) {
      LRcorrection.x = collisionTileLR[0] *  width / b.x - (a.pos.x + a.boundingBox.x/2);
      LRcorrection.y = collisionTileLR[1] * height / b.y - (a.pos.y + a.boundingBox.y/2);
    }

    //find the biggest correction displacement
    int whosCorrectionIsBiggest = 0;
    float biggest = ULcorrection.mag();
    if (biggest < URcorrection.mag()) {
      biggest = URcorrection.mag();
      whosCorrectionIsBiggest = 1;
    }
    if (biggest < LLcorrection.mag()) {
      biggest = LLcorrection.mag();
      whosCorrectionIsBiggest = 2;
    }
    if (biggest < LRcorrection.mag()) {
      biggest = LRcorrection.mag();
      whosCorrectionIsBiggest = 3;
    }

    //apply the correction displacement
    if (biggest > 0.1) {
      switch (whosCorrectionIsBiggest) {
      case 0:
        if (abs(ULcorrection.x) < abs(ULcorrection.y)) {
          a.pos.x += 1.1*ULcorrection.x;
          a.vel.x = 0;
          leftCollision = true;
        } else {
          a.pos.y += 1.1*ULcorrection.y;
          a.vel.y = 0;
          ceilCollision = true;
        }
        break;
      case 1:
        if (abs(URcorrection.x) < abs(URcorrection.y)) {
          a.pos.x += 1.1*URcorrection.x;
          a.vel.x = 0;
          rightCollision = true;
        } else {
          a.pos.y += 1.1*URcorrection.y;
          a.vel.y = 0;
          ceilCollision = true;
        }
        break;
      case 2:
        if (abs(LLcorrection.x) < abs(LLcorrection.y)) {
          a.pos.x += 1.1*LLcorrection.x;
          a.vel.x = 0;
          leftCollision = true;
        } else {
          a.pos.y += 1.1*LLcorrection.y;
          a.vel.y = 0;
          groundCollision = true;
        }
        break;
      case 3:
        if (abs(LRcorrection.x) < abs(LRcorrection.y)) {
          a.pos.x += 1.1*LRcorrection.x;
          a.vel.x = 0;
          rightCollision = true;
        } else {
          a.pos.y += 1.1*LRcorrection.y;
          a.vel.y = 0;
          groundCollision = true;
        }
        break;
      }
    }
  }

  void collisionHandling() {
    if (ceilCollision || leftCollision || rightCollision) {
      println(numUpdates, ": Collision");
    }
    if (groundCollision) {
      p.a.vel.x *= 0.9;
    }
    


    groundCollision = false;
    ceilCollision = false;
    leftCollision = false;
    rightCollision = false;
  }

  boolean reachedExit(){
    return collisionTileUL == b.exitTile || collisionTileUR == b.exitTile || collisionTileLL == b.exitTile || collisionTileLR == b.exitTile;
  }

  boolean isTileWalkable(int i, int j) {
    if (i < 0 || i >= b.x) {
      return true;
    }

    if (j < 0 || j >= b.y) {
      return true;
    }

    return b.map[i][j].walkable;
  }

  void handleInput() {
    if (im.keyDown['w'] || im.keyDown['W']) {
      force.y -= 4;
    }

    if (im.keyDown['a'] || im.keyDown['A']) {
      force.x -= 1.5;
    }

    if (im.keyDown['s'] || im.keyDown['S']) {
      force.y += 1.5;
    }

    if (im.keyDown['d'] || im.keyDown['D']) {
      force.x += 1.5;
    }

    if (im.keyPress['t']) {
      b.terskel();
    }

    if (im.keyPress['o']) {
      if (!levelSaved) {
        levelSaved = true;
        b.export();
      }
    }

    if (im.keyPress[' ']) {
      println("space");
      p.a.vel.y -= 35;
    }
  }

  void keyDown(char i) {
    im.keyDown(i);
  }
  void keyUp(char i) {
    im.keyUp(i);
  }

  void show() {
    b.show();
    p.show();
  }
}