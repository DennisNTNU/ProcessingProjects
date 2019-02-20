class Body {
  PVector[] variation = new PVector[15];
  PVector[] variation2 = new PVector[15];
  
  PVector pos;
  float angle;
  float t;

  Body() {
    pos = new PVector(width/2, height/2);
    angle = 0;
    t = 0;
    
    variation[0] = new PVector(0, 0);
    variation2[0] = new PVector(0, 0);
    for (int i = 1; i < 15; i++) {
      variation[i] = new PVector(random(5), random(5));
      variation2[i] = new PVector(random(5), random(5));
    }
  }
  
  void update(){/*
    t += 0.01;
    angle = 0.1 * random(1) + 0.1*sin(t);*/
    
    
  }

  void show() {
    for (int i = 0; i < 10; i++) {
      stroke(5 + 3*i);
      fill(5 + 3*i);
      ellipse(pos.x + variation[i].x, pos.y + variation[i].y, 75*(20-1.5*i)/20 + 33*(20-1.5*i)*sin(angle)/20, 75*(20-1.5*i)/20 + 33*(20-1.5*i)*cos(angle)/20);
      ellipse(pos.x + variation2[i].x + 100*sin(angle), pos.y + variation2[i].y + 100*cos(angle), 108*(20-1.5*i)/20, 108*(20-1.5*i)/20);
    }
  }
  
  
}


class Spinne {
  Leg[] legsR = new Leg[4];
  Leg[] legsL = new Leg[4];

  Body body;

  Spinne() {
    for (int i = 0; i < 4; i++) {
      legsR[i] = new Leg(6, width/2 + 40*sin(2*pi*(i + 1)/10), height/2 + 50*cos(2*pi*(i + 1)/10));
      legsL[i] = new Leg(6, width/2 - 40*sin(2*pi*(i + 1)/10), height/2 + 50*cos(2*pi*(i + 1)/10));
    }

    body = new Body();
  }

  void update() {
    body.update();
    
    for (int i = 0; i < 4; i++) {
      legsL[i].updateGoal(time + 2*pi*pow(-1,i)/4, -1, 4-i);
      legsL[i].update();

      legsR[i].updateGoal(time + 2*pi*pow(-1,i+1)/4, 1, 4-i);
      legsR[i].update();
    }
  }

  void show() {
    body.show();
    stroke(255);
    for (int i = 0; i < 4; i++) {
      legsL[i].show();
      legsR[i].show();
    }
  }
}