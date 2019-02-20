class Firework {
  PVector pos;
  PVector vel;
  float dir;

  float explodingHeight;

  color col;

  boolean exploded;
  float life;

  ArrayList<Particle> particles;
  int numParticles;

  Firework() {
    pos = new PVector(random(-1300, 1300), random(-1300, 1300), 0);
    vel = new PVector(0, 0, random(110, 180));
    dir = random(0, 2*3.14159265358979);
    exploded = false;

    int farge = (int)random(1000);
    life = 1.0;

    switch(farge % 3) {
    case 0:
      col = color(random(175, 255), random(0, 65), random(0, 65), 235);
      break;
    case 1:
      col = color(random(0, 65), random(175, 255), random(0, 65), 235);
      break;
    case 2:
      //col = color(random(0, 125), random(0, 125), random(175, 255), 235);
      col = color(random(175, 255), random(175, 255), random(0, 65), 235);
      break;
    }




    particles = new ArrayList();
    numParticles = 20;

    explodingHeight = 2000 + random(-255, 255);
  }

  void update(float dt) {
    if (exploded) {
      updateBoom(dt);
    } else {
      updateRise(dt);
    }
  }

  void updateBoom(float dt) {

    life -= 0.006;

    for (int i = 0; i < numParticles; i++) {
      particles.get(i).update(dt, 0.015);
      if (particles.get(i).life < 0.0) {
        particles.remove(i);
        float a1 = random(0, 2*3.1415926);
        float a2 = random(0, 2*3.1415926);
        PVector norm = new PVector(sin(a1)*cos(a2), sin(a1)*sin(a2), cos(a1));

        float velMag = random(20, 60);
        particles.add(new Particle(pos.x + norm.x, pos.y+ norm.y, pos.z + norm.z, velMag*norm.x, velMag*norm.y, velMag*norm.z));
      }
    }
  }

  void updateRise(float dt) {

    vel.add(dt*sin(dir), dt*cos(dir), 0.0);
    pos.add(vel.copy().mult(dt));
    particles.add(new Particle(pos.x, pos.y, pos.z));
    if (particles.size() >= numParticles) {
      particles.remove(0);
    }

    if (pos.z > explodingHeight) {
      exploded = true;

      while (particles.size() > 0) {
        particles.remove(0);
      }

      for (int i = 0; i < numParticles; i++) {
        float a1 = random(0, 2*3.1415926);
        float a2 = random(0, 2*3.1415926);
        PVector norm = new PVector(sin(a1)*cos(a2), sin(a1)*sin(a2), cos(a1));

        particles.add(new Particle(pos.x + norm.x, pos.y+ norm.y, pos.z + norm.z));
        particles.get(i).vel = norm;
        particles.get(i).vel.mult(random(30, 60));

        life = random(0.8, 1.3);
      }
    }
  }

  void show() {
    for (int i = 0; i < particles.size(); i++) {
      if (exploded) {
        particles.get(i).show(col);
      } else {
        particles.get(i).show(color(22,22,22,255));
      }
    }
  }
}