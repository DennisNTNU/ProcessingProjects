
class Star{
  float x, y, z, r;
  int alpha;
  
  
  Star(){
    x = random(1000) - 500;
    y = random(1000) - 500;
    z = random(500)+1;
    r = 1 + random(4);
    alpha = int(105 + random(40));
  }
  
  void draw(){
    noStroke();
    fill(255,255,255,alpha);
    
    //ellipse(width/2 + x/z, height/2 - y/z, r, r);
    stroke(255,255,255,alpha+50/(10*z));
    line(width/2 + x/z, height/2 - y/z, width/2 + x/(1.4*z), height/2 - y/(1.4*z));
    
    /*
    float max = r/4;
    for (int i = 0; i < max; i++) {
      //ellipse(width/2 + x/z, height/2 - y/z, r*(max - 0.8*i)/(max*z), r*(max - 0.8*i)/(max*z));
      ellipse(width/2 + x/z, height/2 - y/z, r*(max - 0.8*i)/max, r*(max - 0.8*i)/max);
    }*/
  }
  
  void update(){
    z *= 0.90;
  }
  
};