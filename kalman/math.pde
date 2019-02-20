class State{
  float x;
  float y;
  float vx;
  float vy;
  
  State(float _x, float _y, float _vx, float _vy){
    x = _x;
    y = _y;
    vx = _vx;
    vy = _vy;
  }
  State(float _x, float _y){
    x = _x;
    y = _y;
    vx = 0;
    vy = 0;
  }
  State(){
    x = 0;
    y = 0;
    vx = 0;
    vy = 0;
  }
  State(State p){
    x = p.x;
    y = p.y;
    vx = p.vx;
    vy = p.vy;
  }
  void multiply(Matrix4 m){
    x  = x*m.a11 + y*m.a12 + vx*m.a13 + vy*m.a14;
    y  = x*m.a21 + y*m.a22 + vx*m.a23 + vy*m.a24;
    vx = x*m.a31 + y*m.a32 + vx*m.a33 + vy*m.a34;
    vy = x*m.a41 + y*m.a42 + vx*m.a43 + vy*m.a44; 
  }
  void  print(){
    println("____________________________");
    println(x, " ", y, " ", vx, " ", vy);
  }
}

class Matrix4{
  float a11, a12, a13, a14, 
        a21, a22, a23, a24,
        a31, a32, a33, a34,
        a41, a42, a43, a44;
  
  Matrix4(  float _a11, float _a12, float _a13, float _a14,
            float _a21, float _a22, float _a23, float _a24,
            float _a31, float _a32, float _a33, float _a34,
            float _a41, float _a42, float _a43, float _a44 ){
    a11 = _a11;
    a12 = _a12;
    a13 = _a13;
    a14 = _a14;
    
    a21 = _a21;
    a22 = _a22;
    a23 = _a23;
    a24 = _a24;
    
    a31 = _a31;
    a32 = _a32;
    a33 = _a33;
    a34 = _a34;
    
    a41 = _a41;
    a42 = _a42;
    a43 = _a43;
    a44 = _a44;
  }
  Matrix4(Matrix4 m){
    a11 = m.a11;
    a12 = m.a12;
    a13 = m.a13;
    a14 = m.a14;
    
    a21 = m.a21;
    a22 = m.a22;
    a23 = m.a23;
    a24 = m.a24;
    
    a31 = m.a31;
    a32 = m.a32;
    a33 = m.a33;
    a34 = m.a34;
    
    a41 = m.a41;
    a42 = m.a42;
    a43 = m.a43;
    a44 = m.a44;
  }
  Matrix4(float _a11, float _a22, float _a33, float _a44){
    a11 = _a11;
    a12 = 0;
    a13 = 0;
    a14 = 0;
    
    a21 = 0;
    a22 = _a22;
    a23 = 0;
    a24 = 0;
    
    a31 = 0;
    a32 = 0;
    a33 = _a33;
    a34 = 0;
    
    a41 = 0;
    a42 = 0;
    a43 = 0;
    a44 = _a44;
  }
  
  Matrix4(){
    a11 = 1;
    a12 = 0;
    a13 = 0;
    a14 = 0;
    
    a21 = 0;
    a22 = 1;
    a23 = 0;
    a24 = 0;
    
    a31 = 0;
    a32 = 0;
    a33 = 1;
    a34 = 0;
    
    a41 = 0;
    a42 = 0;
    a43 = 0;
    a44 = 1;
  }
  
  void print(){
    println("-----------------------------------------");
    println(a11, " ", a12, " ", a13, " ", a14);
    println(a21, " ", a22, " ", a23, " ", a24);
    println(a31, " ", a32, " ", a33, " ", a34);
    println(a41, " ", a42, " ", a43, " ", a44);
  }
}