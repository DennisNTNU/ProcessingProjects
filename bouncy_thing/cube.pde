
class Cube{
  float x;
  float y;
  float vx;
  float vy;
  float ax;
  float ay;
  
  FloatList axList;
  FloatList ayList;
  
  float w;
  float h;
  
  float wf;
  float hf;
  
  Cube(){
    x = width/2;
    y = height/2;
    vx = 0;
    vy = 0;
    ax = 0;
    ay = 0;
    
    w = 30;
    h = 30;
    
    axList = new FloatList();
    ayList = new FloatList();
  }
  
  void update(float dt){
    
    if (axList.size() != 0) {
      ax = axList.remove(0);
    }else{
      ax = 0;
    }
    
    if (ayList.size() != 0) {
      ay = ayList.remove(0);
    }else{
      ay = 0;
    }
    
    //hf = pow(2, -ay/2000);
    hf = pow(2, abs(vy)/500) * pow(2, -abs(vx)/500);
    wf = 1/hf;
    w = wf * 30;
    h = hf * 30;
    
    vx += dt * (ax - 0.5*vx);
    vy += dt * (ay + 500 - 0.5*vy);
    x += dt * vx;
    y += dt * vy;
    
    
    if (x - w/2 < 0) {
      x = w/2;
      vx *= -0.4;
    }
    if (x + w/2 > width) {
      x = width - w/2;
      vx *= -0.4;
    }
    
    if (y - h/2 < 0) {
      y = h/2;
      vy *= -0.4;
    }
    if (y + h/2 > height) {
      y = height - h/2;
      vy *= -0.4;
    }
    
  
  }
  
  void draw(){
    stroke(0);
    fill(0);/*
    float newW = wf * w;
    float newH = hf * h;
    rect(x - newW/2, y - newH/2, newW, newH);*/
    rect(x - w/2, y - h/2, w, h);
  }
  
  void addJump(){
    float f = 0;
    for (float i = 0; i < 8; i += 0.25) {
      f = 3*i*i*pow(2.718281828, -i) - 3.25*i*pow(2.718281828, -i);
      ayList.append(-2000*f);
    }
  }
  
  void moveSideways(char keyy){
    if (keyy == 'a') {
      axList.append(-1000);
    }
    if (keyy == 'd') {
      axList.append(1000);
    }
    
  }
  
}