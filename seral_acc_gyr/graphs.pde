class Graphs {
  ArrayList<PVector> dataAcc;
  ArrayList<PVector> dataGyr;

  ArrayList<PVector> dataAccLP;
  ArrayList<PVector> dataGyrLP;

  int samples = 120;
  int currentSize = 0;

  PVector gyrAvg;
  PVector gyrStdv;

  boolean max = false;

  Graphs() {
    dataAcc = new ArrayList();
    dataGyr = new ArrayList();

    dataAccLP = new ArrayList();
    dataGyrLP = new ArrayList();

    gyrAvg = new PVector(0.0, 0.0, 0.0);
    gyrStdv = new PVector(0.0, 0.0, 0.0);

    dataAccLP.add(new PVector(0.0, 0.0, 0.0));
    dataGyrLP.add(new PVector(0.0, 0.0, 0.0));
  }

  void newData(int[] data) {

    dataAcc.add(new PVector(data[0], data[1], data[2]));
    dataGyr.add(new PVector(-data[3], -data[4], data[5]));

    lpFilterData();
    decimate();

    if (dataAcc.size() == 120) {
      
      //filterNewstData();
      if (!max) {
        max = true;
        calcAvgStdv();
      }
    }
  }

  void filterNewstData() {
    if (abs(dataGyr.get(119).x - gyrAvg.x) < gyrStdv.x) {
      dataGyr.get(119).x = 0.0;
    }
    
    if (abs(dataGyr.get(119).y - gyrAvg.y) < gyrStdv.y) {
      dataGyr.get(119).y = 0.0;
    }
    
    if (abs(dataGyr.get(119).z - gyrAvg.z) < gyrStdv.z) {
      dataGyr.get(119).z = 0.0;
    }
  }

  void lpFilterData() {
    float ta = 0.25;
    PVector oldLP = dataAccLP.get(dataAccLP.size()-1);
    PVector newLP = (((dataAcc.get(dataAcc.size()-1).copy()).sub(oldLP)).mult(ta)).add(oldLP);
    dataAccLP.add(newLP.copy());

    ta = 0.25;
    oldLP = dataGyrLP.get(dataGyrLP.size()-1);
    newLP = (((dataGyr.get(dataGyr.size()-1).copy()).sub(oldLP)).mult(ta)).add(oldLP);
    dataGyrLP.add(newLP.copy());
  }

  void decimate() {
    if (dataAcc.size() > samples) {
      dataAcc.remove(0);
    }
    if (dataGyr.size() > samples) {
      dataGyr.remove(0);
    }
    if (dataAccLP.size() > samples) {
      dataAccLP.remove(0);
    }
    if (dataGyrLP.size() > samples) {
      dataGyrLP.remove(0);
    }
  }

  void calcAvgStdv() {
    for (int i = 0; i < 120; i++) {
      gyrAvg.add(dataGyr.get(i));
    }
    gyrAvg.mult(1/120.0);
    println("AverageCalculated");

    PVector help = new PVector(0, 0, 0);
    for (int i = 0; i < 120; i++) {
      help = gyrAvg.copy().sub(dataGyr.get(i));
      help.x = help.x*help.x; 
      help.y = help.y*help.y; 
      help.z = help.z*help.z;
      gyrStdv.add(help);
    }
    gyrStdv.mult(1/119.0);
  }

  void show() {
    float dx = 10;
    float graphLen = dx * samples;
    float displace = 500;

    //axes
    line(-graphLen, displace, 0, -dx, displace, 0);
    line(0, displace, 0, graphLen-dx, displace, 0);
    line(-graphLen, displace, 0, -graphLen, displace, 500);
    line(0, displace, 0, 0, displace, 500);

    //data
    for (int i = 1; i < dataAcc.size(); i++) {
      stroke(255, 0, 0, 155);
      line(dx*(i-1), displace, dataAcc.get(i-1).x, dx*i, displace, dataAcc.get(i).x);
      line(dx*(i-1) - graphLen, displace, dataGyr.get(i-1).x, dx*i - graphLen, displace, dataGyr.get(i).x);

      stroke(0, 255, 0, 155);
      line(dx*(i-1), displace, dataAcc.get(i-1).y, dx*i, displace, dataAcc.get(i).y);
      line(dx*(i-1) - graphLen, displace, dataGyr.get(i-1).y, dx*i - graphLen, displace, dataGyr.get(i).y);

      stroke(0, 0, 255, 155);
      line(dx*(i-1), displace, dataAcc.get(i-1).z, dx*i, displace, dataAcc.get(i).z);
      line(dx*(i-1) - graphLen, displace, dataGyr.get(i-1).z, dx*i - graphLen, displace, dataGyr.get(i).z);


/*
      stroke(105, 0, 0, 255);
      line(dx*(i-1), displace, dataAccLP.get(i-1).x, dx*i, displace, dataAccLP.get(i).x);
      line(dx*(i-1) - graphLen, displace, dataGyrLP.get(i-1).x - gyrAvg.x, dx*i - graphLen, displace, dataGyrLP.get(i).x - gyrAvg.x);

      stroke(0, 105, 0, 255);
      line(dx*(i-1), displace, dataAccLP.get(i-1).y, dx*i, displace, dataAccLP.get(i).y);
      line(dx*(i-1) - graphLen, displace, dataGyrLP.get(i-1).y - gyrAvg.y, dx*i - graphLen, displace, dataGyrLP.get(i).y - gyrAvg.y);

      stroke(0, 0, 105, 255);
      line(dx*(i-1), displace, dataAccLP.get(i-1).z, dx*i, displace, dataAccLP.get(i).z);
      line(dx*(i-1) - graphLen, displace, dataGyrLP.get(i-1).z - gyrAvg.z, dx*i - graphLen, displace, dataGyrLP.get(i).z - gyrAvg.z);*/
    }
  }
  
  float getGyrX(){
    return dataGyr.get(dataGyr.size()-1).x;
  }
  float getGyrY(){
    return dataGyr.get(dataGyr.size()-1).y;
  }
  float getGyrZ(){
    return dataGyr.get(dataGyr.size()-1).z;
  }
}