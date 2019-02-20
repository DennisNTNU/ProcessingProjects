
float t = 0;
float dt = 0.01;


int maxSamples = 150;
float s0 = 0;
float s1 = 2 * 3.141592653589793238462;
float ds = (s1 - s0) / maxSamples;

color sky1 = color(255, 85, 20, 255);
color sky2 = color(105, 25, 20, 255);
color ground1 = color(75, 35, 30, 255);
color star = color(205, 205, 180, 255);

Sun sun;
Stars stars;

void setup(){
  size(768, 576);
  sun = new Sun();
  stars = new Stars(40 + int(random(20)));
}

void draw(){
  t += dt;
  
  float hF = map(sun.posy, height/2, height, 1, 0);
  float hF2 = map(hF, 0.5, 0, 0, 1); if (hF2 < 0) { hF2 = 0; } if (hF2 > 1) { hF2 = 1; }
  
  ground1 = color(75*hF, 35*hF, 30*hF, 255);
  sky1 = color(255*hF, 85*hF, 20*hF, 255);
  sky2 = color(105*hF, 25*hF, 20*hF, 255);
  
  star = color(205, 205, 180, 255*hF2 + 1);
  
  //sky1 = rgbFromTemp(map(hF, 1, 0, 8000, 500));
  //sky2 = rgbFromTemp(map(hF, 1, 0, 8000, 500));
  
  
  setGradient(0, 0, width, height, sky1, sky2, 1);
  stroke(star);
  stars.draw();
  sun.draw();
  //sun.posy = 3*height/4 - cos(t)*0.4*height;
  sun.posx = mouseX;
  sun.posy = mouseY;
  fill(ground1);
  stroke(ground1);
  drawHorizon();
  
  delay(20);
}

void drawHorizon(){
  rect(0, 2 * height / 3, width, height / 3);
  setGradient(0, 2 * height / 3 - 14, width, 14, color(55, 25, 20, 0), ground1, 1);
  fill(0);
  house(300, 450, 60, 150, 30, sun.posx, sun.posy, sun.r);
  fill(0);
  stroke(0);
  house(500, 550, 60, 120, 60, sun.posx, sun.posy, sun.r);
  fill(0);
  stroke(0);
  house(200, 550, 120, 50, 20, sun.posx, sun.posy, sun.r);
}