


float x1 = 10;
float x2 = -5;
float x1old = 0;
float x2old = 0;

float dx1 = 0;
float dx2 = 0;
float dx = 0;

//non symetric boundaries not supported
float x1min = -6;
float x2min = -6;
float x1max = 6;
float x2max = 6;

float x1range = x1max - x1min;
float x2range = x2max - x2min;
float x1offset = 0;
float x2offset = 0;

float scleX = 100;
float scleY = 100;

float tmin = 0;
float dt = 0.02;
float tmax = 20;

float input = 2.25;
float kp = 3;
float m = 4;

float h(float x1) {
  return 5.1666666*x1 - 8*x1*x1 + 3.3333333 *x1*x1*x1;
}

float d(float x2) {
  if (x2 > 0) {
    return 3.0;
  } else if ( x2 < 0) {
    return -3.0;
  } else {
    return 0.0;
  }
}

float f(float x1, float x2, float t) {
  float a = 2.0;
  float b = 3.0;
  //return -h(x1) + x2;
  //return x2;
  //return x1 * (input - x1*x1 - x2*x2) - x2;
  //return x1*(input + x1*x1+x2*x2-(x1*x1+x2*x2)*(x1*x1+x2*x2)) - x2;
  //return x2;
  //return x2;
  //return x1;
  //return x2-kp*x1;
  //return x2;
  
  //return x1*(a - b * x2);
  //return x2;
  //return - x1 - 2 * x2;
  //return 4*x1*x1*x2 - x1*(x1*x1 + 2*x2*x2 - 4);
  //return -x1*x1 - 2*x1*x2 -2*x1 - 4*x2;
  //return -6*x1;
  //return (x1*x1 - 1)*(x2-1);
  //return x2-x1*x1*x1*x1 + 1;
  //return x1*(x2 - 3);
  //return x2;
  //return 2*x1*x2 + x1*x1*x1;
  //return (x1*x1-1)*(3*x2*x2-1);
  //return x2;
  //return 1;
  //return x2 - x1*(5 - 3*x1 + x1*x1/2); //tunnel diode
  return x2;
  
}

float g(float x1, float x2, float t) {
  float g = 3.5f;
  float d = 3.5f;
  //return -x1-2*x2+input;
  //return -x1 + d*(1 - x1*x1)*x2;
  //return x2 * (input - x1*x1 - x2*x2) + x1;
  //return x2*(input + x1*x1+x2*x2-(x1*x1+x2*x2)*(x1*x1+x2*x2)) + x1;
  //return input * x2 + x1 - x1*x1 + x1*x2;
  //return -2*x1;
  //return -(-x1 + x2*(1-x1*x1+0.1*x2*x2*x2*x2));
  //return x1 - x2 - 2*x1;
  //return -x2 + x2 - 0.5*x2 - kp*x1;
  //return -1 + (1-x2) - x2;
  
  //return -x2 * (g - d * x1);
  //return - 5 * x1 - d(x2);
  //return -2*x2;
  //return -2*x1*x1*x1 - x2*(x1*x1 + 2*x2*x2 - 4);
  //return -16*x2 - 16*x1*x2 - 8*x2*x2;
  //return 2*x1 - 6*x2 - 2*x2*x2*x2;
  //return -d*x2 - g*(1-1/pow(x1,1.4f));
  //return -d*x2 - g*(1-1/x1);
  //return 8*x1*x2;
  
  //return -g*x1/abs(x1) - d*x2/abs(x2);
  //return x1*x1/4 - x2 - 2;
  //return x2*x2 - 1;
  //return x2 + x1*x1*x1*x1 - 1;
  //return x2*(2-x1);
  //return -x1 - x2*x2;
  //return x1*x1 + x2 - x2*x2 + x2*x2*x2;
  //return 1 + x1*x1 + (x1 - 1)*x2;
  //return -x1 - x1*x1*x1;
  //return 1/x1- x1;
  //return -2*x1*x2*(x2*x2-1);
  //return -x2*x2 - x1;
  //return 0.5*(4-x2)*(5-3*(4-x2)+0.5*(4-x2)*(4-x2));
  //return 3-x1/2-x2; //tunnel diode
  //return -x1 - tun(x2 + 2);
  //return x2 - x2*x2*x2/2 - x1;
  return x1*x2 - x1*x1*x1;
  
  /*
  if(sqrt(x1*x1) < 1){
    return 0;
  }else{
    return 2;
  }*/
}

float tun(float in){
  return in*(5 - 3*in + in*in/2);
}

void setup() {
  size(1800, 900);
  smooth(1);

  scleX = 0.5 * width / x1range;
  scleY = height / x2range;

  if (abs(x1max) > abs(x1min)) {
    x1offset = x1max - x1range;
  } else if (abs(x1max) < abs(x1min)) {
    x1offset = x1min + x1range;
  } else {
    x1offset = 0;
  }

  if (abs(x2max) > abs(x2min)) {
    x2offset = x2max - x2range;
  } else if (abs(x2max) < abs(x2min)) {
    x2offset = x2min + x2range;
  } else {
    x2offset = 0;
  }

  drawPhasePlane();
  
  //initial conditions
  x1 = 1;
  x2 = 4;
  
  drawGraphs();
  /*
  for (int i = 0; i < 65; i++) {
    x2 = 0;
    x1 = 2 + 0.03*i;
    drawGraphs();
  }*/
}

