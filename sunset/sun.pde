class Sun{
  float posx;
  float posy;
  float r;
  
  color sun1 = color(240, 205, 0, 255);
  color sun2 = color(240, 165, 0, 205);
  color sun3 = color(240, 105, 0, 105);
  color sun4 = color(190, 55, 0, 55);
  
  Sun(){
    posx = width/2;
    posy = height/3;
    r = 70;
  }
  
  void draw(){
    fill(sun4);
    stroke(sun4);
    drawSun(r + 2*r/9);
    fill(sun3);
    stroke(sun3);
    drawSun(r + r/9);
    fill(sun2);
    stroke(sun2);
    drawSun(r + r/18);
    fill(sun1);
    stroke(sun1);
    drawSun(r);
  }
  
  
  void drawSun(float r){
    beginShape();
    for (int i = 0; i < maxSamples; i++) {
      float x = r * cos(s0 + ds * i);
      float y = r * sin(s0 + ds * i);
      vertex(posx + x + leftOrRightSide(x) * 6 * sin(0.3*y - 35*t), posy + y);
    }
    endShape(CLOSE);
  }
  
}

float leftOrRightSide(float x){
  if (x < 0) {
    //leftSide
    return -1.0;
  }else{
    //rightSide
    return 1.0;
  }
}