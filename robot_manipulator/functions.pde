float sat(float in, float max){
  if (in > max){
    return max;
  }
  if(in < -max){
    return -max;
  }
  return in;
}