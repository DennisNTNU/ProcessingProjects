float pi = 3.141592653589793238462;

class Leg {
  int links;
  float[] lengths;
  float[] angles;

  PVector end = new PVector();
  PVector root;
  PVector goal;

  float totalLength;
  float totalAngle;


  Leg(int links_, float rootx, float rooty) {
    goal = new PVector(random(width), random(height));
    root = new PVector(rootx, rooty);
    links = links_;
    lengths = new float[links];
    angles = new float[links];
    totalLength = 0;
    totalAngle = 0;

    for (int i = 0; i < links; i++) {
      lengths[i] = 30 + random(60);
      angles[i] = random(-0.3, 0.3);
      totalLength += lengths[i];
    }

    angles[0] = pi/2;
  }

  void update() {

    float goalDist = sqrt((goal.x - root.x)*(goal.x - root.x) + (goal.y - root.y)*(goal.y - root.y));
    float er = sqrt((end.x - root.x)*(end.x - root.x) + (end.y - root.y)*(end.y - root.y)) - goalDist;

    float ea = atan2(end.y - root.y, end.x - root.x) - atan2(goal.y - root.y, goal.x - root.x);
    if (ea > 1.5*pi) {
      ea = (atan2(end.y - root.y, end.x - root.x) - 2*pi) - atan2(goal.y - root.y, goal.x - root.x);
    }
    if (ea < -1.5*pi) {
      ea = (atan2(end.y - root.y, end.x - root.x) + 2*pi) - atan2(goal.y - root.y, goal.x - root.x);
    }

    angles[0] += 0.1*ea;
    for (int i = 1; i < links; i++) {
      if (abs(totalAngle) > 0.1 || goalDist < totalLength) {
        angles[i] -= 0.0002*er*oppositeSign(totalAngle);
        if (abs(angles[i]) > 1.8*pi/links) {
          angles[i] = 1.8*pi/links * sign(angles[i]);
        }
      }
    }
  }

  void updateGoal(float t, float factor, int legnumber) {

    goal.x = 0.2*factor*(totalLength + 2*totalLength*pow(-sin(t) - 0.25*cos(2*t), 2));
    goal.y = 0.4*totalLength*cos(t);
    
    goal.rotate(factor*(0.2+0.3*legnumber));
    
    goal.x += root.x;
    goal.y += root.y;
    
    fixOrientation(factor);
  }

  void show() {
    float prevx = root.x;
    float prevy = root.y;

    float angle = 0;

    for (int i = 0; i < links; i++) {
      strokeWeight(links - i + 1);
      stroke(5 + 75*i/float(links));
      angle += angles[i];
      float dx = lengths[i] * cos(angle);
      float dy = - lengths[i] * sin(angle);
      line(prevx, prevy, prevx + dx, prevy + dy);
      prevx = prevx + dx;
      prevy = prevy + dy;
    }
    end.x = prevx;
    end.y = prevy;
    totalAngle = angle - angles[0];
  }
  
  void fixOrientation(float factor){
    if (factor * totalAngle > 0) {
      invertAngles();
    }
  }

  void invertAngles() {
    for (int i = 0; i < links; i++) {
      angles[i] *= -1;
    }
  }
}


  float sign(float in) {
    if (in >= 0) {
      return 1;
    } else {
      return -1;
    }
  }

  float oppositeSign(float in) {
    if (in >= 0) {
      return -1;
    } else {
      return 1;
    }
  }