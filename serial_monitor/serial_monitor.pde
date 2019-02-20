// Graphing sketch
 
 
 // This program takes ASCII-encoded strings
 // from the serial port at 9600 baud and graphs them. It expects values in the
 // range 0 to 1023, followed by a newline, or newline and carriage return
 
 // Created 20 Apr 2005
 // Updated 18 Jan 2008
 // Changed by Me 30 Jun 2015 to fit my needs. My changes are followed by a comment indicated by //**
 // by Tom Igoe
 // This example code is in the public domain.
 
import processing.serial.*;
 
Serial myPort;        // The serial port
int xPos = 1;         // horizontal position of the graph
int axis = 1; //**
int step = 0;
int sampleSize = 200;
float radPerSekPerIntX = 50 * 0.03490658504/32767.0;
float radPerSekPerIntY = 50 * 0.03490658504/32767.0;
float radPerSekPerIntZ = 50 * 0.03490658504/32767.0;

float[] tempX = new float[sampleSize];
float[] tempY = new float[sampleSize];
float[] tempZ = new float[sampleSize];
float correctionX = 0.0;
float correctionY = 0.0;
float correctionZ = 0.0;
float lowerLimitX = 0;
float upperLimitX = 0;
float lowerLimitY = 0;
float upperLimitY = 0;
float lowerLimitZ = 0;
float upperLimitZ = 0;
float sigmaX = 0.0;
float sigmaY = 0.0;
float sigmaZ = 0.0;

float[] t1 = {0.0, 0.0, 0.0};
float[] t2 = {0.0, 0.0, 0.0};
float[] dt = {0.0, 0.0, 0.0};

float[] omega = {0.0, 0.0, 0.0};
float[] axisVector = {1.0, 0.0, 0.0};
float angle = 0.0;

float[] attitude = {1.0, 0.0, 0.0};
float[] attitude2 = {0.0, 1.0, 0.0};

float[] attitude0 = {1.0, 0.0, 0.0};
float[] attitudeQ = {1.0, 0.0, 0.0, 0.0};

void setup () {
  // set the window size:
  size(1200, 600);        
 
  // List all the available serial ports
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 38400);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
  // set inital background:
  
  background(0);
}
void draw () {
  // everything happens in the serialEvent()
}
 
