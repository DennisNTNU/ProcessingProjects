
void keyPressed(){
  switch(key){
    case 'u':
    case 'U':
      usefilter = !usefilter;
      if (usefilter) {
        println("Using K.F.");
      }else{
        println("not Using K.F.");
      }
    break;
  }
  
}