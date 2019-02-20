


void setup(){
  int size = 200;
  float prob1 = 0.1;
  float prob2 = 0.9;
  
  boolean[] state = new boolean[size];
  state[0] = false;
  float sample = random(1.0);
  
  for(int i = 1; i < size; i++){
    sample = random(1.0);
    if(state[i-1]){
      if(sample > prob1){
        state[i] = true;
      }else{
        state[i] = false;
      }
    }else{
      if(sample > prob2){
        state[i] = true;
      }else{
        state[i] = false;
      }
    }
    print(int(state[i]));
  }
  
  
}

void draw(){
  
  
}