class Quadrotor {
  PVector p;
  PVector v;
  float[] q= {1, 0, 0, 0};
  PVector w;

  PVector p_d;
  float[] q_d= {1, 0, 0, 0};

  PVector F;
  PVector tau;
  float[][] R = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}}; //this R rotates coordinates in body frame to coordinates in inertial frame

  float[] wi = {0.0, 0.0, 0.0, 0.0};

  float[][] J = {{1.0, 0, 0}, {0, 1.0, 0}, {0, 0, 2.0}};
  float[][] J_inv = {{1.0/J[0][0], 0, 0}, {0, 1.0/J[1][1], 0}, {0, 0, 1.0/J[2][2]}};
  float g;
  float m;
  float a;
  float b;
  float l;

  PVector p_est;
  PVector v_est;
  float[] q_est = {1, 0, 0, 0};
  PVector w_est;
  
  PVector wm;
  PVector w_stddev = new PVector(0.1, 0.1, 0.1);
  PVector am;
  PVector a_stddev = new PVector(0.1, 0.1, 0.1);
  
  PVector wm_est;
  PVector am_est;

  Quadrotor() {

    p = new PVector(40.0, 0.0, 0.0);
    v = new PVector(0.0, 0.0, 0.0);
    w = new PVector(0.0, 0.3, 0.0);

    p_d = new PVector(40.0, 0.0, 0.0);

    F = new PVector(0.0, 0.0, 0.0);
    tau = new PVector(0.0, 0.0, 0.0);

    g = 9.805;
    m = 1.6;
    a = 5e-8;
    b = 5e-10;
    l = 0.105;
    
    p_est = new PVector(40.0, 0.0, 0.0);
    v_est = new PVector(0.0, 0.0, 0.0);
    w_est = new PVector(0.0, 0.3, 0.0);
    
    wm = new PVector(0.0, 0.0, 0.0);
    am = new PVector(0.0, 0.0, 0.0);
  
    wm_est = new PVector(0.0, 0.0, 0.0);
    am_est = new PVector(0.0, 0.0, 0.0);
  }


  void update(float dt) {
    
    //get measurement from sensors and from sensor model using last predicted state
    sense();
    
    //calc updated position estimate
    correct();
    
    //use this position estimate to calculate u
    calcPropSpeeds(); //calc desired prop speed from control scheme
    
    calcForcesTorques(); //simulate the model
    integrate(dt);
    
    //predict next step in kalman filter using current u
    predict(dt);
  }
  
  void sense(){
    wm = w.copy().add(w_stddev.x*randomGaussian(), w_stddev.y*randomGaussian(), w_stddev.z*randomGaussian());
    float Fs = a*(wi[0]*wi[0] + wi[1]*wi[1] + wi[2]*wi[2] + wi[3]*wi[3]);
    //am = F.copy().
    am.x = w_stddev.x*randomGaussian(); am.y = a_stddev.y*randomGaussian(); am.z = Fs/m + a_stddev.z*randomGaussian();
    
    wm_est = w_est.copy();
    am_est.x = 0; am_est.y = 0; am_est.z = Fs/m;
  }
  
  void correct(){
    //calc kalman gain
      //kalman gain = identity;
    //correct q_est and w_est
    
  }
  
  void predict(float dt){
    
    
    float w12 = wi[0]*wi[0];
    float w22 = wi[1]*wi[1];
    float w32 = wi[2]*wi[2];
    float w42 = wi[3]*wi[3];

    PVector t = new PVector(l*a*(w22 - w42), l*a*(-w12 + w32), b*(-w12 + w22 - w32 + w42));

    PVector Jw = w.copy();
    Jw.x = J[0][0]*w.x + J[0][1]*w.y + J[0][2]*w.z;
    Jw.y = J[1][0]*w.x + J[1][1]*w.y + J[1][2]*w.z;
    Jw.z = J[2][0]*w.x + J[2][1]*w.y + J[2][2]*w.z;

    t.add(w.copy().cross(Jw));
    tau = t;

    float Fs = a*(w12 + w22 + w32 + w42);
    F.x = R[0][2]*Fs;
    F.y = R[1][2]*Fs;
    F.z = R[2][2]*Fs - m*g;
    
    
    
    
    v_est.add(F.copy().mult(dt/m));
    p_est.add(v_est.copy().mult(dt));
    
    //PVector t = new PVector(0, 0, 0);
    t = new PVector(0, 0, 0);
    t.x = J_inv[0][0]*tau.x + J_inv[0][1]*tau.y + J_inv[0][2]*tau.z;
    t.y = J_inv[1][0]*tau.x + J_inv[1][1]*tau.y + J_inv[1][2]*tau.z;
    t.z = J_inv[2][0]*tau.x + J_inv[2][1]*tau.y + J_inv[2][2]*tau.z;
    
    w_est.add(t.mult(dt));
    
    q_est[0] -= 0.5*dt*(q_est[1]*w_est.x + q_est[2]*w_est.y + q_est[3]*w_est.z);
    q_est[1] += 0.5*dt*(q_est[0]*w_est.x - q_est[3]*w_est.y + q_est[2]*w_est.z);
    q_est[2] += 0.5*dt*(q_est[3]*w_est.x + q_est[0]*w_est.y - q_est[1]*w_est.z);
    q_est[3] += 0.5*dt*(-q_est[2]*w_est.x + q_est[1]*w_est.y + q_est[0]*w_est.z);
    float len = sqrt(q_est[0]*q_est[0] + q_est[1]*q_est[1] + q_est[2]*q_est[2] + q_est[3]*q_est[3]);
    q_est[0] /= len; 
    q_est[1] /= len; 
    q_est[2] /= len; 
    q_est[3] /= len;
  }
  
  void calcPropSpeeds() {
    
    //calc desired acceleration, a_d
    PVector a_d = v.copy().mult(-0.4);
    a_d.add((p_d.copy().sub(p)).mult(0.1));
    a_d.z += g;
    
    /*
    //rotate [0, 0, Fs] from b to i, F_b to F_i
    PVector F_b = new PVector(0.0, 0.0, a_d.mag());
    PVector F_i = new PVector(0.0, 0.0, 0.0);
    
    F_i.x = R[0][0]*F_b.x + R[0][1]*F_b.y + R[0][2]*F_b.z; 
    F_i.y = R[1][0]*F_b.x + R[1][1]*F_b.y + R[1][2]*F_b.z;
    F_i.z = R[2][0]*F_b.x + R[2][1]*F_b.y + R[2][2]*F_b.z;
    
    //find angle & axis from a_d and F_i
    float angle = acos(F_i.dot(a_d)/(F_i.mag()*a_d.mag()));
    PVector axis = F_i.copy().cross(a_d);
    axis.normalize();
    
    //desired q is equal to q concatenated with a q(angle, axis)
    float eta = cos(angle/2);
    PVector eps = axis.mult(sin(angle/2));
    
    q_d[0] = q[0]*eta - q[1]*eps.x - q[2]*eps.y - q[3]*eps.z;
    q_d[1] = q[1]*eta + q[0]*eps.x - q[3]*eps.y + q[2]*eps.z;
    q_d[2] = q[2]*eta + q[3]*eps.x + q[0]*eps.y - q[1]*eps.z;
    q_d[3] = q[3]*eta - q[2]*eps.x + q[1]*eps.y + q[0]*eps.z;*/
    
    
    float[] q_err = {1, 0, 0, 0};
    q_err[0] =   q_d[0]*q[0] + q_d[1]*q[1] + q_d[2]*q[2] + q_d[3]*q[3];
    q_err[1] = - q_d[1]*q[0] + q_d[0]*q[1] + q_d[3]*q[2] - q_d[2]*q[3];
    q_err[2] = - q_d[2]*q[0] - q_d[3]*q[1] + q_d[0]*q[2] + q_d[1]*q[3];
    q_err[3] = - q_d[3]*q[0] + q_d[2]*q[1] - q_d[1]*q[2] + q_d[0]*q[3];

    float kp = 0.5;
    PVector t = w.copy();
    t.mult(-0.5);
    if (q_err[0] > 0.0) {
      t.add(-kp*q_err[1], -kp*q_err[2], -kp*q_err[3]);
    } else {
      t.add(kp*q_err[1], kp*q_err[2], kp*q_err[3]);
    }

    //float Fs = -m*a_d.z;
    float dF = 5.0*(p_d.z - p.z) - 2.0*v.z;
    float Fs = 1.06*m*g + dF;
    
    if (Fs < 0.1*m*g) {
      Fs = 0.1*m*g;
    }
    
    
    Fs = Fs/(4*a);
    float w12 = Fs - (2*t.y/(l*a) + t.z/b);
    float w22 = Fs + (2*t.x/(l*a) + t.z/b);
    float w32 = Fs + (2*t.y/(l*a) - t.z/b);
    float w42 = Fs - (2*t.x/(l*a) + t.z/b);
    
    

    wi[0] = smartSqrt(w12);
    wi[1] = smartSqrt(w22);
    wi[2] = smartSqrt(w32);
    wi[3] = smartSqrt(w42);
  }

  void calcForcesTorques() {
    float w12 = wi[0]*wi[0];
    float w22 = wi[1]*wi[1];
    float w32 = wi[2]*wi[2];
    float w42 = wi[3]*wi[3];

    float Fs = a*(w12 + w22 + w32 + w42);
    PVector t = new PVector(l*a*(w22 - w42), l*a*(-w12 + w32), b*(-w12 + w22 - w32 + w42));

    PVector Jw = w.copy();
    Jw.x = J[0][0]*w.x + J[0][1]*w.y + J[0][2]*w.z;
    Jw.y = J[1][0]*w.x + J[1][1]*w.y + J[1][2]*w.z;
    Jw.z = J[2][0]*w.x + J[2][1]*w.y + J[2][2]*w.z;

    t.add(w.copy().cross(Jw));

    F.x = R[0][2]*Fs;
    F.y = R[1][2]*Fs;
    F.z = R[2][2]*Fs - m*g;

    tau = t;
  }

  void integrate(float dt) {
    v.add(F.copy().mult(dt/m));
    p.add(v.copy().mult(dt));
    
    if(p.x > 2000.0){
      p.x = 2000.0;
      v.x = 0;
    }
    if(p.x < -2000.0){
      p.x = -2000.0;
      v.x = 0;
    }
    
    if(p.y > 2000.0){
      p.y = 2000.0;
      v.y = 0;
    }
    if(p.y < -2000.0){
      p.y = -2000.0;
      v.y = 0;
    }
    
    if(p.z > 2000.0){
      p.z = 2000.0;
    }
    if(p.z < -200.0){
      p.z = -200.0;
    }
    
    PVector t = new PVector(0, 0, 0);
    t.x = J_inv[0][0]*tau.x + J_inv[0][1]*tau.y + J_inv[0][2]*tau.z;
    t.y = J_inv[1][0]*tau.x + J_inv[1][1]*tau.y + J_inv[1][2]*tau.z;
    t.z = J_inv[2][0]*tau.x + J_inv[2][1]*tau.y + J_inv[2][2]*tau.z;
    
    w.add(t.mult(dt));
    
    q[0] -= 0.5*dt*(q[1]*w.x + q[2]*w.y + q[3]*w.z);
    q[1] += 0.5*dt*(q[0]*w.x - q[3]*w.y + q[2]*w.z);
    q[2] += 0.5*dt*(q[3]*w.x + q[0]*w.y - q[1]*w.z);
    q[3] += 0.5*dt*(-q[2]*w.x + q[1]*w.y + q[0]*w.z);
    float len = sqrt(q[0]*q[0] + q[1]*q[1] + q[2]*q[2] + q[3]*q[3]);
    q[0] /= len; 
    q[1] /= len; 
    q[2] /= len; 
    q[3] /= len;
  }

  void show() {
    calcRotationMatrix();
    pushMatrix();
    applyRotTrans();
    bod();
    popMatrix();
    
    showdp();
    showdq();
  }

  void calcRotationMatrix() {

    R[0][0] = 1 - 2*q[2]*q[2] - 2*q[3]*q[3];
    R[0][1] = 2*(q[1]*q[2] - q[0]*q[3]);
    R[0][2] = 2*(q[1]*q[3] + q[0]*q[2]);
    R[1][0] = 2*(q[1]*q[2] + q[0]*q[3]);
    R[1][1] = 1 - 2*q[1]*q[1] - 2*q[3]*q[3];
    R[1][2] = 2*(q[2]*q[3] - q[0]*q[1]);
    R[2][0] = 2*(q[1]*q[3] - q[0]*q[2]);
    R[2][1] = 2*(q[2]*q[3] + q[0]*q[1]);
    R[2][2] = 1 - 2*q[1]*q[1] - 2*q[2]*q[2];
  }

  void applyRotTrans() {
    applyMatrix(
      R[0][0], R[0][1], R[0][2], p.x, 
      R[1][0], R[1][1], R[1][2], p.y, 
      R[2][0], R[2][1], R[2][2], p.z, 
      0.0, 0.0, 0.0, 1.0 
      );
  }

  void bod() {
    float L = 1400*l;
    fill(127);
    box(35, 35, 25);
    box(L, 8, 8);
    box(8, L, 8);
    fill(255);
    
    stroke(255);
    line(L/2, 0, 0, L/2, 0, wi[0]/10.0);
    line(0, L/2, 0, 0, L/2, wi[1]/10.0);
    line(-L/2, 0, 0, -L/2, 0, wi[2]/10.0);
    line(0, -L/2, 0, 0, -L/2, wi[3]/10.0);
    stroke(0);
    
  }
  
  void showdp(){
    pushMatrix();
    translate(p_d.x, p_d.y, p_d.z);
    box(15);
    popMatrix();
  }
  
  void showdq(){
    pushMatrix();
    
    float[][] Rd = {{1,0,0},{0,1,0},{0,0,1}};
    float s = 150.0;
    
    Rd[0][0] = 1 - 2*q_d[2]*q_d[2] - 2*q_d[3]*q_d[3];
    Rd[0][1] = 2*(q_d[1]*q_d[2] - q_d[0]*q_d[3]);
    Rd[0][2] = 2*(q_d[1]*q_d[3] + q_d[0]*q_d[2]);
    Rd[1][0] = 2*(q_d[1]*q_d[2] + q_d[0]*q_d[3]);
    Rd[1][1] = 1 - 2*q_d[1]*q_d[1] - 2*q_d[3]*q_d[3];
    Rd[1][2] = 2*(q_d[2]*q_d[3] - q_d[0]*q_d[1]);
    Rd[2][0] = 2*(q_d[1]*q_d[3] - q_d[0]*q_d[2]);
    Rd[2][1] = 2*(q_d[2]*q_d[3] + q_d[0]*q_d[1]);
    Rd[2][2] = 1 - 2*q_d[1]*q_d[1] - 2*q_d[2]*q_d[2];
    
    applyMatrix(
      Rd[0][0], Rd[0][1], Rd[0][2], p.x, 
      Rd[1][0], Rd[1][1], Rd[1][2], p.y, 
      Rd[2][0], Rd[2][1], Rd[2][2], p.z, 
      0.0, 0.0, 0.0, 1.0 
      );
    
    stroke(125, 40, 40, 255);
    line(-s, 0, 0, 0);
    stroke(255, 0, 0, 255);
    line(0, 0, s, 0);

    stroke(40, 125, 40, 255);
    line(0, -s, 0, 0);
    stroke(0, 255, 0, 255);
    line(0, 0, 0, s);

    stroke(40, 40, 125, 255);
    line(0, 0, -s, 0, 0, 0);
    stroke(0, 0, 255, 255);
    line(0, 0, 0, 0, 0, s);
    
    stroke(0);
    
    popMatrix();
  }
  
  void updatedp(float inxl, float inyl){
    p_d.x += 0.015*inxl;
    p_d.y -= 0.015*inyl;
  }
  
  void updatedq(float inxr, float inyr){/*
    q_d[0] =  cos(inxr/(2*1000.0));
    q_d[2] = -sin(inxr/(2*1000.0));
    
    q_d[0] = cos(inyr/(2*1000.0));
    q_d[1] = sin(inyr/(2*1000.0));*/
    
    q_d[0] = cos(inyr/(2*1000.0))*cos(inxr/(2*1000.0));
    q_d[1] = -cos(inxr/(2*1000.0))*sin(inyr/(2*1000.0));
    q_d[2] = -cos(inyr/(2*1000.0))*sin(inxr/(2*1000.0));
    q_d[3] = sin(inyr/(2*1000.0))*sin(inxr/(2*1000.0));
    
    
  }
}

float smartSqrt(float a) {
  if (a <= 0.0) {
    return 0.0;
  } else {
    return sqrt(a);
  }
}