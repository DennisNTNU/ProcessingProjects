FloatList Xposes = new FloatList();
FloatList Yposes = new FloatList();
FloatList Aposes = new FloatList();
int maxSize = 200;

Particles parts = new Particles();

float ppm = 100;

float g = -9.81;

float tt = 0;
float t = 0;
float dt = 0.02;

float Fc = 0;

float accumY = 0;

float Kp = 1;
float Kp2 = 1;
float Kd = 1;

void setup(){
  size(1280, 720);
  noFill();
  clear();
  background(255);
  Xposes.append(X[0]);
  Yposes.append(X[1]);
  Aposes.append(X[2]);
  
  a = function(x, y, vx, vy, t, T1, T2);
  vx = vx + dt * a[0] / 2;
  vy = vy + dt * a[1] / 2;
  x = x + dt * vx;
  y = y + dt * vy;
  
  A = rocket(X[0], X[1], X[2], V[0], V[1], V[2], F, Fr);
  V[0] = V[0] + dt * A[0] / 2;
  V[1] = V[1] + dt * A[1] / 2;
  V[2] = V[2] + dt * A[2] / 2;
  X[0] = X[0] + dt * V[0];
  X[1] = X[1] + dt * V[1];
  X[2] = X[2] + dt * V[2];
  Xposes.append(X[0]);
  Yposes.append(X[1]);
  Aposes.append(X[2]);
  
  t += dt;
  
  
}

