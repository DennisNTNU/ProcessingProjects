import processing.serial.*;

Serial port;
SbusReadClass readSBUS;

void setup() {
  size(128, 72);
  frameRate(120);
  
  readSBUS = new SbusReadClass();
  printArray(Serial.list());
  if (Serial.list().length != 0) {
    readSBUS.port = new Serial(this, Serial.list()[0], 100000, 'E', 8, 2);
  }

}

void draw() {
  background(151);

  readSBUS.read();
  readSBUS.interpret();
  readSBUS.printData();

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
/*
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
}*/