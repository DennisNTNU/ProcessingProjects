
float[] A = {0, 0, 0};    //acceleration
float[] X = {0, 0, 0};    //position x, position y, rotation
float[] V = {0, 0, 0.1};  //correspnding speeds
float m = 10.0;           //mass
float j = 5.0;            //moment of inertia
float D = 10.0;           //rotational drag coefficient
float F = 0;              //thrust
float Fr = 0;             //torque

float[] rocket(float x, float y, float angle, float vx, float vy, float omega, float F, float Fr) {
  float[] a = {0, 0, 0};
  
  a[0] = F * sin(angle);
  a[1] = F * cos(angle) + g * 0.5;
  a[2] = Fr - D * omega;
  
  return a;
}