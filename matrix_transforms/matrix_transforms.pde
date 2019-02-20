float tp = 2 * 3.141592653589793238462;
float f = 0.0;
//Mat mat = new Mat(1, 1,
//                  1, 1);
//Mat mat = new Mat(0, 1,
//                  1, 0);
//Mat mat = new Mat(1, 1, 
//                  1, 1);
//Mat mat = new Mat(0, 0,
//                  0, 0);
//Mat mat = new Mat(0.5, 0.86,
//                  -0.86, 0.5);
//Mat mat = new Mat(0, 2,
//                  -2, 0);
Mat mat = new Mat(0, 1,
                  -1, -4);
Mat mat1 = new Mat(1, 0, 0, 1);
Mat mat2 = new Mat(0, 0, 0, 0);
float[] input = new float[2];
float[] output = new float[2];

//grid: 1 unit = 20 px;
int unit = 50;

int t = 0;

void setup(){
  size(900, 900);
  smooth(1);
  background(0);
  grid();
}

void draw(){
  background(0);
  grid();
  
  mat2 = lerpMat(mat, mat1, f);
  grid2(mat2);
  
  for(int i = -4; i < 5; i++){
    for(int j = -4; j < 5; j++){
      input[0] = i; input[1] = j;
      output = mat2.matMult(input);
      arrow(unit*input[0], unit*input[1], unit*output[0], unit*output[1]);
    }
  }
  
  
  //f += 0.01;
  f = 2*float(mouseX) / width;
  if(f >= 2) { f = -1; }
  if(t % 30 == 0) { mat2.prin(); }
  delay(20);
  t++;
}

void arrow(float x1, float _y1, float x2, float _y2){
  //stroke(250);
  //stroke(random(155) + 100, random(155) + 100, random(155) + 100, 255);
  stroke(200, 200, 0, 255);
  
  float y1 = -_y1;
  float y2 = -_y2;
  
  fill(250);
  ellipse(x1+width/2, y1+height/2, 3, 3);
  fill(0);
  
  line(x1+width/2, y1+height/2, x2+width/2, y2+height/2);
  
  //ellipse(x2+width/2, y2+height/2, 5, 5);
  float dx = x2 - x1;
  float dy = y2 - y1;
  if ((dx*dx + dy*dy) > 4) {
    float a = atan2(dy, dx);
    line(x2 + width/2, y2+height/2, x2 - 5 * cos(a + tp/8) + width/2, y2 - 5 * sin(a + tp/8)+height/2);
    line(x2 + width/2, y2+height/2, x2 - 5 * cos(a - tp/8) + width/2, y2 - 5 * sin(a - tp/8)+height/2);
  }
  
}

void keyPressed(){
  switch (key) {
    case '1':
    mat.d += 0.1;
    break;
    case '2':
    mat.d -= 0.1;
    break;
    default:
    
    break;
    
  }
  
}