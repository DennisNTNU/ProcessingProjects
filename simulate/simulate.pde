
float pixelPerMeter = 100;

float g = 9.81;
float l = 2.0;
float M = 30.0;
float m = 15;

float[] function(float x, float y, float vx, float vy, float t, float F, float Fc){
  float[] a = {0, 0};
  
  //wrong equations
  a[0] = -g * tan(y) + (F + Fc + m * l * vy * vy * sin(y) + g * (M + m) * tan(y)) / (M + m * sin(y) * sin(y));
  a[1] = (F + Fc + m * l * vy * vy * cos(y) * sin(y) + g * (M+m) * sin(y)) / (m * l * cos(y) * cos(y) - l * (M+m));
  
  //without input force
  //a[0] = m * l * vy * vy * sin(y) / (M+m) + m * sin(y) * cos(y) * (m * l * vy * vy * cos(y) + g * (M+m)) / ( (M+m) * (M + m * sin(y) * sin(y)));
  //a[1] = (m * l * vy * vy * cos(y) * sin(y) + g * (M+m) * sin(y)) / (m * l * cos(y) * cos(y) - l * (M+m)); 
  
  //with input force - wrong equations
  //a[0] = m * l * vy * vy * sin(y) / (M+m) + m * sin(y) * cos(y) * (m * l * vy * vy * cos(y) + g * (M+m)) / ( (M+m) * (M + m * sin(y) * sin(y))) - m * (F + 100 * vx) * cos(y) * cos(y) / ( (M+m) * (M + m * sin(y) * sin(y)));
  //a[1] = (m * l * vy * vy * cos(y) * sin(y) + g * (M+m) * sin(y) - (F + 100 * vx) * cos(y)) / (m * l * cos(y) * cos(y) - l * (M+m));
  
//second try
  //a[0] = (F + Fc + m * (g - vx * vy) * sin(y) * cos(y) + m * l * vy * vy * sin(y)) / (M + m * sin(y) * sin(y));
  //a[1] = (((M - m * cos(2*y)) * g  + (m + M) * vx * vy - m * l * vy * vy * cos(y)) * sin(y) - (F * Fc) * cos(y)) / (M + m * sin(y) * sin(y));
  
  //a[0] = (F + Fc + m*l*vy*vy*sin(y) + m * (2*vx*vy - g)*sin(y)*cos(y)) / ( M + m * sin(y) * sin(y));
  //a[1] = ((F + Fc) * cos(y) + m * l * vy * vy * sin(y) * cos(y) + (2*vx*vy - g)*(m*cos(2*y) - M)*sin(y)) / ( M + m * sin(y) * sin(y));
  
  return a;
}


float t = 0;
float dt = 0.02;
float x = 5;
float y = 1;
float vx = 0;
float vy = 0;
float[] a = {0, 0};
float F = 0;
float Fc = 0;

int w = 2*int(3 * sqrt(M));
int h = 2*int(sqrt(M));
int r = int(m);

void setup(){
  size(1280, 720);
  clear();
  background(255);
  
  a = function(x, y, vx, vy, t, F, Fc);
  vx = vx + dt * a[0] / 2;
  vy = vy + dt * a[1] / 2;
  x = x + dt * vx;
  y = y + dt * vy;
  t += dt;
  point(x * pixelPerMeter, height / 2);
  point(x * pixelPerMeter + l * sin(y) * pixelPerMeter, height / 2 + l * cos(y) * pixelPerMeter);
  //stroke(0,255,0);
}

void draw(){
  //println(a[0] + " , " + a[1] + " ; " + vx + " , " + vy + " ; " + x + " , " + y);
  println(vx);
  //delay(10);
  a = function(x, y, vx, vy, t, F, Fc);
  vx = vx + dt * a[0];
  vy = vy + dt * a[1];
  x = x + dt * vx;
  y = y + dt * vy;
  
  
  //Fc = - 150* vx - 150 * vy * cos(y) - 150 * (x - 5); //stable in x unstable in y
  //Fc = - 150 * vy * cos(y) - 150 * (x - 5); //stable in x unstable in y
  //Fc = - 150 * vy - 150 * (x - 5); //unstable both in x and y
  Fc = 0;
  
  t += dt;
  
  background(255);
  line(0, height / 3, width, height / 3);
  line(x * pixelPerMeter, height / 3, x * pixelPerMeter + l * sin(y) * pixelPerMeter, height / 3 + l * cos(y) * pixelPerMeter);
  rect(x * pixelPerMeter - w/2, height / 3 - h/2, w, h, 5);
  ellipse(x * pixelPerMeter + l * sin(y) * pixelPerMeter, height / 3 + l * cos(y) * pixelPerMeter, r, r);
  
}

void keyPressed(){
  switch (key){
    case 'w': dt = dt * 1.2; break;
    case 'W': dt = dt * 1.2; break;
    case 's': dt = dt / 1.2; break;
    case 'S': dt = dt / 1.2; break;
    
    case 'a': F = -80; break;
    case 'A': F = -80; break;
    case 'd': F = 80; break;
    case 'D': F = 80; break;
    
  }
}

void keyReleased(){
  switch (key){
    case 'a': F = 0; break;
    case 'A': F = 0; break;
    case 'd': F = 0; break;
    case 'D': F = 0; break;
    
  }
}