
float[] c1;
float[] c2;

ArrayList<float[]> kk = new ArrayList<float[]>();

float dt = 0.1;

void setup() {
  size(640, 480);
  
}

void draw() {
  background(240);
  
  stroke(255, 0, 0, 255);
  for (int i = 0; i < kk.size(); i++) {
    ellipse(kk.get(i)[0] - 2, kk.get(i)[1] - 2, 4, 4);
  }
  
  c1 = multilerp(kk, 0);
  for (float i = dt; i <= 1.0 + dt/2; i += dt) {
    c2 = multilerp(kk, i);
    //point(c1[0], c2[1]);
    line(c1[0], c1[1], c2[0], c2[1]);
    c1 = c2;
  }
  
  
}