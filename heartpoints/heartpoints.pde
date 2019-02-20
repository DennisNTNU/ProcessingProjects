/*
  x = 16*sin(t)^3
  y = 13*cos(t) - 5*cos(2t) - 2*cos(3t) - cos(4t)
*/


Point[] heart;
int number;

float s;
float t;
float dt = 0.05;

void setup(){
  size(500, 500);
  number = 800;
  heart = new Point[number];
  for (int i = 0; i < number; i++) {
    t = random(2*3.141592653589793238462);
    s = random(1.0) + random(0.5);
    if (s > 1.0) { s = 1.0; }
    //heart[i].init(heartX(t), heartY(t));
    heart[i] = new Point(width / 2 + s * width * heartX(t) / 3, height/2 - s * height * heartY(t) / 3);
  }
}

void draw(){
  background(240,190,190,255);
  
  for (int i = 0; i < number; i++) {
    heart[i].update(dt);
  }
  
  for (int i = 0; i < number; i++) {
    heart[i].draw();
  }
  
}


float heartX(float t){
  return sin(t)*sin(t)*sin(t);
  //return sin(t);
}

float heartY(float t){
  return (13*cos(t) - 5*cos(2*t) - 2*cos(3*t) - cos(4*t))/16;
  //return cos(t);
}