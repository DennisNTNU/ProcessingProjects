
float signalPer;
float samplePer2;
float samplePer = 20;
float dp = 0.5;


void setup(){
  size(1280, 720);
  frameRate(20);
  background(191);
  
  signalPer = width / 20.0;
  
  drawAxes();
  drawFunc();
  
  float[] samps = sampleFunc(20);
  drawSamples(samps, 20);
  
}


void draw(){
  //background(51);
  
  
}

void keyPressed(){
  if(key == 'w'){
    samplePer+=dp;
  }
  if(key == 's'){
    samplePer-=dp;
  }
  
  if(samplePer <= 2){
    samplePer = 2;
  }
  if(samplePer >= 300){
    samplePer = 300;
  }
  
  samplePer2 = signalPer - samplePer;
  
  background(191);
  drawAxes();
  drawFunc();
  
  float[] samps = sampleFunc(samplePer);
  drawSamples(samps, samplePer);
  samps = sampleFunc(samplePer2);
  drawSamples2(samps, samplePer2);
  println(samplePer, samplePer / signalPer);
}