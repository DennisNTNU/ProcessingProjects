
float func(float t) {
  float amplitidi = 0.5*height/4;
  return amplitidi*cos(TWO_PI * t / signalPer);
}

void drawAxes() {

  stroke(0);
  line(0, height/4, width, height/4);
}

void drawFunc() {

  stroke(71);
  int dx = 3;
  for (int i = 0; i < width/dx; i++) {
    line(dx*i, height/4 - func(dx*i), dx*(i+1), height/4 - func(dx*(i+1)));
  }
}

float[] sampleFunc(float samplePeriod){
  int numSamples = int(width / samplePeriod);
  float[] samples = new float[numSamples]; 
  for(int i = 0; i < numSamples; i++){
    samples[i] = func(i*samplePeriod);
  }
  return samples;
}

void drawSamples(float[] samples, float samplePeriod){
  
  int a = samples.length;
  stroke(200, 0, 0, 255);
  for(int i = 0; i < a; i++){
    line(i*samplePeriod, height/4, i*samplePeriod, height/4 - samples[i]);
    ellipse(i*samplePeriod, height/4 - samples[i], 3,3);
  }
  
  int b = 10;
  stroke(0, 0, 200, 255);
  for(int i = 0; i < a; i++){
    line(i*b, 5*height/8, i*b, 5*height/8 - samples[i]);
    ellipse(i*b, 5*height/8 - samples[i], 3,3);
  }
  
}

void drawSamples2(float[] samples, float samplePeriod){
  
  int a = samples.length;
  stroke(0, 200, 0, 255);
  for(int i = 0; i < a; i++){
    line(i*samplePeriod, height/4, i*samplePeriod, height/4 - samples[i]);
    ellipse(i*samplePeriod, height/4 - samples[i], 3,3);
  }
  
  int b = 10;
  stroke(0, 200, 0, 255);
  for(int i = 0; i < a; i++){
    line(i*b, 7*height/8, i*b, 7*height/8 - samples[i]);
    ellipse(i*b, 7*height/8 - samples[i], 3,3);
  }
  
}