class Mat{
  float a = 0.0;
  float b = 0.0;
  float c = 0.0; 
  float d = 0.0;
  Mat(float _a, float _b, float _c, float _d){
    a = _a;
    b = _b;
    c = _c;
    d = _d;
  }
  
  float det(){
    return a*d - c*b;
  }
  
  void normaliz(){
    float de = this.det();
    a /= de;
    b /= de;
    c /= de;
    d /= de;
  }
  
  void prin(){
    float discr = (a-d)*(a-d) + 4*c*b;
    
    float re1 = 0;
    float im1 = 0;
    float re2 = 0;
    float im2 = 0;
    
    if (discr < 0) {
      re1 = (a+d)/2;
      im1 = sqrt(-discr)/2;
      re2 = (a+d)/2;
      im2 = -sqrt(-discr)/2;
    }else{
      re1 = (a+d + sqrt(discr))/2;
      re2 = (a+d - sqrt(discr))/2;
      im1 = 0;
      im2 = 0;
    }
    
    
    println(a, "  ", b, " Eigenvalue 1:  Re: ", re1, " Im: ", im1);
    println(c, "  ", d, " Eigenvalue 2:  Re: ", re2, " Im: ", im2, "  ;  ", this.det());
  }
  
  float[] matMult(float[] in){
    float[] out = new float[2];
    
    out[0] = a*in[0] + b*in[1];
    out[1] = c*in[0] + d*in[1];
    
    return out;
  }
  
  void multS(float x){
    a *=x;
    b *=x;
    c *=x;
    d *=x;
  }
  
  Mat addMat(Mat x){
    return new Mat(a + x.a, b + x.b, c + x.c, d + x.d);
  }
  
};

Mat lerpMat(Mat x, Mat y, float t){
  //Mat mat = new Mat((1 - t) * x.a + t*y.a, (1 - t) * x.b + t*y.b, (1 - t) * x.c + t*y.c, (1 - t) * x.d + t*y.d);
  //mat.multS(1/mat.det());
  //return mat;
  return new Mat((1 - t) * x.a + t*y.a, (1 - t) * x.b + t*y.b, (1 - t) * x.c + t*y.c, (1 - t) * x.d + t*y.d);
}