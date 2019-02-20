
int oldX = 0;
int oldY = 0;

float viewX = 0.0;
float viewY = 0.0;
float viewZ = 0.0;
float scale = 1;

float rate = 0.02;
float angle = 0.0;

float inxr = 0;
float inyr = 0;
float inxl = 0;
float inyl = 0;

float dt = 0.1;

float[] q = {1.0, 0.0, 0.0, 0.0};
PVector w = new PVector(0.0, 0.01, 0.0);

float[][] J_ = {{1.0, 0, 0}, {0, 1.0, 0}, {0, 0, 2.0}};
float[][] J_inv_ = {{1.0/J_[0][0], 0, 0}, {0, 1.0/J_[1][1], 0}, {0, 0, 1.0/J_[2][2]}};

float[][] R = new float[3][3];

PVector JJ = calcJ();
PMatrix3D J = new PMatrix3D(JJ.x, 0.0, 0.0, 0.0,
                            0.0, JJ.y, 0.0, 0.0,
                            0.0, 0.0, JJ.z, 0.0,
                            0.0, 0.0, 0.0, 1.0 );
PMatrix3D J_inv = new PMatrix3D(J);

void calcRotationMatrix(float[] q, float[][] R) {
  
  R[0][0] = 1 - 2*q[2]*q[2] - 2*q[3]*q[3];
  R[0][1] = 2*(q[1]*q[2] - q[0]*q[3]);
  R[0][2] = 2*(q[1]*q[3] + q[0]*q[2]);
  R[1][0] = 2*(q[1]*q[2] + q[0]*q[3]);
  R[1][1] = 1 - 2*q[1]*q[1] - 2*q[3]*q[3];
  R[1][2] = 2*(q[2]*q[3] - q[0]*q[1]);
  R[2][0] = 2*(q[1]*q[3] - q[0]*q[2]);
  R[2][1] = 2*(q[2]*q[3] + q[0]*q[1]);
  R[2][2] = 1 - 2*q[1]*q[1] - 2*q[2]*q[2];
  
}

void setup() {
  J_inv.invert();
  size(1280, 720, P3D);
  textureMode(NORMAL);
  lights();
  
  oldX = width/2;
  oldY = height/2;
  oldX = mouseX;
  oldY = mouseY;
  
  //PVector a = new PVector(1.0, 2.0, 3.0);
  //PVector b = new PVector(1.0, 2.0, 3.0);
  //J.mult(a, b);
  println(J.m00, J.m01, J.m02);
  println(J.m10, J.m11, J.m12);
  println(J.m20, J.m21, J.m22);
  
  println(J_inv.m00, J_inv.m01, J_inv.m02);
  println(J_inv.m10, J_inv.m11, J_inv.m12);
  println(J_inv.m20, J_inv.m21, J_inv.m22);
}


void draw() {
  lights();
  background(60, 163, 246, 255);
  pushMatrix();
  translate(width/2, height/2, 0);
  scale(scale);
  rotateX(viewX);
  rotateY(viewY);
  rotateZ(viewZ);
  
  
  axes();
    PVector tau = new PVector(0, 0, 0);
    //tau.add(w);
    //tau.mult(-0.001);
    
    PVector Jwxw = new PVector();
    J.mult(w, Jwxw);
    PVector.cross(Jwxw, w, Jwxw);
    PVector alpha = new PVector(0.0, 0.0, 0.0);
    J_inv.mult(tau.add(Jwxw), alpha);
    
    w.add(alpha.mult(dt));
    
    q[0] -= 0.5*dt*( q[1]*w.x + q[2]*w.y + q[3]*w.z);
    q[1] += 0.5*dt*( q[0]*w.x - q[3]*w.y + q[2]*w.z);
    q[2] += 0.5*dt*( q[3]*w.x + q[0]*w.y - q[1]*w.z);
    q[3] += 0.5*dt*(-q[2]*w.x + q[1]*w.y + q[0]*w.z);
    
    float qNorm = sqrt(q[0]*q[0] + q[1]*q[1] + q[2]*q[2] + q[3]*q[3]);
    q[0] /= qNorm;
    q[1] /= qNorm;
    q[2] /= qNorm;
    q[3] /= qNorm;
    
  calcRotationMatrix(q, R);
  
  pushMatrix();
  applyMatrix( R[0][0], R[0][1], R[0][2], 0.0,
               R[1][0], R[1][1], R[1][2], 0.0,
               R[2][0], R[2][1], R[2][2], 0.0,
                   0.0,     0.0,     0.0, 1.0 );
  fill(160, 160, 200);
  //box(50*J.m00, 50*J.m11, 50*J.m22);
  box(10,10,120);
  pushMatrix();
  translate(0.0, -75.0/2, 0.0);
  box(5.0, 75.0, 5.0);
  popMatrix();
  axes();
  popMatrix();

  drawBoxPillars();
  drawFloor();

  popMatrix();
}

