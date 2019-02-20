int pixelX = 1620;
int pixelY = 720;

int h, w;
float totalSeconds = 9.9;
float pixelPerSecond = pixelX / totalSeconds;
float ts = 0.05;
int numberSamples = int(totalSeconds / ts);
float[] samples = new float[numberSamples];
float[] filteredSamples = new float[numberSamples];
float[][] dft = new float[numberSamples][2];

boolean magnitudeOnly = true;

void setup(){
  size(1620, 720);
  fill(255);
  h = height;
  w = width;
  //println(height);
  line(0, height/4, width, height/4);
  line(0, 3*height/4, width, 3*height/4);
  
  fill(0);
  
  //sampling the function defined in function()
  for (int i = 0; i < numberSamples; ++i) {
    samples[i] = function(i*ts);
  }
  filtering(samples);
  
  //discrete fourier transform the sampled function and storing it in the float[][] dft
  //dft = dft(samples);
  
  //discrete fourier transform the sampled AND filtered function and storing it in the float[][] dft
  dft = dft(filteredSamples);
  
  
  drawFunction();
  //plot(samples);
  plot(filteredSamples);
  plotDFT(dft);
  
}

void draw(){
  //background(255);
  delay(1000);

}

float function(float t){
  float period = 0.5;
  //return 80 * sin(2 * 3.14159 * t / period) + 80 * cos(2 * 3.14159 * t * 2 / period);
  //return 1.5 * t * t;
  //return 180 * pow(2.71828,-1.01*t) * sin(2 * 3.14159265 * t / period);
  //return 80 * sin(2 * 3.14159 * t / period) * sin(2 * 3.14159 * t / period);
  //return 20*sin(1.1 * 2 * 3.14159 * t / period) + 20*cos(0.555789 * 2 * 3.14159 * t / period) + 20*sin(0.7 * 2 * 3.14159 * t / period) + 20*sin(1.4 * 2 * 3.14159 * t / period) + 5*cos(1.123456789 * 2 * 3.14159 * t / period) + 4*cos(2.123456789 * 2 * 3.14159 * t / period);
  
  return squareWave(t);
  
  /*
  if (t < 1.0) {
    return 20*sin(2*3.1415926*t);
  }else if (t < 4.0) {
    return squareWave(t);
  }else if (t < 7) {
    return pwmWave(t);
  }else{
    return sawtoothWave(t);
  }*/
  //return 10*sqrt(pow( cos(t) - cos(3*t) + cos(5*t) - cos(7*t) + cos(9*t) - cos(11*t) + cos(13*t) - cos(15*t) + cos(17*t) - cos(19*t) + cos(21*t) - cos(23*t) + cos(25*t) - cos(27*t) + cos(29*t) - cos(31*t), 2)   +   pow(-sin(t) + sin(3*t) - sin(5*t) + sin(7*t) - sin(9*t) + sin(11*t) - sin(13*t) + sin(15*t) - sin(17*t) + sin(19*t) - sin(21*t) + sin(23*t) - sin(25*t) + sin(27*t) - sin(29*t) + sin(31*t), 2));
}

float squareWave(float t){
  float amplitude = 50.0;
  float period = 0.5;
  if (t % period < period/2) {
    return amplitude;
  }else{
    return -amplitude;
  }
}

float pwmWave(float t){
  float amplitude = 50.0;
  float period = 0.5;
  float dutyCycle = 0.4;
  //boolean positive = true;
  if (t % period < period*dutyCycle) {
    return amplitude;
  }else{
    return 0.0;
  }
}

float sawtoothWave(float t){
  float amplitude = 50.0;
  float period = 1.0;
  
  return amplitude*((t % period)/period - 0.5)*2;
}

float triangleWave(float t){
  float amplitude = 50.0;
  float period = 1.0;
  return amplitude * ((t % period)/period);
}

void drawFunction(){
  stroke(0);
  for(int j = 1; j < width; j+=2){
    point(j, height/4 - function(j/pixelPerSecond));
    line(j, height/4 - function(j/pixelPerSecond), j+2, height/4 - function((j+2)/pixelPerSecond));
  }
}

float[][] dft(float[] samples){
  float[][] dft = new float[samples.length][2];
  for (int i = 0; i < samples.length; ++i) {
    for (int j = 0; j < samples.length; ++j) {
      dft[i][0] += samples[j]*cos(-2*3.14159*j*i/samples.length);
      dft[i][1] += samples[j]*sin(-2*3.14159*j*i/samples.length);
    }
  }
  return dft;
}

void plot(float[] samples){
  stroke(255, 0, 0, 100);
  fill(255, 0, 0, 100);
  for (int i = 0; i < samples.length; ++i) {
    float x = i * ts * pixelPerSecond;
    if (samples[i] > height/4) {
      line(x, height/4, x, 0);
      ellipse(x, 0, 4, 4);
    }else if (samples[i] < -height/4){
      line(x, height/4, x, height/2);
      ellipse(x, height/2, 4, 4);
    }else{
      line(x, height/4, x, height/4 - samples[i]);
      ellipse(x, height/4 - samples[i], 4, 4);
    }
  }
}

void plotDFT(float[][] dft){
  for (int i = 0; i < dft.length; ++i) {
    float x = (i + 0.5) * ts * pixelPerSecond;
    float magnitude = 10*log(sqrt(dft[i][0] * dft[i][0] + dft[i][1] * dft[i][1]));
    //float magnitude = sqrt(dft[i][0] * dft[i][0] + dft[i][1] * dft[i][1]);
    
    //drawing magnitude
    stroke(255, 0, 0);
    fill(255, 0, 0);
    if ( magnitude > 5*height / 8) {
      line(x, 3*height/4, x, height/8);
      ellipse(x, height/8, 4, 4);
    }else if (magnitude < -height / 4) {
      line(x, 3*height/4, x, height);
      ellipse(x, height, 4, 4);
    }else{
      line(x, 3*height/4, x, 3*height/4 - magnitude);
      ellipse(x, 3*height/4 - magnitude, 4, 4);        
    }
    if (!magnitudeOnly) {
      //drawing real part
      stroke(0, 255, 0, 85);
      fill(0, 255, 0, 85);
      if ( dft[i][0] > 5*height / 8) {
        line(x, 3*height/4, x, height/8);
        ellipse(x, height/8, 4, 4);
      }else if (dft[i][0] < -height / 4) {
        line(x, 3*height/4, x, height);
        ellipse(x, height, 4, 4);
      }else{
        line(x, 3*height/4, x, 3*height/4 - dft[i][0]);
        ellipse(x, 3*height/4 - dft[i][0], 4, 4);        
      }
      
      //drawing imaginary part
      stroke(0, 0, 255, 85);
      fill(0, 0, 255, 85);
      if ( dft[i][1] > 5*height / 8) {
        line(x, 3*height/4, x, height/8);
        ellipse(x, height/8, 4, 4);
      }else if (dft[i][1] < -height / 4) {
        line(x, 3*height/4, x, height);
        ellipse(x, height, 4, 4);
      }else{
        line(x, 3*height/4, x, 3*height/4 - dft[i][1]);
        ellipse(x, 3*height/4 - dft[i][1], 4, 4);        
      }
    }
  }
}

void filtering(float[] samples){
  int startingIndex = 4;
  for (int i = 0; i < startingIndex; i++) {filteredSamples[i] = 0.0;}
  for (int i = startingIndex; i < samples.length; i++ ) {
    filteredSamples[i] = (samples[i] + samples[i-1] + samples[i-2] + samples[i-3] + samples[i-4])/5.0;
  }
}