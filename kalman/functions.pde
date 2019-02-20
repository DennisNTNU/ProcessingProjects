
State add(State s1, State s2){
  return new State( s1.x + s2.x, 
                    s1.y + s2.y, 
                    s1.vx + s2.vx, 
                    s1.vy + s2.vy );
}

State subtract(State s1, State s2){
  return new State( s1.x - s2.x, 
                    s1.y - s2.y, 
                    s1.vx - s2.vx, 
                    s1.vy - s2.vy );
}

State multiply(Matrix4 m, State s){
  float o1 = s.x*m.a11 + s.y*m.a12 + s.vx*m.a13 + s.vy*m.a14;
  float o2 = s.x*m.a21 + s.y*m.a22 + s.vx*m.a23 + s.vy*m.a24;
  float o3 = s.x*m.a31 + s.y*m.a32 + s.vx*m.a33 + s.vy*m.a34;
  float o4 = s.x*m.a41 + s.y*m.a42 + s.vx*m.a43 + s.vy*m.a44;
  return new State(o1, o2, o3, o4);
}

Matrix4 add(Matrix4 m1, Matrix4 m2){
  return new Matrix4( m1.a11+m2.a11, m1.a12+m2.a12, m1.a13+m2.a13, m1.a14+m2.a14, 
                      m1.a21+m2.a21, m1.a22+m2.a22, m1.a23+m2.a23, m1.a24+m2.a24, 
                      m1.a31+m2.a31, m1.a32+m2.a32, m1.a33+m2.a33, m1.a34+m2.a34, 
                      m1.a41+m2.a41, m1.a42+m2.a42, m1.a43+m2.a43, m1.a44+m2.a44 );
}

Matrix4 multiply(Matrix4 m, float f){
  return new Matrix4( m.a11*f, m.a12*f, m.a13*f, m.a14*f, 
                      m.a21*f, m.a22*f, m.a23*f, m.a24*f, 
                      m.a31*f, m.a32*f, m.a33*f, m.a34*f, 
                      m.a41*f, m.a42*f, m.a43*f, m.a44*f );
}