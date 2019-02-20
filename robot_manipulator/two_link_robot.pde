
float x = 0;
float y = 0;
float vx = 0;
float vy = 0;
float[] a = {0, 0};

float T1 = 0;
float T2 = 0;
float Tm1 = 0;
float Tm2 = 0;

float l1 = 2.0;
float l2 = 2.0;
float lc1 = 1.0;
float lc2 = 1.0;
float I1 = 4.0;
float I2 = 4.0;
float m1 = 30.0;
float m2 = 30.0;

float xpos1 = 1.0;
float ypos1 = 1.0;
float xpos2 = 1.0;
float ypos2 = 1.0;

float[] function(float x, float y, float vx, float vy, float t, float T1, float T2){
  float[] a = {0, 0};
  /*
  float H11 = m1*lc1*lc1 + I1 + I2 + m2*(l1*l1 + lc1*lc1 + 2*l1*lc1*cos(y));
  float H22 = m2*lc2*lc2 + I2;
  float H12 = m2*l1*lc2*cos(y) + m2*lc2*lc2 + I2;
  float h = m2*l1*lc2*sin(y);
  float g1 = m1*lc1*g*cos(x) + m2*g*(lc2*cos(x + y) + l1*cos(x));
  float g2 = m2*lc2*g*cos(x+y);
  float C = - 2*h*vx*vy - h*vy*vy;
  float A = C + g1;
  float B = h*vx*vx + g2;
  float At = T1 - A;
  float Bt = T2 - B;
  
  a[0] = ( H11*Bt - H12*At ) / (H11*H22 - H12*H12);
  a[1] = ( H22*At - H12*Bt ) / (H11*H22 - H12*H12); */
  
  float H11 = m1*lc1*lc1 + I1 + I2 + m2*(l1*l1 + lc2*lc2 + 2*l1*lc2*cos(y));
  float H22 = m2*lc2*lc2 + I2;
  float H12 = m2*l1*lc2*cos(y) + m2*lc2*lc2 + I2;
  float g1 = m1*lc1*g*cos(x) + m2*g*(lc2*cos(x+y) + l1*cos(x));
  float g2 = m2*lc2*g*cos(x + y);
  //g1 = 0; g2 = 0;
  float h = m2*l1*lc2*sin(y);
  float k = T1 - g1 + 2*h*vx*vy + h*vy*vy;
  float l = T2 - g2 - h*vx*vx;
  
  //a[0] = (H22*k - H12*l) / (H11*H22 - H12*H12);
  //a[1] = (H11*l - H12*k) / (H11*H22 - H12*H12);
  
  //s = H11*H22 - H12*H12
  float s = (I1 + m1*lc1*lc1)*(I1 + m2*lc2*lc2) + I2*m2*l1*l1 + m2*m2*l1*l1*lc2*lc2*sin(y)*sin(y);
  a[0] = (H22*k - H12*l) / s - vx;
  a[1] = (H11*l - H12*k) / s - vy;
  
  return a;
}