void drawPhasePlane() {
  background(255);
  strokeWeight(2);
  line(width/2, 0, width/2, height);
  line(width/2, height/2, width, height/2);
  strokeWeight(1);
  stroke(125);
  line(width/4 + x1offset * scleX, 0, width/4 + x1offset * scleX, height);
  line(0, height/2 - x2offset * scleY, width/2, height/2 - x2offset * scleY);
  line(width/2, height/4 - x1offset * scleX * 0.5, width, height/4 - x1offset * scleX * 0.5);
  line(width/2, 3*height/4 - x2offset * scleY * 0.5, width, 3*height/4 - x2offset * scleY * 0.5);

  stroke(0);
  float scale = 6;
  float ddx1 = x1range / 30;
  float ddx2 = x2range / 30;
  for (float i = x1min + ddx1/2; i < x1min + x1range; i = i + ddx1) {
    for (float j = x2min + ddx2/2; j < x2min + x2range; j = j + ddx2) {
      dx1 = f(i, j, 0);
      dx2 = g(i, j, 0);
      dx = sqrt(dx1*dx1 + dx2*dx2);
      dx1 = scale*dx1/dx;
      dx2 = scale*dx2/dx;
      line(width/4 + i*scleX - dx1  + x1offset * scleX, height/2 - j*scleY + dx2 - x2offset * scleY, width/4 + i*scleX + dx1 + x1offset * scleX, height/2 - j*scleY- dx2 - x2offset * scleY);
      stroke(255, 0, 0);
      ellipse(width/4 + i*scleX + dx1 + x1offset * scleX, height/2 - j*scleY - dx2 - x2offset * scleY, 2, 2);
      stroke(0);
    }
  }
}

void drawGraphs() {
  for (float t = tmin; t < tmax; t += dt) {
    /* //Euler
    x1old = x1;
    x2old = x2;
    x1 = x1 + dt * f(x1, x2, t);
    x2 = x2 + dt * g(x1, x2, t);*/
    
    //RK4
    x1old = x1;
    x2old = x2;
    
    float k11 = f(x1, x2, t); 
    float k12 = g(x1, x2, t);
    
    float k21 = f(x1 + dt*k11/2, x2 + dt*k12/2, t + dt/2);
    float k22 = g(x1 + dt*k11/2, x2 + dt*k12/2, t + dt/2);
    
    float k31 = f(x1 + dt*k21/2, x2 + dt*k22/2, t + dt/2);
    float k32 = g(x1 + dt*k21/2, x2 + dt*k22/2, t + dt/2);
    
    float k41 = f(x1 + dt*k31, x2 + dt*k32, t + dt);
    float k42 = g(x1 + dt*k31, x2 + dt*k32, t + dt);
    
    x1 = x1 + dt * (k11 + 2*k21 + 2*k31 + k41) / 6;
    x2 = x2 + dt * (k12 + 2*k22 + 2*k32 + k42) / 6;


    //if new state is in the phase plane window, draw a line connecting old state and new state
    if (x1 > x1min && x1 < x1max && x2 > x2min && x2 < x2max) {
      stroke(int(200*rectPulse(t, tmax/50)));
      line(width/4 + x1old*scleX  + x1offset * scleX, height/2 - x2old*scleY - x2offset * scleY, width/4 + x1*scleX  + x1offset * scleX, height/2 - x2*scleY - x2offset * scleY);
    }
    stroke(0);
    //drawing state[0] vs. time graph
    if (x1 > x1min && x1 < x1max) {
      line(width/2 + width/2.1 * t / tmax, height/4 - x1old*scleX*0.5 - x1offset * scleX * 0.5, width/2 + width/2.1 * (t + dt) / tmax, height/4 - x1*scleX*0.5 - x1offset * scleX * 0.5);
    }
    //drawing state[1] vs. time graph
    if (x2 > x2min && x2 < x2max) {
      line(width/2 + width/2.1 * t / tmax, 3*height/4 - x2old*scleY*0.5 - x2offset * scleY * 0.5, width/2 + width/2.1 * (t + dt) / tmax, 3*height/4 - x2*scleY*0.5 - x2offset * scleY * 0.5);
    }
  }
  println(x1 + " ; " + x2);
}

void draw() {
  delay(10);
}

int rectPulse(float t, float period) {
  if ((t/period - floor(t/period)) > 0.5) {
    return 1;
  } else {
    return 0;
  }
}

void mousePressed() {
  
  //converting windows coordinates to phase plane coordinates 
  x1 = (mouseX - width/4 - x1offset * scleX)/scleX;
  x2 = (-mouseY + height/2 - x2offset * scleY)/scleY;
  
  drawGraphs();
}

void keyPressed() {
  if (key == 119) { // w
    input = input + 0.1;
    println(input);
    clear();
    drawPhasePlane();
  }
  if (key == 115) { //s
    input = input - 0.1;
    println(input);
    clear();
    drawPhasePlane();
  }
}