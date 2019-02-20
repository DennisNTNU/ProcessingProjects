

// 27.04.2017 - 18:15 - F3 - Clean Code Course

//TODO: RK4 is damping the motion. calculate total energy of the particles and correct it such that the energy stay constant

ParticleSystem partSys;
float dt = 0.1;
int i = 0;

void setup(){
  size(640, 360);
  partSys = new ParticleSystem(60);
}


void draw(){
  background(51);
  i++;
  if (i % 60 == 0) {
    for(int j = 0; j < partSys.num; j++){
      println(partSys.parts.get(j).F); 
    }
  }
  
  partSys.updateRK4(dt);
  partSys.show();
  
}