void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');
  
  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
    // convert to an int and map to the screen height:
    float inByte = float(inString); 
    if (Float.isNaN(inByte)) {
      inByte = 0.0;
    }
    
    if (axis == 1) { //** x-axis
      axis = 2;
  //    print("inByte: ");
  //    print(inByte);
  //    print(" ");
            
      omega[0] = inByte;
      t2[0] = millis();
      dt[0] = (t2[0] - t1[0])/1000;
      t1[0] = millis();
            
      inByte = map(inByte, -32768, 32767, -100, 100);
      stroke(255, 0, 0);
      line(xPos, height - 100, xPos, height - 100 - inByte);
      
    } else if (axis == 2) { //** y-axis
      axis = 3;
 //     print(inByte);
 //     print(" ");
      
      omega[1] = inByte;
      t2[1] = millis();
      dt[1] = (t2[1] - t1[1])/1000;
      t1[1] = millis();
            
      inByte = map(inByte, -32768, 32767, -100, 100);
      stroke(0, 255, 0);
      line(xPos, height - 300, xPos, height - 300 - inByte);
      
    } else { //** z-axis
      axis = 1;
//      println(inByte);
      
      omega[2] = inByte;
      t2[2] = millis();
      dt[2] = (t2[2] - t1[2])/1000;
      t1[2] = millis();
      
      inByte = map(inByte, -32768, 32767, -100, 100);
      stroke(0, 0, 255);
      line(xPos, height - 500, xPos, height - 500 - inByte);
      

      
      ++step; 
      
      if (step < sampleSize) {
        tempX[step - 1] = omega[0];
        tempY[step - 1] = omega[1];
        tempZ[step - 1] = omega[2];
        
      } else if (step == sampleSize){
        for (int i = 0; i < sampleSize; ++i) {
          correctionX += tempX[i];
          correctionY += tempY[i];
          correctionZ += tempZ[i];
          
        }
        correctionX = correctionX / sampleSize;
        correctionY = correctionY / sampleSize;
        correctionZ = correctionZ / sampleSize;
        for(int i = 0; i < sampleSize; ++i){
          sigmaX += (correctionX - tempX[i])*(correctionX - tempX[i]);
          sigmaY += (correctionY - tempY[i])*(correctionY - tempY[i]);
          sigmaZ += (correctionZ - tempZ[i])*(correctionZ - tempZ[i]);
        }
        sigmaX = sqrt(sigmaX/(sampleSize - 1));
        sigmaY = sqrt(sigmaY/(sampleSize - 1));
        sigmaZ = sqrt(sigmaZ/(sampleSize - 1));
        
        lowerLimitX = correctionX - 1*sigmaX;
        upperLimitX = correctionX + 1*sigmaX;
        lowerLimitY = correctionY - 1*sigmaY;
        upperLimitY = correctionY + 1*sigmaY;
        lowerLimitZ = correctionZ - 1*sigmaZ;
        upperLimitZ = correctionZ + 1*sigmaZ;
      }else{
        
        if (omega[0] < upperLimitX && omega[0] > lowerLimitX){
          omega[0] = 0.0;
        } else {
          omega[0] = omega[0] - correctionX;
        }
        if (omega[1] < upperLimitY && omega[1] > lowerLimitY){
          omega[1] = 0.0;
        } else {
          omega[1] = omega[1] - correctionY;
        }
        if (omega[2] < upperLimitZ && omega[2] > lowerLimitZ){
          omega[2] = 0.0;
        } else {
          omega[2] = omega[2] - correctionZ;
        }
        
        axisVector = normalizee(omega);
        
        omega[0] = omega[0] * radPerSekPerIntX;
        omega[1] = omega[1] * radPerSekPerIntY;
        omega[2] = omega[2] * radPerSekPerIntZ;
        
        angle = lengthh(omega) * (dt[0] + dt[1] + dt[2]);
        
      //  Integration using quaternion derivative
        
        //attitudeQ = quaternionProduct(scaleQuaternion(dt[0] + dt[1] + dt[2], quaternionDerivative(attitudeQ, omega)), attitudeQ);
        attitudeQ = quaternionProduct(attitudeQ, makeQuaternion(angle, axisVector));
        //attitudeQ = scaleQuaternion(1/qNorm(attitudeQ), attitudeQ);
        attitude = rotateQ(attitudeQ, attitude0);
        
        
        //Integration using Rotation matrix
        /*
        attitude = rotatee(angle, axisVector, attitude);
        attitude2 = rotatee(angle, axisVector, attitude2);*/
      }

      if(step % 100 == 0){
      
      print("Angular frequency: ");
      print(omega[0]);
      print(" ");
      print(omega[1]);
      print(" ");
      println(omega[2]);
      
      print("Time step: ");
      print(" ");
      print(dt[2] + dt[2] + dt[2]);
      print(dt[0]);
      print(" ");
      print(dt[1]);
      print(" ");
      println(dt[2]);
      
      print("Attitude Quaternion: ");
      print(attitudeQ[0]);
      print(" ");
      print(attitudeQ[1]);
      print(" ");
      print(attitudeQ[2]);
      print(" ");
      println(attitudeQ[3]);
      
      
      print(step + " ");
      print("Attitude unit vector: ");
      print(attitude[0]);
      print(" ");
      print(attitude[1]);
      print(" ");
      println(attitude[2]);
      
      }
      /*
      print("Correction: ");
      print(correctionX);
      print(" ");
      print(correctionY);
      print(" ");
      print(correctionZ);
      println(" ");
      print("Standard deviation: ");
      print(sigmaX);
      print(" ");
      print(sigmaY);
      print(" ");
      print(sigmaZ);
      println(" ");
      print("Limits: ");
      print(lowerLimitX);
      print(" ");
      print(upperLimitX);
      print(" ");
      print(lowerLimitY);
      print(" ");
      print(upperLimitY);
      print(" ");
      print(lowerLimitZ);
      print(" ");
      print(upperLimitZ);
      println(" ");*/
      
          
      // at the edge of the screen, go back to the beginning:
      if (xPos >= width) {
        xPos = 0;
        background(0); 
      } else {
        // increment the horizontal position:
        xPos++;
      } 
    }
  }
}
