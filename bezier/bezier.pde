int clicks = 0;

float x0 = 0.0; 
float x1 = 0.0;
float x2 = 0.0;
float x3 = 0.0;
float x4 = 0.0;

float y0 = 0.0; 
float y1 = 0.0;
float y2 = 0.0;
float y3 = 0.0;
float y4 = 0.0;

float k1 = 4.0;
float k2 = 4.0;

int maxPoints = 12;
float[] XX = new float[maxPoints];
float[] YY = new float[maxPoints];

int knotCount = 14;
float[] ti = new float[knotCount];

int line = 5;

int pointCount = 0;

void setup(){
  size(1280,720);
  for (int i = 0; i < knotCount; i++) {
    if (i < 4) {
      ti[i] = 0.0;
    }else{
      if (i >= knotCount-4) {
        ti[i] = 1.0;
      }else{
        ti[i] = (i-3)*1.0/(knotCount-7);
      }
    }
  }
  
  for (int i = 0; i < knotCount; i++) {
    println(ti[i]);
  //  ti[i] = i*1.0/knotCount;
  }
  println(" ");
  println(XX[5]);
}


void draw(){
  delay(10);
}

void mousePressed(){
  
  if (line == 4) {
    if (pointCount < maxPoints) {
      XX[pointCount] = mouseX - width/2;
      YY[pointCount] = height/2 - mouseY;
      pointCount++;
      println(pointCount);
    }
  }
  
  if (line == 5) {
    if (pointCount < maxPoints) {
      XX[pointCount] = mouseX - width/2;
      YY[pointCount] = height/2 - mouseY;
      pointCount++;
      println(pointCount);
    }
  }
  
}

void keyPressed(){
  if (line == 4) {
    float x, y, X, Y;
    X = nBezierX(pointCount, 0.0);
    Y = nBezierY(pointCount, 0.0);
    for (float i = 0; i < 40; i++) {
      x = X;
      y = Y;
      X = nBezierX(pointCount, (i + 1)/40);
      Y = nBezierY(pointCount, (i + 1)/40);
      line(x + width/2, height/2 - y, X + width/2, height/2 - Y);
    }
    pointCount = 0;
  }
  
  if (line == 5) {
    int p = knotCount-1 - pointCount-1 - 1;
    float step = 1.0/40;
    float x, y, X, Y;
    X = BsplineCurveX(0.0, pointCount-1, p);
    Y = BsplineCurveY(0.0, pointCount-1, p);
    for (float t = 0.0; t < 1.0; t += step) {
      x = X;
      y = Y;
      X = BsplineCurveX(t, pointCount-1, p);
      Y = BsplineCurveY(t, pointCount-1, p);  
      line(x + width/2, height/2 - y, X + width/2, height/2 - Y);
      println(t + " ; " + X + " ; " + Y);
    }
    pointCount = 0;
  }
}

float BsplineCurveX(float t, int n, int p){
  float x = 0.0;
  for (int i = 0; i <= n; i++) {
    x += XX[i] * Bijt(i, p, t);
  }
  return x;
}

float BsplineCurveY(float t, int n, int p){
  float y = 0.0;
  for (int i = 0; i <= n; i++) {
    y += YY[i] * Bijt(i, p, t);
  }
  return y;
}

float Bijt(int i, int j, float t){
  if (j == 0) {
    if (ti[i] <= t && t <= ti[i+1]) {
      return 1.0;
    }else{
      return 0.0;
    }
  }
  return (t - ti[i])/(ti[i+j] - ti[i] + 0.000001) * Bijt(i, j-1, t) + (ti[i+j+1] - t)/(ti[i+j+1] - ti[i+1] + 0.000001) * Bijt(i+1, j-1, t);
}

float nBezierX(int n, float t){
  float k, l, m = 0.0;
  for (int i = 0; i < n; i++) {
    l = 0.0;
    k = XX[i]*c(n - 1, i);
    for (int j = i; j < n; j++) {
      l += pow(-1, j-i)*c(n - i - 1, j - i)*pow(t, j);
    }
  m += k*l;
  }
  return m;
}

float nBezierY(int n, float t){
  float k, l, m = 0.0;
  for (int i = 0; i < n; i++) {
    l = 0.0;
    k = YY[i]*c(n - 1, i);
    for (int j = i; j < n; j++) {
      l += pow(-1, j-i)*c(n - i - 1, j - i)*pow(t, j);
    }
  m += k*l;
  }
  return m;
}

int c(int n, int i){
  return factorial(n)/(factorial(i)*factorial(n-i));
}

int factorial(int n){
  int m = n;
  for (int i = n-1; i > 0; i--) {
    m = m*i;
  }
  if (n == 0) {
    m = 1;
  }
  return m;
}

int factorialRecursive(int n){
  if (n == 0) {
    return 1;
  }
  return n * factorialRecursive(n - 1);
}