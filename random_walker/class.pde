class RWalker{
  FloatList x = new FloatList();
  FloatList y = new FloatList();
  int maxSize;
  float pixelPerUnit;
  
  RWalker(int n){
    maxSize = n;
    pixelPerUnit = 5;
    x.append(0);
    y.append(0);
    x.append(random(10) - 5);
    y.append(random(10) - 5);
  }
  
  void randomStep(){
    if (x.size() == maxSize) {
      x.remove(0);
      y.remove(0);
    }
    float X = x.get(x.size()-1);
    float Y = y.get(y.size()-1);
    float d = sqrt(X*X + Y*Y);
    float a = atan2(Y,X);
    float s = 0; float t = 0;
    if(d > 70){
      s = -2 * cos(a);
      t = -2 * sin(a);
    }
    x.append(X + random(-5, 5) + s);
    y.append(Y + random(-5, 5) + t);
    println(s, " ; ", t);
    
    /*
    line(pixelPerUnit * x.get(size-2) + width/2, height/2 - pixelPerUnit * y.get(size-2),
         pixelPerUnit * x.get(size-1) + width/2, height/2 - pixelPerUnit * y.get(size-1) );*/
  }
  
  void draw(){
    int size = x.size() - 1;
    for (int i = 0; i < size; i++) {
      stroke(0, 0, 0, 255 * i/size);
      strokeWeight(1);
      
      line(pixelPerUnit * x.get(i) + width/2, height/2 - pixelPerUnit * y.get(i),
           pixelPerUnit * x.get(i+1) + width/2, height/2 - pixelPerUnit * y.get(i+1) );
    }
  }
  
}