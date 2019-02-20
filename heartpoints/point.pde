

class Point{
  float[] pos;
  float[] vel;
  
  float[] desPos;
  
  color col;
  float rad;
  
  Point(float dx, float dy){
    pos = new float[2];
    vel = new float[2];
    
    pos[0] = 0; pos[1] = 0;
    vel[0] = 0; vel[1] = 0;
    
    desPos = new float[2];
    
    desPos[0] = dx; desPos[1] = dy;
    
    float tr = random(127);
    col = color(random(50) + 200, tr, tr, 255);
    
    rad = 2 + random(5);
  }
  
  void init(float dx, float dy){
    pos = new float[2];
    vel = new float[2];
    
    pos[0] = 0; pos[1] = 0;
    vel[0] = 0; vel[1] = 0;
    
    desPos = new float[2];
    
    desPos[0] = dx; desPos[1] = dy;
    
    float tr = random(127);
    col = color(random(50) + 200, tr, tr, 255);
    
    rad = 2 + random(5);
  }
  
  void update(float dt){
    
    float[] force = new float[2];
    float mouseDist = sqrt((pos[0] - mouseX)*(pos[0] - mouseX) + (pos[1] - mouseY)*(pos[1] - mouseY));
    //float mouseDist = (pos[0] - mouseX)*(pos[0] - mouseX) + (pos[1] - mouseY)*(pos[1] - mouseY);
    if (mouseDist < 50) {
      force[0] = 100*(pos[0] - mouseX) / (mouseDist + 0.01);
      force[1] = 100*(pos[1] - mouseY) / (mouseDist + 0.01);
    }else{
      force[0] = 0.0;
      force[1] = 0.0;
    }
    
    vel[0] += dt * ((desPos[0] - pos[0]) - vel[0] + 10*force[0]);
    vel[1] += dt * ((desPos[1] - pos[1]) - vel[1] + 10*force[1]);
    pos[0] += dt * vel[0];
    pos[1] += dt * vel[1];
  }
  
  void draw(){
    stroke(col);
    fill(col);
    ellipse(pos[0], pos[1], rad, rad);
  }
}