import processing.serial.*;

int oldX = 0;
int oldY = 0;
float viewX = 0.0;
float viewY = 0.0;
float viewZ = 0.0;
float scale = 1;

ArrayList<PVector> iterations = new ArrayList();

void setup() {
  size(1280, 720, P3D);
  textureMode(NORMAL);
  lights();



  iterations.add(new PVector(420, 260));


  oldX = width/2;
  oldY = height/2;
  oldX = mouseX;
  oldY = mouseY;

  frameRate(60);
}

void draw() {
  lights();
  background(201, 140, 131, 255);
  pushMatrix();
  translate(width/2, height/2, 0);
  scale(scale);
  rotateX(viewX);
  rotateY(viewY);
  rotateZ(viewZ);

  drawObjective();
  drawIterations();
/*
  stroke(255, 0, 0, 255);
  line(0, 0, 0, 100, 0, 0);
  stroke(0, 255, 0, 255);
  line(0, 0, 0, 0, -100, 0);
  stroke(0, 0, 255, 255);
  line(0, 0, 0, 0, 0, 100);*/



  stroke(0, 0, 0, 255);
  //fill(70, 200, 14, 155);
  fill(120, 10, 14, 155);
  //translate(0, 0, -100);
  rect(-500, -500, 1000, 1000);
  //translate(0, 0, 100);

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

void calcNextIterate() {
  PVector currIt = iterations.get(iterations.size()-1);

  float dx = 0.2; //same as dy

  float o_dxy = objective(currIt.x - dx, currIt.y);
  float ox_dy = objective(currIt.x, currIt.y - dx);
  float oxy   = objective(currIt.x, currIt.y);
  float odxy  = objective(currIt.x + dx, currIt.y);
  float oxdy  = objective(currIt.x, currIt.y + dx);
  float odxdy = objective(currIt.x + dx, currIt.y + dx);

  PVector grad_o = new PVector((odxy - o_dxy)/(2*dx), (oxdy - ox_dy)/(2*dx));
  //float[][] hess_o = {{0.0, 0.0}, {0.0, 0.0}};
  float hess_o00 = (odxy - 2*oxy + o_dxy) / (dx*dx) + 0.045;
  float hess_o11 = (oxdy - 2*oxy + ox_dy) / (dx*dx) + 0.045;
  float hess_o01 = (odxdy - odxy - oxdy + oxy) / (dx*dx);
  float hess_o10 = hess_o01;

  float det = hess_o00 * hess_o11 - hess_o01 * hess_o10;
  float hess00_inv = 0.0;
  float hess01_inv = 0.0;
  float hess10_inv = 0.0;
  float hess11_inv = 0.0;

  if (det == 0.0) {
    hess00_inv = 1.0;
    hess01_inv = 0.0;
    hess10_inv = 0.0;
    hess11_inv = 1.0;
  } else {
    hess00_inv =  hess_o11 / det;
    hess01_inv = -hess_o01 / det;
    hess10_inv = -hess_o10 / det;
    hess11_inv =  hess_o00 / det;
  }

  PVector step = new PVector();
  step.x = - ((hess00_inv + 1)*grad_o.x + hess01_inv*grad_o.y);
  step.y = - (hess10_inv*grad_o.x + (hess11_inv + 1)*grad_o.y);

  float stepSize = 1.0;
  float o = objective(currIt.x + stepSize*step.x, currIt.y + stepSize*step.y);

  println(o, ";", oxy, ";", 0.5*stepSize*(step.x*grad_o.x + step.y*grad_o.y), ";", (oxy + 0.5*stepSize*(step.x*grad_o.x + step.y*grad_o.y)));

  int itrtns = 0;
  while (o > (oxy + 0.5*stepSize*(step.x*grad_o.x + step.y*grad_o.y))) {
    itrtns++;
    stepSize /= 1.5;
    o = objective(currIt.x + stepSize*step.x, currIt.y + stepSize*step.y);
  }

  //println(hess_o);
  println(hess_o00, ";", hess_o10, ";", hess_o01, ";", hess_o11);
  println(hess00_inv, ";", hess10_inv, ";", hess01_inv, ";", hess11_inv);
  print(step, "; ");
  print(grad_o, "; ");
  print(det, "; ");
  println(itrtns);

  iterations.add(new PVector(currIt.x + stepSize*step.x, currIt.y + stepSize*step.y));
}

void keyPressed() {
  switch (key) {
  case 'n':
    calcNextIterate();
    break;  
  case 'r':
    resetIterates();
    break;
  }
}

void drawIterations() {
  fill(51, 151, 51, 255);
  int numIt = iterations.size();

  for (int i = 0; i < numIt; i++) {
    PVector it = iterations.get(i);
    pushMatrix();
    translate(it.x, it.y, objective(it.x, it.y));
    sphere(3);
    popMatrix();
  }
}

void resetIterates() {
  int l = iterations.size();
  for (int i = 0; i < l; i++) {
    iterations.remove(0);
  }
  iterations.add(new PVector(random(-400, 400), random(-400, 400)));
}

void drawObjective() {
  noStroke();
  fill(151, 51, 51, 255);

  float xmin = -500;
  float xmax = 500;
  float ymin = -500;
  float ymax = 500;

  int sx = 100;
  int sy = 100;

  float dx = (xmax-xmin)/sx;
  float dy = (ymax-ymin)/sy;

  float x = 0.0;
  float y = 0.0;

  for (int i = 0; i < sx; i++) {
    for (int j = 0; j < sy; j++) {
      x = xmin + i*dx;
      y = ymin + j*dy;

      beginShape();

      vertex(x, y, objective(x, y));
      vertex(x + dx, y, objective(x + dx, y));
      vertex(x + dx, y + dy, objective(x + dx, y + dy));
      vertex(x, y + dy, objective(x, y + dy));

      endShape();
    }
  }
}

float objective(float x, float y) {

  float o = 0.0;
  float d = sqrt(x*x + y*y)/50;
  //d = (d*d + d + 1) / (d + 1) - 1;
  o = sin(2*3.14159*sqrt(x*x + y*y)/400);
  o = 65*o*o + 50*(d*d + d + 1) / (d + 1) - 50; 
  return o;
}