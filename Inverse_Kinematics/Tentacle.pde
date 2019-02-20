class Tentacle {
  Segment[] segment;
  PVector base;
  int number = 40;

  Tentacle(float x, float y, int len_) {
    number = len_;
    segment = new Segment[number];
    int segLength = 30;
    segment[0] = new Segment(300, 200, segLength, number);
    for (int i = 1; i < number; i++) {
      segment[i] = new Segment(segment[i-1], segLength, number - i);
    }
    base = new PVector(x, y);
  }

  void update() {

    int total = segment.length;
    Segment end = segment[total-1];

    end.follow(mouseX, mouseY);
    end.update();

    for (int i = total-2; i >=0; i--) {
      segment[i].follow(segment[i+1]);
      segment[i].update();
    }

    segment[0].setA(base);
    for (int i = 1; i < total; i++) {
      segment[i].setA(segment[i-1].b);
    }
  }

  void show() {
    for (int i = number-1; i >=0; i--) {
      segment[i].show();
    }
  }
}