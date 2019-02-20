
float startPoint = random(90, 1200);
FloatList iterations = new FloatList();


void setup() {
  size(1280, 720);

  println(startPoint);

  iterations.append(startPoint);
}


void draw() {
  background(71);




  drawObjective();

  drawIterates();
}

void calcNextIterate() {

  float x = iterations.get(iterations.size() - 1);

  //calc gradient
  float dx = 0.2;
  float o2 = objective(x + dx);
  float o1 = objective(x);
  float o0 = objective(x - dx);

  float der_f = (o2 - o0)/(2.0*dx);
  float derder_f = (o2 - 2*o1 + o0)/(dx*dx);

  if (derder_f == 0.0) derder_f = 1.0; 
  float step = - der_f / abs(derder_f);

  println(o0, ";", o1, ";", o2, ";"); 

  print(step, "; "); 
  print(der_f, "; "); 
  print(derder_f, "; ");

  float stepSize = 1.0;
  float o = objective(x + stepSize * step);

  int itrtns = 0;

  while (o > (o1 + 0.5*stepSize*step*der_f)) {
    itrtns++;
    stepSize /= 1.5;
    o = objective(x + stepSize * step);
  }

  println(itrtns);

  iterations.append(x + stepSize * step);

  /*
  if (der_f > 0.0) {
   iterations.append(x + 10.0*der_f);
   } else {
   iterations.append(x + 10.0*der_f);
   }*/
}

float calcGrad(float x) {

  float dx = 0.02;
  float o0 = objective(x + dx);
  float o2 = objective(x - dx);

  float der_f = (o0 - o2)/(2.0*dx);

  return der_f;
}

float calcHess(float x) {

  float dx = 0.02;
  float o0 = objective(x + dx);
  float o1 = objective(x);
  float o2 = objective(x - dx);

  float derder_f = (o0 - 2*o1 + o2)/(dx*dx);

  return derder_f;
}

void drawIterates() {
  int l = iterations.size();
  for (int i = 0; i < l; i++) {
    float x = iterations.get(i);
    float o = objective(x);
    ellipse(x, height - o, 4, 4);
  }
}

void drawObjective() {
  int steps = 500;

  for (int i = 0; i < steps; i++) {
    float dx = width / float(steps);

    float x1 = i*dx;
    float x2 = (i+1)*dx;

    float o1 = height - objective(x1);
    float o2 = height - objective(x2);

    line(x1, o1, x2, o2);
  }
}

float objective(float x) {
  float xx = x * 14.0 / width;

  //float o = 0.2*sin(4*xx) + 0.85*cos(1.1*xx);
  float o = 0.1*sin(4*xx) + 0.85*cos(1.1*xx);

  return height/2 - height*o/5.1;
}

void resetIterates(){
  int l = iterations.size();
  for (int i = 0; i < l; i++) {
    iterations.remove(0);
  }
  iterations.append(random(50, 1180));
  
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