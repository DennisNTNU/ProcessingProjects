class Agent{
  PVector pos;
  PVector vel;

  PVector boundingBox;

  Agent() {
    pos = new PVector(50, 50);
    vel = new PVector(2, 2);
    boundingBox = new PVector(20, 20);
  }

  void show() {
    stroke(255);
    fill(255);
    ellipse(pos.x, pos.y, boundingBox.x, boundingBox.y);
  }
  
}