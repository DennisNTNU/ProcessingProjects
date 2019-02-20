class System2 {
  float x1;
  float y1;
  float vx1;
  float vy1;


  float x2;
  float y2;
  float vx2;
  float vy2;

  float dt = 0.4;
  float m1 = 10.0;
  float m2 = 1.0;
  float l1 = 100.0;
  float l2 = 50.0;
  float u;

  float g = 2.0;

  int px = width/8;
  int py = height/2;

  System2(float x1_, float y1_, float x2_, float y2_) {

    x1 = x1_;
    y1 = y1_;
    vx1 = 0.0;
    vy1 = 0.0;

    x2 = x2_;
    y2 = y2_;
    vx2 = 15.0;
    vy2 = -5.0;
    u = 0;
  }

  void update() {


    float pos_x1 = px - x1;
    float pos_y1 = py - y1;

    float distFromPivot = sqrt(pos_x1*pos_x1 + pos_y1*pos_y1);
    float distDev1 = l1 - distFromPivot;

    float v_perp1x = (vx1*pos_x1 + vy1*pos_y1)*pos_x1/(distFromPivot*distFromPivot);
    float v_perp1y = (vx1*pos_x1 + vy1*pos_y1)*pos_y1/(distFromPivot*distFromPivot);
    //vx1 -= v_perp1x;
    //vy1 -= v_perp1y;
    float S1x = -2*pos_x1*distDev1*m1/distFromPivot - 1*v_perp1x;
    float S1y = -2*pos_y1*distDev1*m1/distFromPivot - 1*v_perp1y;


    float pos_x2 = x1 - x2;
    float pos_y2 = y1 - y2;

    float distFromPend1 = sqrt(pos_x2*pos_x2 + pos_y2*pos_y2);
    float distDev2 = l2 - distFromPend1;

    float v_perp2x = (vx2*pos_x2 + vy2*pos_y2)*pos_x2/(distFromPend1*distFromPend1);
    float v_perp2y = (vx2*pos_x2 + vy2*pos_y2)*pos_y2/(distFromPend1*distFromPend1);
    //vx2 -= v_perp2x;
    //vy2 -= v_perp2y;
    float S2x = -2*pos_x2*distDev2/distFromPend1 - 1*v_perp2x;
    float S2y = -2*pos_y2*distDev2/distFromPend1 - 1*v_perp2y;



    float ax1 = (S1x - S2x)/m1; 
    float ay1 = (S1y - S2y + m1*g)/m1;

    float ax2 = (S2x)/m2;
    float ay2 = (S2y + m2*g)/m2;

    vx1 += dt*ax1;
    vy1 += dt*ay1;
    x1 += dt* vx1;
    y1 += dt* vy1;

    vx2 += dt*ax2;
    vy2 += dt*ay2;
    x2 += dt* vx2;
    y2 += dt* vy2;
  }

  void show() {
    line(px, py, x1, y1);
    line(x1, y1, x2, y2);
    float size1 = 2 + sqrt(10*m1);
    float size2 = 2 + sqrt(10*m2);
    ellipse(x1,y1,size1, size1);
    ellipse(x2,y2,size2, size2);
  }
}