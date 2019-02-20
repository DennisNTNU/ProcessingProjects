import processing.serial.*;

int oldX = 0;
int oldY = 0;
float viewX = 0.0;
float viewY = 0.0;
float viewZ = 0.0;
float scale = 1;

float[] q = {1.0, 0, 0, 0};
float[][] R = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}}; //this R rotates coordinates in body frame to coordinates in inertial frame


Serial port;
boolean newData = false;

void setup() {
  size(1280, 720, P3D);
  textureMode(NORMAL);
  lights();

  printArray(Serial.list());
  if (Serial.list().length != 0) {
    port = new Serial(this, Serial.list()[0], 115200);
  }
  oldX = width/2;
  oldY = height/2;
  oldX = mouseX;
  oldY = mouseY;

  frameRate(120);
}

void draw() {
  lights();
  background(130, 140, 241, 255);
  pushMatrix();
  translate(width/2, height/2, 0);
  scale(scale);
  rotateX(viewX);
  rotateY(viewY);
  rotateZ(viewZ);

  //getInput();
  if (port != null && port.available() >= 40 ) {
    getInput();
  }

  stroke(255, 0, 0, 255);
  line(0, 0, 0, 100, 0, 0);
  stroke(0, 255, 0, 255);
  line(0, 0, 0, 0, -100, 0);
  stroke(0, 0, 255, 255);
  line(0, 0, 0, 0, 0, 100);

  stroke(0, 0, 0, 255);
  fill(70, 200, 14, 155);
  translate(0, 0, -100);
  rect(-500, -500, 1000, 1000);
  translate(0, 0, 100);

  fill(255);

  pushMatrix();
  if (newData) {
    newData = false;
    calcRotationMatrix();
  }
  applyRotMatrix();
  
  /*strokeWeight(10);
  box(50, 50, 50);
  strokeWeight(1);*/
  drawDrone();
  
  popMatrix();

  popMatrix();
}

void drawDrone(){
  
  stroke(255, 0, 0, 255);
  line(0, 0, 0, 60, 0, 0);
  stroke(0, 255, 0, 255);
  line(0, 0, 0, 0, -60, 0);
  stroke(0, 0, 255, 255);
  line(0, 0, 0, 0, 0, 60);
  
  stroke(0);
  box(20, 20, 10);
  pushMatrix();
  rotateZ(3.1459265358979/4);
  box(65, 8, 8);
  box(8, 65, 8);
  popMatrix();
  
}

void getInput() {
  boolean startFound = false;
  int in;
  int i = 0;
  String inString = "";
  String total = "";

  while (port.available() > 0) {
    in = port.read();

    if (startFound) {
      total += char(in);
      if (in == int(';') || in == int(',')) {
        q[i] = float(inString);
        inString = "";
        i++;
      } else {
        inString += char(in);
      } 

      if (i >= 4) {
        newData = true;
        break;
      }
    } else {

      if (char(in) == 's') {
        startFound = true;
      }
    }
  }
  port.clear();


  println(total);
}

void calcRotationMatrix() {

  float len = sqrt(q[0]*q[0] + q[1]*q[1] + q[2]*q[2] + q[3]*q[3]);
  q[0] /= len;
  q[1] /= -len;
  q[2] /= len;
  q[3] /= -len;

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

void applyRotMatrix() {
  applyMatrix(
    R[0][0], R[0][1], R[0][2], 0.0, 
    R[1][0], R[1][1], R[1][2], 0.0, 
    R[2][0], R[2][1], R[2][2], 0.0, 
    0.0, 0.0, 0.0, 1.0 );
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

void keyPressed(){
  
  if(key == 'a'){
    byte[] data = {'+', 'a'};
    port.write(data);
  }
  
}