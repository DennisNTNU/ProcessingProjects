void grid(){
  float x = width / unit;
  
  stroke(0, 150, 200, 255);
  for(int i = 1; i < x; i++){
    line(unit * i, 0, unit*i, height);
  }
  stroke(200, 100, 0, 255);
  for(int i = 1; i < x; i++){
    line(0, unit * i, width, unit*i);
  }
  
}

void grid2(Mat mat){
  float x = width / unit;
  float[] in1 = new float[2];
  float[] in2 = new float[2];
  float[] out1 = new float[2];
  float[] out2 = new float[2];
  
  stroke(0, 140, 250, 155);
  for(int i = int(-x/2); i <= x/2; i++){
    in1[0] = unit * i; 
    in1[1] = -height/2;
    in2[0] = unit * i; 
    in2[1] = height/2;
    out1 = mat.matMult(in1);
    out2 = mat.matMult(in2);
    line(out1[0] + width/2, height/2 - out1[1], out2[0] + width/2, height/2 - out2[1]);
  }
  stroke(250, 140, 0, 155);
  for(int i = int(-x/2); i <= x/2; i++){
    //line(0, unit * i, width, unit*i);
    
    
    in1[0] = -width/2; 
    in1[1] = unit * i;
    in2[0] = width/2; 
    in2[1] = unit * i;
    out1 = mat.matMult(in1);
    out2 = mat.matMult(in2);
    line(out1[0] + width/2, height/2 - out1[1], out2[0] + width/2, height/2 - out2[1]);
  }
  
}