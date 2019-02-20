class SbusReadClass {
  Serial port;

  boolean newData = false;
  boolean startFound = false;
  String recData = "";
  char[] recDataChar = new char[25];
  int[] recDataInt = new int[25];
  int index = 0;

  int[] channel = new int[16];



  void printData() {
    if (newData) {
      println(millis(), " ", port.available(), "", newData);
      for (int i = 0; i < 25; i++) {
        print(recDataInt[i], "\t");
      }
      for (int i = 0; i < 25; i++) {
        print(toBinaryString(recDataInt[i]), " ");
      }
      println(" ");

      print("ChannelData: ");
      for (int i = 0; i < 16; i++) {
        print(channel[i], "\t");
      }
      println(" ");

      newData = false;
    }
  }

  void interpret() {
    /*
    int byte_in_sbus = 1;
     int bit_in_sbus = 0;
     int ch = 0;
     int bit_in_channel = 0;
     
     for (int i = 0; i < 176; i++) {
     if ((recDataInt[byte_in_sbus] & (1<<bit_in_sbus)) > 0) {
     channel[ch] |= (1<<bit_in_channel);
     }
     bit_in_sbus++;
     bit_in_channel++;
     
     if (bit_in_sbus == 8) {
     bit_in_sbus = 0;
     byte_in_sbus++;
     }
     if (bit_in_channel == 11) {
     bit_in_channel = 0;
     ch++;
     }
     }*/




    /*
    channel[ 0] = ((recDataInt[21] & 255) <<  3) + ((recDataInt[20] & 224) >> 5);
     channel[ 1] = ((recDataInt[20] &  31) <<  6) + ((recDataInt[19] & 252) >> 2);
     channel[ 2] = ((recDataInt[19] &   3) <<  9) + ((recDataInt[18] & 255) << 1) + ((recDataInt[17] & 128) >> 7);
     channel[ 3] = ((recDataInt[17] & 127) <<  4) + ((recDataInt[16] & 240) >> 4);
     channel[ 4] = ((recDataInt[16] &  15) <<  7) + ((recDataInt[15] & 254) >> 1);
     channel[ 5] = ((recDataInt[15] &   1) << 10) + ((recDataInt[14] & 255) << 2) + ((recDataInt[13] & 192) >> 6);
     channel[ 6] = ((recDataInt[13] &  63) <<  5) + ((recDataInt[12] & 248) >> 3);
     channel[ 7] = ((recDataInt[12] &   7) <<  8) + ((recDataInt[11] & 255));
     channel[ 8] = ((recDataInt[10] & 255) <<  3) + ((recDataInt[ 9] & 224) >> 5);
     channel[ 9] = ((recDataInt[ 9] &  31) <<  6) + ((recDataInt[ 8] & 252) >> 2);
     channel[10] = ((recDataInt[ 8] &   3) <<  9) + ((recDataInt[ 7] & 255) << 1) + ((recDataInt[ 6] & 128) >> 7);
     channel[11] = ((recDataInt[ 6] & 127) <<  4) + ((recDataInt[ 5] & 240) >> 4);
     channel[12] = ((recDataInt[ 5] &  15) <<  7) + ((recDataInt[ 4] & 254) >> 1);
     channel[13] = ((recDataInt[ 4] &   1) << 10) + ((recDataInt[ 3] & 255) << 2) + ((recDataInt[19] & 192) >> 6);
     channel[14] = ((recDataInt[ 2] &  63) <<  5) + ((recDataInt[ 1] & 248) >> 3);
     channel[15] = ((recDataInt[ 1] &   7) <<  8) + ((recDataInt[ 0] & 255));*/


/*
    channel[ 0] = ((recDataInt[ 1] & 255) <<  3) | ((recDataInt[ 2] & 224) >> 5);
    channel[ 1] = ((recDataInt[ 2] &  31) <<  6) | ((recDataInt[ 3] & 252) >> 2);
    channel[ 2] = ((recDataInt[ 3] &   3) <<  9) | ((recDataInt[ 4] & 255) << 1) | ((recDataInt[ 5] & 128) >> 7);
    channel[ 3] = ((recDataInt[ 5] & 127) <<  4) | ((recDataInt[ 6] & 240) >> 4);
    channel[ 4] = ((recDataInt[ 6] &  15) <<  7) | ((recDataInt[ 7] & 254) >> 1);
    channel[ 5] = ((recDataInt[ 7] &   1) << 10) | ((recDataInt[ 8] & 255) << 2) | ((recDataInt[ 9] & 192) >> 6);
    channel[ 6] = ((recDataInt[ 9] &  63) <<  5) | ((recDataInt[10] & 248) >> 3);
    channel[ 7] = ((recDataInt[10] &   7) <<  8) | ((recDataInt[11] & 255));

    channel[ 8] = ((recDataInt[12] & 255) <<  3) | ((recDataInt[13] & 224) >> 5);
    channel[ 9] = ((recDataInt[13] &  31) <<  6) | ((recDataInt[14] & 252) >> 2);
    channel[10] = ((recDataInt[14] &   3) <<  9) | ((recDataInt[15] & 255) << 1) | ((recDataInt[16] & 128) >> 7);
    channel[11] = ((recDataInt[16] & 127) <<  4) | ((recDataInt[17] & 240) >> 4);
    channel[12] = ((recDataInt[17] &  15) <<  7) | ((recDataInt[18] & 254) >> 1);
    channel[13] = ((recDataInt[18] &   1) << 10) | ((recDataInt[19] & 255) << 2) | ((recDataInt[20] & 192) >> 6);
    channel[14] = ((recDataInt[20] &  63) <<  5) | ((recDataInt[21] & 248) >> 3);
    channel[15] = ((recDataInt[21] &   7) <<  8) | ((recDataInt[22] & 255));*/


    channel[0]  = ((recDataInt[1]      | recDataInt[2] << 8)                      & 2047);
    channel[1]  = ((recDataInt[2] >> 3 | recDataInt[3] << 5)                      & 2047);
    channel[2]  = ((recDataInt[3] >> 6 | recDataInt[4] << 2 | recDataInt[5]<<10)  & 2047);
    channel[3]  = ((recDataInt[5] >> 1 | recDataInt[6] << 7)                      & 2047);
    channel[4]  = ((recDataInt[6] >> 4 | recDataInt[7] << 4)                      & 0x07FF);
    channel[5]  = ((recDataInt[7] >> 7 | recDataInt[8] << 1 | recDataInt[9]<<9)   & 0x07FF);
    channel[6]  = ((recDataInt[9] >> 2 | recDataInt[10]<< 6)                      & 0x07FF);
    channel[7]  = ((recDataInt[10]>> 5 | recDataInt[11]<< 3)                      & 0x07FF);
    channel[8]  = ((recDataInt[12]     | recDataInt[13]<< 8)                      & 0x07FF);
    channel[9]  = ((recDataInt[13]>> 3 | recDataInt[14]<< 5)                      & 0x07FF);
    channel[10] = ((recDataInt[14]>> 6 | recDataInt[15]<< 2 | recDataInt[16]<<10) & 0x07FF);
    channel[11] = ((recDataInt[16]>> 1 | recDataInt[17]<< 7)                      & 0x07FF);
    channel[12] = ((recDataInt[17]>> 4 | recDataInt[18]<< 4)                      & 0x07FF);
    channel[13] = ((recDataInt[18]>> 7 | recDataInt[19]<< 1 | recDataInt[20]<<9)  & 0x07FF);
    channel[14] = ((recDataInt[20]>> 2 | recDataInt[21]<< 6)                      & 0x07FF);
    channel[15] = ((recDataInt[21]>> 5 | recDataInt[22]<< 3)                      & 0x07FF);

    /*
    channel[0]  = ((recDataInt[0]      | recDataInt[1] << 8)                      & 2047);
    channel[1]  = ((recDataInt[1] >> 3 | recDataInt[2] << 5)                      & 2047);
    channel[2]  = ((recDataInt[2] >> 6 | recDataInt[3] << 2 | recDataInt[4]<<10)  & 2047);
    channel[3]  = ((recDataInt[4] >> 1 | recDataInt[5] << 7)                      & 2047);
    channel[4]  = ((recDataInt[5] >> 4 | recDataInt[6] << 4)                      & 0x07FF);
    channel[5]  = ((recDataInt[6] >> 7 | recDataInt[7] << 1 | recDataInt[8]<<9)   & 0x07FF);
    channel[6]  = ((recDataInt[8] >> 2 | recDataInt[9] << 6)                      & 0x07FF);
    channel[7]  = ((recDataInt[9] >> 5 | recDataInt[10]<< 3)                      & 0x07FF);
    channel[8]  = ((recDataInt[11]     | recDataInt[12]<< 8)                      & 0x07FF);
    channel[9]  = ((recDataInt[12]>> 3 | recDataInt[13]<< 5)                      & 0x07FF);
    channel[10] = ((recDataInt[13]>> 6 | recDataInt[14]<< 2 | recDataInt[15]<<10) & 0x07FF);
    channel[11] = ((recDataInt[15]>> 1 | recDataInt[16]<< 7)                      & 0x07FF);
    channel[12] = ((recDataInt[16]>> 4 | recDataInt[17]<< 4)                      & 0x07FF);
    channel[13] = ((recDataInt[17]>> 7 | recDataInt[18]<< 1 | recDataInt[19]<<9)  & 0x07FF);
    channel[14] = ((recDataInt[19]>> 2 | recDataInt[20]<< 6)                      & 0x07FF);
    channel[15] = ((recDataInt[20]>> 5 | recDataInt[21]<< 3)                      & 0x07FF);*/

    /*
    channel[ 0] = ((recDataInt[ 0] & 0b11111111) <<  3) + ((recDataInt[ 1] & 0b11100000) >> 5);
     channel[ 1] = ((recDataInt[ 1] & 0b00011111) <<  6) + ((recDataInt[ 2] & 0b11111100) >> 2);
     channel[ 2] = ((recDataInt[ 2] & 0b00000011) <<  9) + ((recDataInt[ 3] & 0b11111111) << 1) + ((recDataInt[ 4] & 0b10000000) >> 7);
     channel[ 3] = ((recDataInt[ 4] & 0b01111111) <<  4) + ((recDataInt[ 5] & 0b11110000) >> 4);
     channel[ 4] = ((recDataInt[ 5] & 0b00001111) <<  7) + ((recDataInt[ 6] & 0b11111110) >> 1);
     channel[ 5] = ((recDataInt[ 6] & 0b00000001) << 10) + ((recDataInt[ 7] & 0b11111111) << 2) + ((recDataInt[ 8] & 0b11000000) >> 6);
     channel[ 6] = ((recDataInt[ 8] & 0b00111111) <<  5) + ((recDataInt[ 9] & 0b11111000) >> 3);
     channel[ 7] = ((recDataInt[ 9] & 0b00000111) <<  8) + ((recDataInt[10] & 0b11111111));
     channel[ 8] = ((recDataInt[11] & 0b11111111) <<  3) + ((recDataInt[12] & 0b11100000) >> 5);
     channel[ 9] = ((recDataInt[12] & 0b00011111) <<  6) + ((recDataInt[13] & 0b11111100) >> 2);
     channel[10] = ((recDataInt[13] & 0b00000011) <<  9) + ((recDataInt[14] & 0b11111111) << 1) + ((recDataInt[15] & 0b10000000) >> 7);
     channel[11] = ((recDataInt[15] & 0b01111111) <<  4) + ((recDataInt[16] & 0b11110000) >> 4);
     channel[12] = ((recDataInt[16] & 0b00001111) <<  7) + ((recDataInt[17] & 0b11111110) >> 1);
     channel[13] = ((recDataInt[17] & 0b00000001) << 10) + ((recDataInt[18] & 0b11111111) << 2) + ((recDataInt[19] & 0b11000000) >> 6);
     channel[14] = ((recDataInt[19] & 0b00111111) <<  5) + ((recDataInt[20] & 0b11111000) >> 3);
     channel[15] = ((recDataInt[20] & 0b00000111) <<  8) + ((recDataInt[21] & 0b11111111));*/
  }

  void read() {

    while (!startFound && port.available() > 0) {
      int temp = port.read(); 
      if (temp == 0xF0) {
        recData = "";
        startFound = true;
        recDataChar[0] = char(temp);
        recDataInt[0] = temp;
      }
    }

    if (startFound && port.available() >= 24) {
      for (int i = 1; i < 25; i++) {
        int dat = port.read();
        recData += dat;
        recDataChar[i] = char(dat);
        //recDataInt[i] = (~dat) & 255;
        //recDataInt[i] = reverseBits(dat);
        recDataInt[i] = dat;
      }
      clearPort();
      startFound = false;
      newData = true;
    }
  }


  void clearPort() {
    //port.clear();
    while (port.available() > 25) {
      port.read();
    }
  }

  String toBinaryString(int i) {
    i = ~i;
    String bin = "";
    for (int j = 7; j >=0; j--) {
      if ((i & int(pow(2, j))) > 0) {
        bin += '1';
      } else {
        bin += '0';
      }
    }
    return bin;
  }

  int reverseBits(int b) {
    b = (b & 0xF0) >> 4 | (b & 0x0F) << 4;
    b = (b & 0xCC) >> 2 | (b & 0x33) << 2;
    b = (b & 0xAA) >> 1 | (b & 0x55) << 1;
    return b;
  }
}


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

  float getGyrX() {
    return dataGyr.get(dataGyr.size()-1).x;
  }
  float getGyrY() {
    return dataGyr.get(dataGyr.size()-1).y;
  }
  float getGyrZ() {
    return dataGyr.get(dataGyr.size()-1).z;
  }
}