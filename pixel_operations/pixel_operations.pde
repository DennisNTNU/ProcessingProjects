float t = 0.0;
float dt = 0.02;
int[] pixels1;
int[] pixels2;
boolean which = true;

void setup(){
  size(800, 800);
  pixels1 = new int[height*width];
  pixels2 = new int[height*width];
  background(255);
  stroke(30);
  loadPixels();
  
  for(int y = 0; y < height; y++){
    for(int x = 0; x < width; x++){
      float i = 255*(0.5 * cos((2*3.14159265*(x+y))/80) + 0.5);
      pixels1[y*width + x] = color(i, 0.2*random(255), random(255));
      pixels[y*width + x] = pixels1[y*width + x];
    }
  }
  
  
  updatePixels();
}

void draw(){
  background(255);
  t += dt;
  
  if(which){
    refreshPixels(pixels1, pixels2);
  }else{
    refreshPixels(pixels2, pixels1);
  }
  which = !which;
  
  delay(50);
}


void refreshPixels(int[] from, int[] to){
  
  //int a = 0, r = 0, b = 0, g = 0;
  
  for(int y = 0; y < height; y++){
    for(int x = 0; x < width; x++){
      
      to[y*width + x] = (getColor(from, x-1, y) + getColor(from, x+1, y) + getColor(from, x, y-1) + getColor(from, x, y+1))/4;
      pixels[y*width + x] = to[y*width + x];
      
    }
  }
  
  updatePixels();
}

int mask(int[] a, int x, int y){
  float[][] mask = {{1, 1, 1},{1, 1, 1},{1, 1, 1}};
  float factor = 9;
  
  
  
  return 0;
}

int getColor(int[] a, int x, int y){
  if(y >= height){
    y = height-1;
  }
  if(y < 0){
    y = 0;
  }
  if(x >= width){
    x = width-1;
  }
  if(x < 0){
    x = 0;
  }
  return a[y*width + x];
}