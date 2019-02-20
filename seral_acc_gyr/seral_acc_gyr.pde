import processing.serial.*;

int oldX = 0;
int oldY = 0;
float viewX = 0.0;
float viewY = 0.0;
float viewZ = 0.0;
float scale = 1;

PVector camVel;
PVector camPos;

Serial port;

Box box;

void setup() {
  size(1280, 720, P3D);
  textureMode(NORMAL);
  lights();

  box = new Box();

  printArray(Serial.list());
  if (Serial.list().length != 0) {
    box.port = new Serial(this, Serial.list()[0], 38400);
  }

  camVel = new PVector(0, 0, 0);
  camPos = new PVector(0, 0, 0);
  oldX = width/2;
  oldY = height/2;
  oldX = mouseX;
  oldY = mouseY;
}

void draw() {
  lights();
  background(151);
  pushMatrix();
  translate(width/2, height/2, 0);


  camPos.add(camVel);
  translate(camPos.x, camPos.y, camPos.z);
  scale(scale);
  rotateX(viewX);
  rotateY(viewY);
  rotateZ(viewZ);

  //translate(-camPos.x, -camPos.y, -camPos.z);



  box.update();
  box.show();

  drawFloor();

  popMatrix();
}

void drawFloor() {
  noLights();
  pushMatrix();

  fill(78, 78, 78, 55);
  stroke(0);
  translate(0, 0, -300);
  rect(-2000, -2000, 4000, 4000);
  fill(255);

  popMatrix();
  lights();
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
    camVel.z += 10.0;
    break;
  case 'W':
    camVel.z += 100.0;
    break;
  case 's':
    camVel.z -= 10.0;
    break;
  case 'S':
    camVel.z -= 100.0;
    break;
  case 'a':
    camVel.x += 10.0;
    break;
  case 'A':
    camVel.x += 100.0;
    break;
  case 'd':
    camVel.x -= 10.0;
    break;
  case 'D':
    camVel.x -= 100.0;
    break;
  }
}

void keyReleased() {
  switch (key) {
  case 'w':
    camVel.z -= 10.0;
    break;
  case 'W':
    camVel.z -= 100.0;
    break;
  case 's':
    camVel.z += 10.0;
    break;
  case 'S':
    camVel.z += 100.0;
    break;
  case 'a':
    camVel.x -= 10.0;
    break;
  case 'A':
    camVel.x -= 100.0;
    break;
  case 'd':
    camVel.x += 10.0;
    break;
  case 'D':
    camVel.x += 100.0;
    break;
  }
}
