class System {

  float p1;
  float p2;

  float w1;
  float w2;

  float a1;
  float a2;

  float dt = 0.05;
  float m1 = 1.0;
  float m2 = 1.0;
  float l1 = 1.0;
  float l2 = 1.0;
  float u;

  float g = 1.0;

  System(float a1_0, float w1_0, float a2_0, float w2_0) {

    p1 = a1_0;
    w1 = w1_0;
    p2 = a2_0;
    w2 = w2_0;
    u = 0;
  }

  void update() {
    u = -0.5*w1;

    w1 += dt*f1();// - dt*0.2*w1;
    w2 += dt*f2();// - dt*0.2*w2;
    p1 += dt*w1;
    p2 += dt*w2;
  }

  void updateRK4() {

    float p1n = p1;
    float p2n = p2;
    float w1n = w1;
    float w2n = w2;

    float k11 = f1();
    float k12 = f2();

    w1 = w1n + dt*k11/2.0;
    w2 = w2n + dt*k12/2.0;
    p1 = p1n + dt*w1/2.0;
    p2 = p2n + dt*w2/2.0;

    float k21 = f1();
    float k22 = f2();

    w1 = w1n + dt*k21/2.0;
    w2 = w2n + dt*k22/2.0;
    p1 = p1n + dt*w1/2.0;
    p2 = p2n + dt*w2/2.0;

    float k31 = f1();
    float k32 = f2();

    w1 = w1n + dt*k31;
    w2 = w2n + dt*k32;
    p1 = p1n + dt*w1;
    p2 = p2n + dt*w2;

    float k41 = f1();
    float k42 = f2();

    w1 = w1n + dt*(k11 + 2.0*k21 + 2.0*k31 + k41)/6;
    w2 = w2n + dt*(k12 + 2.0*k22 + 2.0*k32 + k42)/6;
    p1 = p1n + dt*w1;
    p2 = p2n + dt*w2;
  }

  void show() {
    float pixper = 150;

    int x1 = int(width / 2 + pixper*l1*sin(p1));
    int y1 = int(height / 2 + pixper*l1*cos(p1));

    line(width / 2, height / 2, x1, y1);
    int x2 = int(x1 + pixper*l2*sin(p1+p2));
    int y2 = int(y1 + pixper*l2*cos(p1+p2));
    line(x1, y1, x2, y2);

    ellipse(x2, y2, 15, 15);
    ellipse(x1, y1, 15, 15);
  }

  float f1() {
    float a = (m1+m2)*l1*l1 + m2*l2*l2 + 2.0*m2*l1*l2*cos(p2);
    float b = m2*l2*l2 + m2*l1*l2*cos(p2);
    float c = m2*l2*l2;

    float d1 = m2*l1*l2*w2*(2.0*w1+w2)*sin(p2)  -  (m1+m2)*g*l1*sin(p1) - m2*g*l2*sin(p1+p2);
    float d2 = -m2*l1*l2*w2*w1*sin(p2) - m2*g*l2*sin(p1+p2);
    float d = m2*l1*l1*l2*l2*(m1 + m2*sin(p2)*sin(p2));

    return (d1*c - d2*b)/d;
    //return (m2*m2*l1*l2*l2*l2*w2*(w1+w2)*sin(p2) + m2*g*l2*l2*(m2*l2*sin(p2) - (m1+m2)*l1*sin(p1)) + m2*m2*l1*l2*l2*(g - l1*w1*w2)*sin(p2)*cos(p2) + m2*l2*l2*u)/(m2*l1*l1*l2*l2*(m1 + m2*sin(p2)*sin(p2)));
  }
  float f2() {


    float a = (m1+m2)*l1*l1 + m2*l2*l2 + 2.0*m2*l1*l2*cos(p2);
    float b = m2*l2*l2 + m2*l1*l2*cos(p2);
    float c = m2*l2*l2;

    float d1 = m2*l1*l2*w2*(2.0*w1+w2)*sin(p2)  -  (m1+m2)*g*l1*sin(p1) - m2*g*l2*sin(p1+p2);
    float d2 = -m2*l1*l2*w2*w1*sin(p2) - m2*g*l2*sin(p1+p2);
    float d = m2*l1*l1*l2*l2*(m1 + m2*sin(p2)*sin(p2));

    return (d2*a - d1*b)/d;

    //return (m2*l1*l2*l2*l2*w2*(m1*w1-m2*w2)*sin(p2) - m2*m2*l1*l1*l2*l2*w2*w2*sin(p2)*cos(p2) - u*m2*l2*(l2+l1*cos(p2)) + (m1+m2)*m2*g*l1*l2*(l2 + l1*cos(p1))*sin(p1) -m2*l2*g*((m1+m2)*l2*l2 + m2*l2*l2 + 2.0*m2*l1*l2*cos(p2))*sin(p2))/(m2*l1*l1*l2*l2*(m1 + m2*sin(p2)*sin(p2)));
  }
}