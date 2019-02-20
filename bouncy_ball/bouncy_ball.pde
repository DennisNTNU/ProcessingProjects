  float m = 1.0;
  float px = 0.0;
  float py = 0.0;
  float vx = 5.0;
  float vy = 0.0;
  float Fx = 0.0;
  float Fy = 0.0;
  float MFx = 0.0;
  float MFy = 0.0;
  float t = 0.0;
  float g = 9.806;
  float dt = 0.1;
  
  float vloseFactorBounce = 0.8;
  float vloseFactorFriction = 0.95;
  
  int pixelX = 1024;
  int pixelY = 768;
  
  int radius = 20;


void setup(){
  size(1024, 768);

  fill(255);
}

void draw(){
  background(255);
  ellipse(px, py, radius * 1.8, radius * 1.8);
  if (mousePressed) {
    Fx = 0.1 * (mouseX - px);
    Fy = m * g + 0.1 * (mouseY - py);
  } else {
    Fx = 0.0;
    Fy = m * g;
  }
  
  vx = vx + Fx * dt / m;
  vy = vy + Fy * dt / m;
  px = px + vx * dt;
  py = py + vy * dt;
  t = t + dt; 
  
  if (py > ( pixelY - radius )) {
    vy = - vloseFactorBounce * vy;
    vx = vloseFactorFriction * vx;
    py = pixelY - radius;
  } else if (py < radius) {
    vy = - vloseFactorBounce * vy;
    vx = vloseFactorFriction * vx;
    py = radius;
  }
  if (px > ( pixelX - radius)) {
    vx = - vloseFactorBounce * vx;
    vy = vloseFactorFriction * vy;
    px = pixelX - radius;
  } else if (px < radius) {
    vx = - vloseFactorBounce * vx;
    vy = vloseFactorFriction * vy;
    px = radius;
  }
}