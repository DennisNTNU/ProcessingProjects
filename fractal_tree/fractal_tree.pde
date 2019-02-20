float fac = 4.0;
float t = 0.0;

int frame = 0;

void setup() {
  
  size(1600, 900);

  background(51);
  stroke(251);

  background(0, 0, 51, 255);
  stroke(0, 0, 251, 255);
  fill(0, 0, 251, 2511);

  drawLines(12, 0.0, 180.0);
  drawLines(12, PI, 180.0);
}

void draw() {
  background(0, 0, 51, 255);
  //fac = 2.0 + 4.0 * (mouseY - height/2) / (height/2);

  println(fac);

  fac = 3.0 + cos(t);
  t += TWO_PI / 600.0;
  frame++;

  drawLines(12, 0.0, 180.0);
  drawLines(12, PI, 180.0);
  if (frame <= 600) {
    //saveFrame("frames/screen-####.tif");
  }
}
