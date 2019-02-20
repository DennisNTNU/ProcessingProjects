
void house(float x, float y, float w, float h, float d, float sunx, float suny, float sunRad){
  
  /*
  float[] bl = {x - w/2, y};
  float[] br = {x + w/2, y};
  float[] tl = {x - w/2, y - h};
  float[] tr = {x + w/2, y - h};*/
  
  
  float[] blray = {width/2 - x + w/2, height/2 - y};
  float[] brray = {width/2 - x - w/2, height/2 - y};
  float[] tlray = {width/2 - x + w/2, height/2 - y + h};
  float[] trray = {width/2 - x - w/2, height/2 - y + h};
  
  blray = scaleTo(blray, d);
  brray = scaleTo(blray, d);
  tlray = scaleTo(blray, d);
  trray = scaleTo(blray, d);
  
  
  //
  
  beginShape();
  if (x > width/2) {
    vertex(x - w/2, y);
    vertex(x - w/2 + blray[0], y + blray[1]);
    vertex(x - w/2 + tlray[0], y - h + tlray[1]);
    vertex(x + w/2 + trray[0], y - h + trray[1]);
    vertex(x + w/2, y - h);
    vertex(x + w/2, y);
  }else{
    vertex(x - w/2, y);
    vertex(x - w/2, y - h);
    vertex(x - w/2 + tlray[0], y - h + tlray[1]);
    vertex(x + w/2 + trray[0], y - h + trray[1]);
    vertex(x + w/2 + brray[0], y + brray[1]);
    vertex(x + w/2, y);
  }
  endShape(CLOSE);
  
  //float[] leftShadowVector = {sunx - sunRad - x + w/2, suny - y};
  //float[] rightShadowVector = {sunx - sunRad - x - w/2, suny - y};
  float[] leftShadowVector = {sunx - sunRad - x + w/2, suny - y};
  float[] rightShadowVector = {sunx + sunRad - x - w/2, suny - y};
  
  leftShadowVector = scaleTo(leftShadowVector, -1);
  rightShadowVector = scaleTo(rightShadowVector, -1);
  
  float t = w*rightShadowVector[1]/(rightShadowVector[1]*leftShadowVector[0] - leftShadowVector[1]*rightShadowVector[0]);
  
  stroke(0, 0, 0, 55);
  fill(0, 0, 0, 55);
  
  beginShape();
  vertex(x + w/2, y);
  vertex(x - w/2, y);
  vertex(x - w/2 + t*leftShadowVector[0], y + t*leftShadowVector[1]);
  endShape(CLOSE);
  
  
  stroke(200, 200, 0, 255);
  fill(200, 200, 0, 255);
  
  float wh = int(h/20);
  float ww = int(w/20);
  
  for (int i = 1; i <= wh; i++) {
    for (int j = 1; j <= ww; j++) {
      rect(x - w/2 + j * 20 - 13, y - h + i * 20 - 13, 6, 6);
    }
  }
   
}

float[] scaleTo(float[] v, float s){
  float d = sqrt(v[0]*v[0] + v[1]*v[1]);
  float[] r = {s*v[0]/d, s*v[1]/d}; 
  return r;
}