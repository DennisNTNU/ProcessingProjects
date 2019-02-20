
int numSegs = 8;
Segment hand;
Segment root;

void setup() {
  size(1280, 720);
  
  Segment seg = new Segment(200, 300, 100, 0);
  root = seg;
  for (int i = 0; i < numSegs; i++) {
    hand = new Segment(seg, 100, 3.14159265358979*i/8);
    seg = hand;
  }
}

void draw() {
  background(51);
  
  root = hand;
  root.show();
  for (int i = 1; i < numSegs; i++) {
    root = root.parent;
    root.show();
  }
  
}