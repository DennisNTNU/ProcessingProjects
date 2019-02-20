

class Particle {
  PVector pos;
  PVector vel;
  PVector F;

  float m;
  float r;
  color col;

  Particle(float _x, float _y, float _r, color _col, float mass) {
    float mag = random(0.2);
    float ang = random(TWO_PI);
    
    pos = new PVector(_x, _y);
    vel = new PVector(mag*sin(ang), mag*cos(ang));
    F = new PVector(0.0, 0.0);
    m = mass;
    r = _r;
    col = _col;
  }

  void setForce(float fx, float fy) {
    F.x = fx;
    F.y = fy;
  }
  
  void setForce(PVector f) {
    F.x = f.x;
    F.y = f.y;
  }

  void update(float dt) {
    vel.add(F.mult(dt/m));
    pos.add(vel.copy().mult(dt));
    
    F.x = 0.0;
    F.y = 0.0;
    
    constrainToScreeen();
  }

  void constrainToScreeen() {
    float rr = r/2;
    if (pos.x < rr) {
      pos.x = 1.05*rr;
      vel.x *= -1;
    }
    if (pos.x > width - rr) {
      pos.x = width - 1.05*rr;
      vel.x *= -1;
    }
    
    
    if (pos.y < rr) {
      pos.y = 1.05*rr;
      vel.y *= -1;
    }
    if (pos.y > height - rr) {
      pos.y = height - 1.05*rr;
      vel.y *= -1;
    }
  }

  void show() {
    stroke(col);
    fill(col);
    ellipse(pos.x, pos.y, r, r);
  }
}