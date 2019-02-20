
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

Fireworks fireworks;

void setup() {
  size(1280, 720, P3D);
  textureMode(NORMAL);
  lights();
  
  fireworks = new Fireworks(15);
  
  oldX = width/2;
  oldY = height/2;
  oldX = mouseX;
  oldY = mouseY;
}

void draw() {
  lights();
  background(8, 43, 106, 255);
  pushMatrix();
  translate(width/2, height/2, 0);
  scale(scale);
  rotateX(viewX);
  rotateY(viewY);
  rotateZ(viewZ);
  
  
  axes();

  drawBoxPillars();
  drawFloor();
  
  fireworks.update(dt);
  fireworks.show();

  popMatrix();
}

void drawFloor() {
  noLights();
  pushMatrix();

  fill(3, 38, 15, 255);
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
    fill(3, 3, 3, 125);
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
  line(-50, 0, 0, 0);
  stroke(255, 0, 0, 255);
  line(0, 0, 50, 0);

  stroke(40, 125, 40, 255);
  line(0, -50, 0, 0);
  stroke(0, 255, 0, 255);
  line(0, 0, 0, 50);

  stroke(40, 40, 125, 255);
  line(0, 0, -50, 0, 0, 0);
  stroke(0, 0, 255, 255);
  line(0, 0, 0, 0, 0, 50);
  
  stroke(0);
}