void drawFloor() {
  noLights();
  pushMatrix();

  fill(30, 170, 60, 255);
  translate(0, 0, -300);
  rect(-2000, -2000, 4000, 4000);
  fill(255);

  popMatrix();
  lights();
}

void drawBoxPillars() {
  float[] xes = {-1500, 1500, -1500, 1500};
  float[] ys = {-1500, -1500, 1500, 1500};
  for (int i = 0; i < 4; i++) {
    pushMatrix();
    translate(xes[i], ys[i], 0);
    drawBoxes();
    popMatrix();
  }
}

void drawBoxes() {
  pushMatrix();
  translate(0, 0, 450);
  for (int i = 1; i <= 10; i++) {
    translate(0, 0, -25.0*sqrt(i));

    pushMatrix();
    rotateZ(angle);
    fill(60, 60, 60, 125);
    box(40+2*i, 40 + 2*i, 40+i);
    popMatrix();
  }
  popMatrix();
}

void mouseDragged() {
  float dx = mouseX - oldX;
  float dy = mouseY - oldY;

  viewZ -= 0.01*dx;
  viewX -= 0.01*dy;
  //viewX -= 0.01*dy;
  //viewY -= 0.01*dx;

  oldX += dx;
  oldY += dy;
}

void mouseMoved() {
  oldX = mouseX;
  oldY = mouseY;
}

void mouseWheel(MouseEvent event) {
  scale *= 1 - 0.1*event.getCount();
  strokeWeight(1.0/scale);
}

void keyPressed() {
  switch (key) {
  case 'p':
  case 'P':
    w.y = 2.0;
    w.z = -0.00004;
    break;
  case 'w':
  case 'W':
    inxr = 500;
    break;
  case 's':
  case 'S':
    inxr = -500;
    break;
  case 'a':
  case 'A':
    inyr = 500;
    break;
  case 'd':
  case 'D':
    inyr = -500;
    break;
  }
}

void keyReleased() {
  switch (key) {
  case 'w':
  case 'W':
    inxr = 0;
    break;
  case 's':
  case 'S':
    inxr = 0;
    break;
  case 'a':
  case 'A':
    inyr = 0;
    break;
  case 'd':
  case 'D':
    inyr = 0;
    break;
  }
}

void axes() {
  stroke(125, 40, 40, 255);
  line(-150, 0, 0, 0);
  stroke(255, 0, 0, 255);
  line(0, 0, 150, 0);

  stroke(40, 125, 40, 255);
  line(0, -150, 0, 0);
  stroke(0, 255, 0, 255);
  line(0, 0, 0, 150);

  stroke(40, 40, 125, 255);
  line(0, 0, -150, 0, 0, 0);
  stroke(0, 0, 255, 255);
  line(0, 0, 0, 0, 0, 150);
  
  stroke(0);
}

PVector calcJ()
{
  float r1 = 0.01*8;
  float r2 = 0.005*8;
  float h1 = 0.12*8;
  float h2 = 0.075*8;
  float m1 = 0.070*8;
  float m2 = 0.025*8;
  
  float Jxx = m1*(3*r1*r1 + h1*h1)/12 + m2*(3*r2*r2 + h2*h2)/12 + m2*h2*h2/4;
  float Jyy = m1*(3*r1*r1 + h1*h1)/12 + m2*r2*r2/2;
  float Jzz = m1*r1*r1/2 + m2*(3*r2*r2 + h2*h2)/12 + m2*h2*h2/4;
  
  return new PVector(Jxx, Jyy, Jzz);
}