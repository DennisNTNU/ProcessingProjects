import processing.serial.*;

Serial port;

void setup(){
  size(1280, 720);
  frameRate(60);
  
  printArray(Serial.list());
  if (Serial.list().length != 0) {
    port = new Serial(this, Serial.list()[0], 57600, 'E', 8, 2);
  }
}

void draw(){
  background(52);
  
}