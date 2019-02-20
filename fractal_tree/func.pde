
void drawLines(int num, float dir, float unitWidth) {

  int x = width / 2;
  int y = height / 2;
  
  strokeWeight(0.6*pow(log(unitWidth + 1.0), 2.0));
  
  line(x, y, x + unitWidth * cos(dir), y + unitWidth * sin(dir));
  dlines(unitWidth, dir, x + unitWidth * cos(dir), y + unitWidth * sin(dir), num);
}

void dlines(float unitWidth, float dir, float x, float y, int num) {
  //float dirl = dir + PI/3.5;
  //float dirr = dir - PI/3.5;
  float dirl = dir + PI/fac;
  float dirr = dir - PI/fac;

  float xl = x + unitWidth * cos(dirl);
  float yl = y + unitWidth * sin(dirl);
  float xr = x + unitWidth * cos(dirr);
  float yr = y + unitWidth * sin(dirr);

  strokeWeight(0.6*pow(log(unitWidth + 1.0), 2.0));

  line(x, y, xr, yr);
  line(x, y, xl, yl);
  //ellipse(x, y, num, num);
  
  if (num >= 1) {
    dlines((0.6*unitWidth), dirr, xr, yr, num-1);
    dlines((0.6*unitWidth), dirl, xl, yl, num-1);
  }
}