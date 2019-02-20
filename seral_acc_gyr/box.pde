import processing.serial.*;

class Box {
  float[] q = {1.0, 0.0, 0.0, 0.0};
  float[][] R = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}}; //this R rotates coordinates in body frame to coordinates in inertial frame
  int[] data = {0, 0, 0, 0, 0, 0, 0};
  PVector acc;
  PVector w;
  boolean newData = false;
  int timestamp = 0;

  boolean startFound = false;
  String recData = "";

  PVector RwEst;

  Serial port;

  Graphs graphs;

  Madgwick mgwk;

  Box() {
    acc = new PVector(0.0, 0.0, 0.0);
    w = new PVector(0.0, 0.0, 0.0);
    RwEst = new PVector(0.0, 0.0, 1.0);

    mgwk = new Madgwick();
    mgwk.gain = 1.0;
    graphs = new Graphs();
  }

  void update() {
    timestamp = millis();
    if (port != null) {
      getInput2();
    }

    if (newData) {
      newData = false;
      graphs.newData(data);

      integrate();
    }
    calcRotationMatrix();
  }

  void integrate() {


    acc.x = data[0]; 
    acc.y = data[1]; 
    acc.z = data[2];
    acc.normalize();

    float correctionFactor = 2.0;
    float dt = data[6] / 1000000.0;
    w.x = correctionFactor * 500.0 * PI * graphs.getGyrX() / (180.0 * 32767.0);
    w.y = correctionFactor * 500.0 * PI * graphs.getGyrY() / (180.0 * 32767.0);
    w.z = correctionFactor * 500.0 * PI * graphs.getGyrZ() / (180.0 * 32767.0);

    mgwk.madgwickAHRSupdateIMU(w.x, w.y, w.z, acc.x, acc.y, acc.z, dt);

    q[0] = mgwk.q0;
    q[1] = mgwk.q1;
    q[2] = mgwk.q2;
    q[3] = mgwk.q3;

    /*
    q[0] -= 0.5*dt*( q[1]*w.x + q[2]*w.y + q[3]*w.z);
     q[1] += 0.5*dt*( q[0]*w.x - q[3]*w.y + q[2]*w.z);
     q[2] += 0.5*dt*( q[3]*w.x + q[0]*w.y - q[1]*w.z);
     q[3] += 0.5*dt*(-q[2]*w.x + q[1]*w.y + q[0]*w.z);
     float len = sqrt(q[0]*q[0] + q[1]*q[1] + q[2]*q[2] + q[3]*q[3]);
     q[0] /= len;
     q[1] /= len;
     q[2] /= len;
     q[3] /= len;*/

    timestamp = millis();
  }

  void show() {
    graphs.show();

    pushMatrix();
    applyRotMatrix();

    stroke(0);
    box(60, 60, 20);
    axes();

    popMatrix();
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

  void applyRotMatrix() {
    applyMatrix(
      R[0][0], R[0][1], R[0][2], 0.0, 
      R[1][0], R[1][1], R[1][2], 0.0, 
      R[2][0], R[2][1], R[2][2], 0.0, 
      0.0, 0.0, 0.0, 1.0 );
  }

  void axes() {
    float l = 100.0;
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

  void getInput() {
    int in;
    int i = 0;
    String inString = "";
    String total = "";
    String residual = "";

    while (port.available() > 0) {
      in = port.read();
      total += char(in);

      if (in == int(';') || in == int(',')) {
        data[i] = int(inString);
        inString = "";
        i++;
      } else {
        inString += char(in);
      } 

      if (in == ';') {
        if (i >= 7) {
          newData = true;
        }
        break;
      }
    }

    while (port.available() > 0) {
      residual += char(port.read());
    }
  }

  void getInput2() {

    if (!startFound && port.available() > 0) {
      if (port.read() == 's') {
        recData = "";
        startFound = true;
      }
    }

    while (startFound && port.available() > 0) {
      char newestChar = char(port.read());
      if (newestChar == ';') {
        String[] dataa = recData.split(",");
        int l = dataa.length;
        if(l > 7){
          l = 7;
        }
        for(int i = 0; i < l; i++){
          data[i] = int(dataa[i]);
        }
        newData = true;
        startFound = false;
      }
      recData += newestChar;
    }
  }
}