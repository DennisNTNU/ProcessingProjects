
void mousePressed(){
  float[] a = {mouseX, mouseY};
  kk.add(a);
  if (kk.size() >= 40) {
    kk.remove(0);
  }
  dt = 1.0/(kk.size()*sqrt(kk.size()));
  println(dt);
}

void keyPressed(){
  switch (key) {
    case '1':
    for (int i = 0; i < 40; i++) {
      if (kk.size() >= 40) {
        kk.remove(0);
      }
      float[] a = {random(width - 10) + 5, random(height - 10) + 5};
      kk.add(a);
    }
    dt = 1.0/(kk.size()*sqrt(kk.size()));
    break;
  }
  
}