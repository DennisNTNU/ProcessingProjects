

class ParticleSystem {
  ArrayList<Particle> parts;
  int num;

  ParticleSystem(int _num) {
    parts = new ArrayList();
    num = _num;

    for (int i = 0; i < num; i++) {
      parts.add(new Particle(random(width), random(height), 20, color(random(255), random(255), random(255), 255), 1.0));
    }
  }


  void update(float dt) {

    for (int i = 0; i < num; i++) {

      parts.get(i).setForce(calcForceOnParticle_i(i));

      parts.get(i).update(dt);
    }
  }

  void updateRK4(float dt) {

    PVector oldpos = new PVector(0.0, 0.0);
    PVector oldvel = new PVector(0.0, 0.0);
    PVector k1 = new PVector(0.0, 0.0);
    PVector k2 = new PVector(0.0, 0.0);
    PVector k3 = new PVector(0.0, 0.0);
    PVector k4 = new PVector(0.0, 0.0);

    for (int i = 0; i < num; i++) {
      oldpos = parts.get(i).pos;
      oldvel = parts.get(i).vel;

      k1 = calcForceOnParticle_i(i);

      parts.get(i).vel.add(k1.copy().mult(dt/(2*parts.get(i).m)));
      parts.get(i).pos.add(parts.get(i).vel.copy().mult(dt/2));

      k2 = calcForceOnParticle_i(i);

      parts.get(i).vel = oldvel.copy().add(k2.copy().mult(dt/(2*parts.get(i).m)));
      parts.get(i).pos = oldpos.copy().add(parts.get(i).vel.copy().mult(dt/2));

      k3 = calcForceOnParticle_i(i);

      parts.get(i).vel = oldvel.copy().add(k3.copy().mult(dt/parts.get(i).m));
      parts.get(i).pos = oldpos.copy().add(parts.get(i).vel.copy().mult(dt));

      k4 = calcForceOnParticle_i(i);

      k1.add(k2.mult(2));
      k1.add(k3.mult(2));
      k1.add(k4);
      k1.mult(1.0/6.0);

      parts.get(i).setForce(k1);
      parts.get(i).vel = oldvel;
      parts.get(i).pos = oldpos;
    }


    for (int i = 0; i < num; i++) {
      parts.get(i).update(dt);
    }
  }

  PVector calcForceOnParticle_i(int i) {
    float fx = 0.0;
    float fy = 0.0;
    PVector relPos;

    for (int j = 0; j < num; j++) {
      if (i != j) {
        relPos = parts.get(i).pos.copy().sub(parts.get(j).pos);
        float dist = relPos.mag();
        dist = pow(dist/30.0, 6);

        dist = 5*(1/(dist*dist) - 1/dist);
        if (dist > 5) {
          dist = 5;
        }

        relPos.normalize();
        fx += relPos.x * dist;
        fy += relPos.y * dist;
      }
    }
    return new PVector(fx, fy);
  }

  void show() {
    for (int i = 0; i < num; i++) {
      parts.get(i).show();
    }
  }
}