class Puck {
  float x;
  float y;

  float vx;
  float vy;
  float v;

  float r = 10;

  Puck() {
    x = width/2;
    y = height/2;

    v = 7.0;
    
    float temp = random(-HALF_PI/2, HALF_PI/2);
    vx = v*cos(temp);
    vy = v*sin(temp);
    if(random(100.0) > 50.0){
      vx *= -1;
    }
  }

  void show() {
    stroke(white);
    fill(white);
    ellipse(x, y, 2*r, 2*r);
  }

  void update(float dt) {
    x += dt*vx;
    y += dt*vy;

    if ((y + r) > height) {
      y = height - r - 0.1;
      vy *= -1;
    } else if ((y - r)  < 0) {
      y = r + 0.1;
      vy *= -1;
    }
  }

  void reset(boolean rightScore) {
    x = width/2;
    y = height/2;

    v = (7.0 + v) / 2;
    
    float temp = random(-HALF_PI/2, HALF_PI/2);
    vx = v*cos(temp);
    vy = v*sin(temp);
    if(rightScore){
      vx *= -1;
    }
  }
  
  void resetVelocity(boolean rightBounce, float normalizedHitPos) {
    
    float temp = normalizedHitPos*PI/3;
    vx = v*cos(temp);
    vy = v*sin(temp);
    if(rightBounce){
      vx *= -1;
    }
  }
}