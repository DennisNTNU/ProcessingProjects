import processing.serial.*;
int i = 0;

int oldX = 0;
int oldY = 0;

float viewX = 0.0;
float viewY = 0.0;
float viewZ = 0.0;
float scale = 1;

float rate = 0.02;
float angle = 0.0;

float yaw = 0.0;
float pitch = 0.0;

float inxr = 0;
float inyr = 0;
float inxl = 0;
float inyl = 0;

float dt = 0.1;

Satellite sat = new Satellite();
Quadrotor quad = new Quadrotor();

Serial port;

void setup() {
  size(1280, 720, P3D);
  textureMode(NORMAL);
  lights();

  printArray(Serial.list());
  if (Serial.list().length != 0) {
    port = new Serial(this, Serial.list()[0], 115200);
  }

  sat.tex = loadImage("ips test.png");

  oldX = width/2;
  oldY = height/2;
  oldX = mouseX;
  oldY = mouseY;
}

void draw() {
  i++;

  if (port != null) {
    getInput();
  }

  if (i % 30 == 0) {
    println(inxr, " ; ", inyr, " ; ", inxl, " ; ", inyl);

    //println(quad.am.x, " ; ", quad.am.y, " ; ", quad.am.z);
    println(quad.am_est.x, " ; ", quad.am_est.y, " ; ", quad.am_est.z);
  }
  lights();

  background(151);
  pushMatrix();
  translate(width/2, height/2, 0);
  scale(scale);
  rotateX(viewX);
  rotateY(viewY);
  rotateZ(viewZ);

  //drawBoxes();
  drawBoxPillars();
  drawFloor();

  quad.updatedq(inxr, inyr);
  //inxr *= 0.9;
  //inyr *= 0.9;
  quad.updatedp(inxl, inyl);
  inxl *= 0.6;
  inyl *= 0.6;


  sat.torqueInput(90*(sin(0.05*i) + cos(0.03*i)), 120*cos(0.07*i)*cos(0.08*i));
  //sat.updatepd(-inxl, -inyl);
  sat.setpd(1100*sin(0.01*i), 800*cos(0.003*i), 500.0 + 200*sin(0.02*i));

  sat.update(dt);
  sat.show();

  quad.update(dt);
  quad.show();

  popMatrix();
}

void drawFloor() {
  noLights();
  pushMatrix();

  fill(78);
  translate(0, 0, -300);
  rect(-2000, -2000, 4000, 4000);
  fill(255);

  popMatrix();
  lights();
}

void drawBoxPillars() {
  angle += rate;
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
  translate(0, 0, 1000);
  for (int i = 1; i <= 10; i++) {
    translate(0, 0, -50.0*sqrt(i));

    pushMatrix();
    rotateZ(angle);
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

void getInput() {

  int number = 0;
  int in;
  String inString = "";


  while (port.available() > 0) {
    in = port.read();
    if (in == int(',') || in == int(';')) { //ASCII code for ',' is 44
      switch (number) {
      case 0:
        inxr = float(inString);
        inString = "";
        number++;
        break;
      case 1:
        inyr = float(inString);
        inString = "";
        number++;
        break;
      case 2:
        inxl = float(inString);
        inString = "";
        number++;
        break;
      case 3:
        inyl = float(inString);
        inString = "";
        number++;
        break;
      default:
        break;
      }
    } else {
      inString += char(in);
    }

    if (in == int(';')) {
      break;
    }
  }
}