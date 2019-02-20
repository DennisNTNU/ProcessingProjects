float topi = 2*3.141592653589793238462; 

class Blob{
  float posx;
  float posy;
  
  int n;
  float[] rads;
  float[] speeds;
  
  
  Blob(int _n){
    posx = width / 2;
    posy = height / 2;
    rads = new float[_n];
    speeds = new float[_n];
    n = _n;
    for (int i = 0; i < _n; i++) {
      rads[i] = 100;
      speeds[i] = 0;
    }
  }
  
  void draw(){
    beginShape();
    for (int i = 0; i < n; i++) {
      vertex(posx + rads[i]*cos(topi * i / n), posy + rads[i]*sin(topi * i / n));
    }
    vertex(posx + rads[0], posy);
    endShape();
  }
  
  void update(float dt){
    for (int i = 0; i < n; i++) {
      speeds[i] += dt * (2*(100 - rads[i]) - 2*rads[i] + rads[circInd(i-1)] + rads[circInd(i+1)] - 0.1*speeds[i]);
      rads[i] += dt * (speeds[i]);
    }
  }
  
  int circInd(int i){
    if (i == -1) {
      return n - 1;
    }
    if (i == n) {
      return 0;
    }
    return i;
  }
}

int frame = 0;
float dt = 0.1;
Blob blob;

void setup(){
  size(800, 600);
  blob = new Blob(50);
  blob.speeds[8] += 20;
}

void draw(){
  background(230);
  stroke(10);
  
  frame++;
  if (frame % 60 == 0) {
    blob.speeds[int(random(32))] += 100;
  }
  
  blob.update(dt);
  blob.draw();
}