void draw(){
  background(235);
  //println(a[0] + " , " + a[1] + " ; " + vx + " , " + vy + " ; " + x + " , " + y);
  //println(vx);
  delay(10);
  
  
  T1 = - 0.0 * vx + Tm1;
  T2 = - 0.0 * vy + Tm2;
  
  a = function(x, y, vx, vy, t, T1, T2);
  vx = vx + dt * a[0];
  vy = vy + dt * a[1];
   x =  x + dt *   vx;
   y =  y + dt *   vy;
  
  float xd = (mouseX - width / 2) / ppm;
  float yd = (height / 2 - mouseY) / ppm;
  accumY += dt * sqrt(abs(yd - X[1])) * (yd - X[1]) / abs(yd - X[1]);
  Fc = F + 18 * (yd - X[1]) + 1 * accumY - 9 * V[1] - 0.55*g;
  if (Fc < 0.9) {Fc = 0.9;}
  float thetad = sat( 0.4*(xd - X[0]) - 0.422*V[0], 1.0);
  float Frc = Fr + 56.5 * (thetad - X[2]);
  //float Frc = Fr + 3.5 * ((xd - X[0]) - 6 * V[0]);
  
  if (cos(X[2]) * cos(X[2]) > 0.3) {
    Fc = Fc / cos(X[2]);  
  }
  
  A = rocket(X[0], X[1], X[2], V[0], V[1], V[2], Fc, Frc);
  V[0] = V[0] + dt * A[0];
  V[1] = V[1] + dt * A[1];
  V[2] = V[2] + dt * A[2];
  X[0] = X[0] + dt * V[0];
  X[1] = X[1] + dt * V[1];
  X[2] = X[2] + dt * V[2];
  Xposes.append(X[0]);
  Yposes.append(X[1]);
  Aposes.append(X[2]);
  if (Xposes.size() > maxSize) {
    Xposes.remove(0);
    Yposes.remove(0);
    Aposes.remove(0);
    //Yposes.append(X[1]);
  }
  
  if(X[1] < - height / (2 * ppm)) {
    X[1] = - height / (2 * ppm);
    V[1] = 0;
  }else if(X[1] > height / (2 * ppm)) {
    X[1] = height / (2 * ppm);
    V[1] = 0;
  }
  if(X[0] < - width / (2 * ppm)) {
    X[0] = - width / (2 * ppm);
    V[0] = 0;
  }else if(X[0] > width / (2 * ppm)) {
    X[0] = width / (2 * ppm);
    V[0] = 0;
  }
  
  t += dt;
  
  xpos1 = l1 * cos(x);
  ypos1 = -l1 * sin(x);
  xpos2 = xpos1 + l2 * cos(x + y);
  ypos2 = ypos1 - l2 * sin(x + y);
  
  
  //robot manipulator
  line(width / 2, height / 2, width / 2 + xpos1 * ppm, height / 2 - ypos1 * ppm);
  line(width / 2 + xpos1 * ppm, height / 2 - ypos1 * ppm, width / 2 + xpos2 * ppm, height / 2 - ypos2 * ppm);
  
  //rocket
  ellipse(width/2 + X[0] * ppm, height/2 - X[1] * ppm, 40, 40);
  line( width/2 + X[0] * ppm + 20 * sin(X[2]), height / 2 - X[1] * ppm - 20 * cos(X[2]),
        width/2 + X[0] * ppm - 20 * sin(X[2]), height / 2 - X[1] * ppm + 20 * cos(X[2]));
  for (int i = 0; i < (int)pow(Fc, 0.65); i++) {
    parts.addParticle(width/2 + X[0] * ppm - 20 * sin(X[2]) + random(10) - 5, height / 2 - X[1] * ppm + 20 * cos(X[2]) + random(10) - 5,
                    - 12 * (Fc + 12) * sin(X[2]) + random(60) - 30 - 0.5 * V[0] * ppm, 12 * (Fc + 12) * cos(X[2]) + random(60) - 30 - 0.5 * V[1] * ppm, 0.8);
  }
  parts.update(dt);
  parts.drawParticles();
  
  
  //mosue crossair
  stroke(255, 0, 0, 127);
  line(Xposes.size(), height / 2 - yd * ppm, width, height/2 - yd * ppm);
  stroke(0, 0, 255, 127);
  line(xd * ppm + width / 2, 0, xd * ppm + width / 2, height);
  stroke(0, 0, 0, 255);
  
  //sliding pendel
  //line(0, height / 3, width, height / 3);
  //line(x * ppm, height / 3, x * ppm + l * sin(y) * ppm, height / 3 + l * cos(y) * ppm);
  //rect(x * ppm - w/2, height / 3 - h/2, w, h, 5);
  //ellipse(x * ppm + l * sin(y) * ppm, height / 3 + l * cos(y) * ppm, r, r);
  
  //Rocket X position plot - 6.4
  rect(0,0, Xposes.size(), height / 3);
  for (int i = 2; i < Xposes.size(); i += 2) {
    line(i-2, height / 6 - height / 6 * Xposes.get(i-2) / 6.4 , i, height / 6 - height / 6 * Xposes.get(i) / 6.4 );
    //point(i, height/4 - height / 4 * Xposes.get(i) / 6.4 );
  }
  
  //Rocket Y position plot
  rect(0, height / 3, Yposes.size(), height / 3);
  for (int i = 2; i < Yposes.size(); i += 2) {
    line(i-2, 3*height/6 - height / 6 * Yposes.get(i-2) / 6.4 , i, 3*height/6 - height / 6 * Yposes.get(i) / 6.4 );
    //point(i, height/4 - height / 4 * Xposes.get(i) / 6.4 );
  }
  
  //Rocket angle plot
  rect(0, 2*height / 3, Aposes.size(), height / 3);
  for (int i = 2; i < Aposes.size(); i += 2) {
    line(i-2, 5*height/6 - height / 6 * Aposes.get(i-2) / 3.14 , i, 5*height/6 - height / 6 * Aposes.get(i) / 3.14 );
    //point(i, height/4 - height / 4 * Xposes.get(i) / 6.4 );
  }
  stroke(255,0,0,127);
  line(0, height / 6 - height / 6 * xd / 6.4 , Xposes.size(), height / 6 - height / 6 * xd / 6.4 );
  line(0, 3*height/6 - height / 6 * yd / 6.4 , Yposes.size(), 3*height/6 - height / 6 * yd / 6.4 );
  line(0, 5*height/6 - height / 6 * thetad / 6.4 , Aposes.size(), 5*height/6 - height / 6 * thetad / 6.4 );
  stroke(0,0,0,255);
  
  if (t - tt > 1.0) {
    println(x, " : ", y, "  :  ", xd);
    tt = (int)t;
  }
}

void keyPressed(){
  switch (key){
    case 'o': dt = dt * 1.2; break;
    case 'p': dt = dt / 1.2; break;
    
    case 'w': /*Tm1 = -20;*/ F = 20; break;
    //case 's': Tm1 = 20; break;
    
    case 'a': Fr = -19.0; break;
    case 'd': Fr =  19.0; break;
    
    case 'r': Tm1 = -300; break;
    case 'f': Tm2 = 300; break;
  }
}

void keyReleased(){
  switch (key){
    case 'w': Tm1 = 0; F = 0; break;
    case 's': Tm1 = 0; F = 0; break;
    
    case 'a': Fr = 0; break;
    case 'd': Fr = 0; break;
    
    case 'r': Tm1 = 0; break;
    case 'f': Tm2 = 0; break;
  }
}