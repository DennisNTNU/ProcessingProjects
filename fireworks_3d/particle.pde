class Particle {
  PVector pos;
  PVector vel;
  float life;

  Particle(float x, float y, float z) {
    pos = new PVector(x, y, z);
    vel = new PVector(0, 0, 0);
    life = 1.0;
  }

  Particle(float x, float y, float z, float vx, float vy, float vz) {
    pos = new PVector(x, y, z);
    vel = new PVector(vx, vy, vz);
    life = 1.0;
  }

  void update(float dt, float dec) {
    pos.add(vel.copy().mult(dt));
    vel.mult(0.97);
    vel.z -= dt*10.8;
    life -= dec;
  }

  void show(color col_) {
    float a = 255;
    if (life <= 0.4) {
      a = 255*life / 0.4;
    }
    stroke(col_, a);
    fill(col_, a);

    float l = 8;

    noLights();
    beginShape();
    vertex(pos.x - l, pos.y - l, pos.z);
    vertex(pos.x - l, pos.y + l, pos.z);
    vertex(pos.x + l, pos.y + l, pos.z);
    vertex(pos.x + l, pos.y - l, pos.z);
    endShape();

    beginShape();    
    vertex(pos.x, pos.y - l, pos.z - l);
    vertex(pos.x, pos.y + l, pos.z - l);
    vertex(pos.x, pos.y + l, pos.z + l);
    vertex(pos.x, pos.y - l, pos.z + l);
    endShape();

    beginShape();    
    vertex(pos.x - l, pos.y, pos.z - l);
    vertex(pos.x + l, pos.y, pos.z - l);
    vertex(pos.x + l, pos.y, pos.z + l);
    vertex(pos.x - l, pos.y, pos.z + l);
    endShape();

    lights();
    /*
    pushMatrix();
     translate(0, 0, pos.z);
     ellipse(pos.x, pos.y, 20, 20);
     popMatrix();*/
  }
}