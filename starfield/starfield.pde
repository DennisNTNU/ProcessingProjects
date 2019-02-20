ArrayList<Star> stars = new ArrayList();

void setup(){
  //size(800, 600);
  fullScreen();
  background(0);
  smooth(1);
  frameRate(30);
  
  
  int r = 150;
  
  stroke(255,255,255,40);
  noStroke();
  fill(255,255,255,40);
  float max = 20;
  for (int i = 0; i < max; i++) {
    ellipse(100, 100, r*(max - 0.8*i)/max, r*(max - 0.8*i)/max);
  }
  for (int i = 0; i < 150; i++) {
    stars.add(new Star());
  }
}

void draw(){
  
  background(0);
  
  for (int i = 0; i < stars.size(); i++) {
    stars.get(i).draw();
    stars.get(i).update();
    if (stars.get(i).x/stars.get(i).z < -width/2 || stars.get(i).x/stars.get(i).z > width/2 || stars.get(i).y/stars.get(i).z < -height/2 || stars.get(i).y/stars.get(i).z > height/2) {
      stars.remove(i);
      stars.add(new Star());
    }
  }
  
  
  int r = int(100*mouseY/float(height));
  
  //stroke(255,255,255,20*mouseX/float(width));
  noStroke();
  fill(255,255,255,40*mouseX/float(width));
  float max = r/5;
  for (int i = 0; i < max; i++) {
    ellipse(100, 100, r*(max - 0.8*i)/max, r*(max - 0.8*i)/max);
  }
  
  
}