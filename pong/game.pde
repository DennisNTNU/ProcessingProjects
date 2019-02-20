class Game {
  Paddle paddleL;
  Paddle paddleR;
  Puck puck;

  int startDelay;
  boolean started;

  int leftPoints;
  int rightPoints;

  boolean puckMoveDirection; //true == moving to the right

  boolean[] input = {false, false, false, false};

  Game() {
    paddleL = new Paddle(30);
    paddleR = new Paddle(width - 30);
    puck = new Puck();
    startDelay = 80;
    started = false;

    if (puck.vx > 0.0) {
      puckMoveDirection = true;
    } else {
      puckMoveDirection = false;
    }

    leftPoints = 0;
    rightPoints = 0;
  }

  void show() {
    drawBackground();
    paddleL.show();
    paddleR.show();
    puck.show();
  }

  void update(float dt) {
    startDelay--;
    if (startDelay < 0) {
      puck.update(dt);
    }
    updatePaddles(dt);

    if (puck.x < 0) {
      rightScore();
    } else if (puck.x > width) {
      leftScore();
    }

    if (puck.x < width/2) {
      if (collidedWithLeftPaddle() && !puckMoveDirection) {

        float normalizedHitPosition = (puck.y - paddleL.y)/(paddleL.h + puck.r);
        puck.v += 0.2;
        puck.resetVelocity(false, normalizedHitPosition);

        puckMoveDirection = !puckMoveDirection;
      }
    } else {
      if (collidedWithRightPaddle() && puckMoveDirection) {

        float normalizedHitPosition = (puck.y - paddleR.y)/(paddleR.h + puck.r);
        puck.v += 0.2;
        puck.resetVelocity(true, normalizedHitPosition);

        puckMoveDirection = !puckMoveDirection;
      }
    }
  }

  void drawBackground() {
    stroke(white);
    textSize(20);
    textAlign(CENTER);
    text(str(leftPoints), width/2 - 40, 40);
    text(str(rightPoints), width/2 + 40, 40);
    float numLines = height / 30.0;
    for (int i = 0; i < numLines; i++) {
      strokeWeight(2);
      stroke(white);
      line(width/2, height - i*height/numLines - 10, width/2, height - (i + 1)*height/numLines + 10);
    }
  }

  void rightScore() {
    resetPuck(true);
    rightPoints++;
  }

  void leftScore() {
    resetPuck(false);
    leftPoints++;
  }

  boolean collidedWithLeftPaddle() {
    if (puck.y < (paddleL.y + paddleL.h/2) && puck.y > (paddleL.y - paddleL.h/2)) {
      if (puck.x < (paddleL.x + paddleL.w/2 + puck.r) && puck.x > paddleL.x) {
        return true;
      }
    } else if (puck.y < (paddleL.y - paddleL.h/2) && puck.y > (paddleL.y - paddleL.h/2 - puck.r)) {
      if (puck.x > (paddleL.x + paddleL.w/2)) {
        if (sqrt(pow(puck.x - paddleL.x - paddleL.w/2, 2) + pow(puck.y - paddleL.y + paddleL.h/2, 2)) < puck.r) {
          return true;
        }
      } else if (puck.x < paddleL.x) {
        return true;
      }
    } else if (puck.y > (paddleL.y + paddleL.h/2) && puck.y < (paddleL.y + paddleL.h/2 + puck.r)) {
      if (puck.x > (paddleL.x + paddleL.w/2)) {
        if (sqrt(pow(puck.x - paddleL.x - paddleL.w/2, 2) + pow(puck.y - paddleL.y - paddleL.h/2, 2)) < puck.r) {
          return true;
        }
      } else if (puck.x > paddleL.x) {
        return true;
      }
    }
    return false;
  }

  boolean collidedWithRightPaddle() {
    if (puck.y < (paddleR.y + paddleR.h/2) && puck.y > (paddleR.y - paddleR.h/2)) {
      if (puck.x > (paddleR.x - paddleR.w/2 - puck.r) && puck.x < paddleR.x) {
        return true;
      }
    } else if (puck.y < (paddleR.y - paddleR.h/2) && puck.y > (paddleR.y - paddleR.h/2 - puck.r)) {
      if (puck.x < (paddleR.x + paddleR.w/2)) {
        if (sqrt(pow(puck.x - paddleR.x - paddleR.w/2, 2) + pow(puck.y - paddleR.y + paddleR.h/2, 2)) < puck.r) {
          return true;
        }
      } else if (puck.x > paddleR.x) {
        return true;
      }
    } else if (puck.y > (paddleR.y + paddleR.h/2) && puck.y < (paddleR.y + paddleR.h/2 + puck.r)) {
      if (puck.x < (paddleR.x - paddleR.w/2)) {
        if (sqrt(pow(puck.x - paddleR.x + paddleR.w/2, 2) + pow(puck.y - paddleR.y - paddleR.h/2, 2)) < puck.r) {
          return true;
        }
      } else if (puck.x > paddleR.x) {
        return true;
      }
    }
    return false;
  }

  void resetPuck(boolean rightScore) {
    startDelay = 80;
    started = false;
    puck.reset(rightScore);
    if (puck.vx > 0.0) {
      puckMoveDirection = true;
    } else {
      puckMoveDirection = false;
    }
  }

  void updatePaddles(float dt) {
    if (input[0]) {
      paddleL.y += 7*dt;
    }

    if (input[1]) {
      paddleL.y -= 7*dt;
    }
    
    if (input[2]) {
     paddleR.y += 7*dt;
     }
     
     if (input[3]) {
     paddleR.y -= 7*dt;
     }

    if (puckMoveDirection) {
      if (paddleR.y < (puck.y - paddleR.h/3)) {
        paddleR.y += 3*dt;
      } else if (paddleR.y > (puck.y + paddleR.h/3)) {
        paddleR.y -= 3*dt;
      }
    }


    if (paddleL.y < paddleL.h/2 + 10) {
      paddleL.y = paddleL.h/2 + 10;
    }
    if (paddleR.y < paddleR.h/2 + 10) {
      paddleR.y = paddleR.h/2 + 10;
    }

    if (paddleL.y > height - paddleL.h/2 - 10) {
      paddleL.y = height - paddleL.h/2 - 10;
    }
    if (paddleR.y > height - paddleR.h/2 - 10) {
      paddleR.y = height - paddleR.h/2 - 10;
    }
  }

  void keyPress(char k) {
    switch (k) {
    case 'a':
      input[0] = true;
      break;
    case 'q':
      input[1] = true;
      break;
    case 'l':
      input[2] = true;
      break;
    case 'p':
      input[3] = true;
      break;
    default:
      break;
    }
  }

  void keyRelease(char k) {
    switch (k) {
    case 'a':
    case 'A':
      input[0] = false;
      break;
    case 'q':
    case 'Q':
      input[1] = false;
      break;
    case 'l':
    case 'L':
      input[2] = false;
      break;
    case 'p':
    case 'P':
      input[3] = false;
      break;
    default:
      break;
    }
  }
}