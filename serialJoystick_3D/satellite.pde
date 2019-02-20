class Satellite {
  PVector p;
  PVector v;
  float[] q = {1, 0, 0, 0};
  PVector w;

  PVector p_d;
  float[] q_d = {1, 0, 0, 0};

  PVector F;
  PVector tau;
  PVector tau_input;

  ArrayList<PVector> thrusterDir = new ArrayList();
  ArrayList<PVector> thrusterPos = new ArrayList();
  float[] thrusters = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
  
  float[][] R = {{1, 0, 0},{0, 1, 0},{0, 0, 1}};

  float l = 100.0;
  PImage tex;

  Satellite() {
    calcRotationMatrix();

    p = new PVector(0.0, 800.0, 500.0);
    v = new PVector(0.0, 0.0, 0.0);
    w = new PVector(0.0, 0.3, 0.0);

    p_d = new PVector(0.0, 0.0, 0.0);

    F = new PVector(0.0, 0.0, 0.0);
    tau = new PVector(0.0, 0.0, 0.0);
    tau_input = new PVector(0.0, 0.0, 0.0);

    thrusterDir.add(new PVector(0, -1, 0));
    thrusterDir.add(new PVector(0, 1, 0));

    thrusterDir.add(new PVector(0, 0, 1));
    thrusterDir.add(new PVector(0, 0, -1));

    thrusterDir.add(new PVector(-1, 0, 0));
    thrusterDir.add(new PVector(1, 0, 0));

    thrusterPos.add(new PVector(0, 0, l));
    thrusterPos.add(new PVector(0, 0, -l));

    thrusterPos.add(new PVector(-l, 0, 0));
    thrusterPos.add(new PVector(l, 0, 0));

    thrusterPos.add(new PVector(0, l, 0));
    thrusterPos.add(new PVector(0, -l, 0));
  }

  void updatepd(float inxl, float inyl) {
    p_d.x -= inxl / 200.0;
    p_d.y += inyl / 200.0;
  }
  
  void setpd(float x, float y, float z) {
    p_d.x = x;
    p_d.y = y;
    p_d.z = z;
  }

  void updateqd(float inxr, float inyr) {
  }

  void torqueInput(float inxr, float inyr) {
    tau_input.x = 0.0;
    tau_input.y = 0.0;
    tau_input.y = inxr / 10.0;
    tau_input.x = inyr / 10.0;
  }

  void update(float dt) {
    calcThrusts();
    calcTorqueForce();
    updateSpaceShip(dt);
  }
  
  void calcRotationMatrix(){
    float r00 = 1 - 2*q[2]*q[2] - 2*q[3]*q[3];
    float r11 = 1 - 2*q[1]*q[1] - 2*q[3]*q[3];
    float r22 = 1 - 2*q[1]*q[1] - 2*q[2]*q[2];

    float r01 = 2*(q[1]*q[2] - q[0]*q[3]);
    float r02 = 2*(q[1]*q[3] + q[0]*q[2]);
    float r12 = 2*(q[2]*q[3] - q[0]*q[1]);

    float r10 = 2*(q[1]*q[2] + q[0]*q[3]);
    float r20 = 2*(q[1]*q[3] - q[0]*q[2]);
    float r21 = 2*(q[2]*q[3] + q[0]*q[1]);
    
    R[0][0] = r00;
    R[0][1] = r01;
    R[0][2] = r02;
    R[1][0] = r10;
    R[1][1] = r11;
    R[1][2] = r12;
    R[2][0] = r20;
    R[2][1] = r21;
    R[2][2] = r22;
  }

  void updateSpaceShip(float dt) {

    PVector Force = F.copy();
    
    Force.x = R[0][0]*F.x + R[0][1]*F.y + R[0][2]*F.z;
    Force.y = R[1][0]*F.x + R[1][1]*F.y + R[1][2]*F.z;
    Force.z = R[2][0]*F.x + R[2][1]*F.y + R[2][2]*F.z;

    v.add(Force.copy().mult(dt));
    p.add(v.copy().mult(dt));

    w.add(tau.copy().mult(dt/100.0));
    q[0] += -0.5*dt*(q[1]*w.x + q[2]*w.y + q[3]*w.z);
    q[1] += 0.5*dt*(q[0]*w.x - q[3]*w.y + q[2]*w.z);
    q[2] += 0.5*dt*(q[3]*w.x + q[0]*w.y - q[1]*w.z);
    q[3] += 0.5*dt*(-q[2]*w.x + q[1]*w.y + q[0]*w.z);

    float len = sqrt(q[0]*q[0] + q[1]*q[1] + q[2]*q[2] + q[3]*q[3]);

    q[0] /= len; 
    q[1] /= len; 
    q[2] /= len; 
    q[3] /= len;
  }

  void calcTorqueForce() {
    F.x = thrusters[5] - thrusters[4];
    F.y = thrusters[1] - thrusters[0];
    F.z = thrusters[2] - thrusters[3];

    tau.x = 100.0*l*(thrusters[0] + thrusters[1]);
    tau.y = 100.0*l*(thrusters[2] + thrusters[3]);
    tau.z = 100.0*l*(thrusters[4] + thrusters[5]);

    tau.add(tau_input);
  }

  void calcThrusts() {

    float[] q_err = {1, 0, 0, 0};
    /*
  //q * q_d
     q_err[0] = q[0]*q_d[0] - q[1]*q_d[1] - q[2]*q_d[2] - q[3]*q_d[3];
     q_err[1] = q[1]*q_d[0] + q[0]*q_d[1] - q[3]*q_d[2] + q[2]*q_d[3];
     q_err[2] = q[2]*q_d[0] + q[3]*q_d[1] + q[0]*q_d[2] - q[1]*q_d[3];
     q_err[3] = q[3]*q_d[0] - q[2]*q_d[1] + q[1]*q_d[2] + q[0]*q_d[3];*/
    /*
  //q_d * q
     q_err[0] = q_d[0]*q[0] - q_d[1]*q[1] - q_d[2]*q[2] - q_d[3]*q[3];
     q_err[1] = q_d[1]*q[0] + q_d[0]*q[1] - q_d[3]*q[2] + q_d[2]*q[3];
     q_err[2] = q_d[2]*q[0] + q_d[3]*q[1] + q_d[0]*q[2] - q_d[1]*q[3];
     q_err[3] = q_d[3]*q[0] - q_d[2]*q[1] + q_d[1]*q[2] + q_d[0]*q[3];*/
    /*
  // q * q_d' //controls to eta = 1
     q_err[0] = q[0]*q_d[0] + q[1]*q_d[1] + q[2]*q_d[2] + q[3]*q_d[3];
     q_err[1] = q[1]*q_d[0] - q[0]*q_d[1] + q[3]*q_d[2] - q[2]*q_d[3];
     q_err[2] = q[2]*q_d[0] - q[3]*q_d[1] - q[0]*q_d[2] + q[1]*q_d[3];
     q_err[3] = q[3]*q_d[0] + q[2]*q_d[1] - q[1]*q_d[2] - q[0]*q_d[3];*/

    //q_d' * q //controls to eta = 1
    q_err[0] =   q_d[0]*q[0] + q_d[1]*q[1] + q_d[2]*q[2] + q_d[3]*q[3];
    q_err[1] = - q_d[1]*q[0] + q_d[0]*q[1] + q_d[3]*q[2] - q_d[2]*q[3];
    q_err[2] = - q_d[2]*q[0] - q_d[3]*q[1] + q_d[0]*q[2] + q_d[1]*q[3];
    q_err[3] = - q_d[3]*q[0] + q_d[2]*q[1] - q_d[1]*q[2] + q_d[0]*q[3];
    /*
  //q' * q_d //controls to eta = -1
     q_err[0] =   q[0]*q_d[0] + q[1]*q_d[1] + q[2]*q_d[2] + q[3]*q_d[3];
     q_err[1] = - q[1]*q_d[0] + q[0]*q_d[1] + q[3]*q_d[2] - q[2]*q_d[3];
     q_err[2] = - q[2]*q_d[0] - q[3]*q_d[1] + q[0]*q_d[2] + q[1]*q_d[3];
     q_err[3] = - q[3]*q_d[0] + q[2]*q_d[1] - q[1]*q_d[2] + q[0]*q_d[3];*/
    /*
  //q_d * q' //controls to eta = -1
     q_err[0] = q_d[0]*q[0] + q_d[1]*q[1] + q_d[2]*q[2] + q_d[3]*q[3];
     q_err[1] = q_d[1]*q[0] - q_d[0]*q[1] + q_d[3]*q[2] - q_d[2]*q[3];
     q_err[2] = q_d[2]*q[0] - q_d[3]*q[1] - q_d[0]*q[2] + q_d[1]*q[3];
     q_err[3] = q_d[3]*q[0] + q_d[2]*q[1] - q_d[1]*q[2] - q_d[0]*q[3];*/

    float kp = 0.2;
    PVector t = w.copy().mult(-0.5);
    if (q_err[0] > 0.0) {
      t.add(-kp*q_err[1], -kp*q_err[2], -kp*q_err[3]);
    } else {
      t.add(kp*q_err[1], kp*q_err[2], kp*q_err[3]);
    }
    
    PVector f = p_d.copy().sub(p);
    f.mult(0.1);
    f.sub(v.copy().mult(0.3));

    PVector Force = f.copy();
    Force.x = R[0][0]*f.x + R[1][0]*f.y + R[2][0]*f.z;
    Force.y = R[0][1]*f.x + R[1][1]*f.y + R[2][1]*f.z;
    Force.z = R[0][2]*f.x + R[1][2]*f.y + R[2][2]*f.z;
    
    f.x = Force.x;
    f.y = Force.y;
    f.z = Force.z;

    thrusters[0] = 0.5*(-f.y + t.x/l);
    thrusters[1] = 0.5*(f.y + t.x/l);
    thrusters[2] = 0.5*(f.z + t.y/l);
    thrusters[3] = 0.5*(-f.z + t.y/l);
    thrusters[4] = 0.5*(-f.x + t.z/l);
    thrusters[5] = 0.5*(f.x + t.z/l);
  }

  void show() {
    pushMatrix();
    applyQuaternionAndTranslation();
    body();
    axes();
    thrusters();
    popMatrix();

    showdp();
  }

  void applyQuaternionAndTranslation() {
    
    calcRotationMatrix();
    
    applyMatrix(
      R[0][0], R[0][1], R[0][2], p.x, 
      R[1][0], R[1][1], R[1][2], p.y, 
      R[2][0], R[2][1], R[2][2], p.z, 
      0.0, 0.0, 0.0, 1.0 
      );
  }

  void body()
  {

    float d = 40.0;

    beginShape();
    texture(tex);
    vertex(-d, -d, -d, 0, 0);
    vertex(-d, -d, d, 1, 0);
    vertex(-d, d, d, 1, 1);
    vertex(-d, d, -d, 0, 1);
    endShape();

    beginShape();
    texture(tex);
    vertex(d, -d, d, 0, 0);
    vertex(d, -d, -d, 1, 0);
    vertex(d, d, -d, 1, 1);
    vertex(d, d, d, 0, 1);
    endShape();

    beginShape();
    texture(tex);
    vertex(d, -d, -d, 0, 0);
    vertex(-d, -d, -d, 1, 0);
    vertex(-d, d, -d, 1, 1);
    vertex(d, d, -d, 0, 1);
    endShape();

    beginShape();
    texture(tex);
    vertex(-d, -d, d, 0, 0);
    vertex(d, -d, d, 1, 0);
    vertex(d, d, d, 1, 1);
    vertex(-d, d, d, 0, 1);
    endShape();
  }

  void axes() {
    stroke(125, 40, 40, 255);
    line(-l, 0, 0, 0);
    stroke(255, 0, 0, 255);
    line(0, 0, l, 0);

    stroke(40, 125, 40, 255);
    line(0, -l, 0, 0);
    stroke(0, 255, 0, 255);
    line(0, 0, 0, l);

    stroke(40, 40, 125, 255);
    line(0, 0, -l, 0, 0, 0);
    stroke(0, 0, 255, 255);
    line(0, 0, 0, 0, 0, l);
  }

  void thrusters() {
    strokeWeight(1.0/scale);
    stroke(255, 255, 255, 255);
    PVector temp, tempp;
    for (int i = 0; i < 6; i++) {

      temp = thrusterPos.get(i);
      tempp = PVector.add(temp, thrusterDir.get(i).copy().mult(50.0*thrusters[i]));
      line(temp.x, temp.y, temp.z, tempp.x, tempp.y, tempp.z);
    }
    strokeWeight(1.0/scale);
    stroke(0);
  }

  void showdp() {
    pushMatrix();
    translate(sat.p_d.x, sat.p_d.y, sat.p_d.z);
    fill(204, 4, 0);
    stroke(104, 4, 0);
    box(25.0);
    stroke(0);
    fill(255);
    popMatrix();
  }
}