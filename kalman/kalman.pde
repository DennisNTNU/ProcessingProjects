float t = 0;
float dt = 0.1;
int ppu = 40;
float noiseSpread = 10;
//State bias = new State(random(2)-1, random(2)-1, random(2)-1, random(2)-1);
State bias = new State(0, 0, 0, 0);
boolean usefilter = true;

ArrayList<State> xes = new ArrayList<State>();
ArrayList<State> xest = new ArrayList<State>();
ArrayList<State> ys = new ArrayList<State>();
ArrayList<State> ysest = new ArrayList<State>();
int size = 40;

Matrix4 A = new Matrix4(   0,  0,  1,  0,
                           0,  0,  0,  1,
                           0,  0, -2,  0, 
                           0,  0,  0, -2 );

Matrix4 B = new Matrix4(   0,  0,  0,  0,
                           0,  0,  0,  0,
                           0,  0,  1,  0, 
                           0,  0,  0,  1 );

Matrix4 C = new Matrix4(   1,  0,  0,  0,
                           0,  1,  0,  0,
                           0,  0,  1,  0, 
                           0,  0,  0,  1 );

Matrix4 D = new Matrix4(   0,  0,  0,  0,
                           0,  0,  0,  0,
                           0,  0,  0,  0, 
                           0,  0,  0,  0 );
                           
Matrix4 Kf = new Matrix4(0.1,  0,  0,  0,
                           0,0.1,  0,  0,
                           0,  0,0.1,  0, 
                           0,  0,  0,0.1 );
 
Matrix4 S = new Matrix4(add(new Matrix4(), multiply(A, dt)));

State pref = new State();
State u = new State();

void setup(){
  Kf = multiply(Kf, 1.0);
  
  size(1200, 800);
  smooth(1);
  frameRate(30);
  xes.add(new State(5.0, 5.0));
  xest.add(new State(5.0, 5.0));
  ys.add(new State(5.0, 5.0));
  ysest.add(new State(5.0, 5.0));
}

void draw(){
  background(21);
  
  update();
  
  stroke(127);
  //line(0, height/2+0.5, width, height/2);
  //line(width/2+0.5, 0, width/2, height);
  
  stroke(255);
  fill(255);
  for (int i = 0; i < xes.size(); i++) {
    float f = float(i)/xes.size();
    
    //state - white
    stroke(255 * f);
    fill(255 * f);
    ellipse(width/2 + ppu*xes.get(i).x, height/2 - ppu*xes.get(i).y, 5*f, 5*f);
    float k = sqrt(xes.get(i).vx*xes.get(i).vx + xes.get(i).vy*xes.get(i).vy);
    line(width/2 + ppu*xes.get(i).x, height/2 - ppu*xes.get(i).y, width/2 + ppu*xes.get(i).x + 10*xes.get(i).vx/k, height/2 - ppu*xes.get(i).y - 10*xes.get(i).vy/k);
    
    //estimated state - green
    stroke(0, 255*f, 0, 255*f);
    fill(0, 255*f, 0, 255*f);
    ellipse(width/2 + ppu*xest.get(i).x, height/2 - ppu*xest.get(i).y, 5*f, 5*f);
    k = sqrt(xest.get(i).vx*xest.get(i).vx + xest.get(i).vy*xest.get(i).vy);
    line(width/2 + ppu*xest.get(i).x, height/2 - ppu*xest.get(i).y, width/2 + ppu*xest.get(i).x + 10*xest.get(i).vx/k, height/2 - ppu*xest.get(i).y - 10*xest.get(i).vy/k);
    
    //output - red
    stroke(255*f, 0, 0, 255*f);
    fill(255*f, 0, 0, 255*f);
    ellipse(width/2 + ppu*ys.get(i).x, height/2 - ppu*ys.get(i).y, 5*f, 5*f);
    k = sqrt(ys.get(i).vx*ys.get(i).vx + ys.get(i).vy*ys.get(i).vy);
    line(width/2 + ppu*ys.get(i).x, height/2 - ppu*ys.get(i).y, width/2 + ppu*ys.get(i).x + 10*ys.get(i).vx/k, height/2 - ppu*ys.get(i).y - 10*ys.get(i).vy/k);
    
    //estimated output - blue
    stroke(0, 0, 255*f, 255*f);
    fill(0, 0, 255*f, 255*f);
    ellipse(width/2 + ppu*ysest.get(i).x, height/2 - ppu*ysest.get(i).y, 5*f, 5*f);
    k = sqrt(ysest.get(i).vx*ysest.get(i).vx + ysest.get(i).vy*ysest.get(i).vy);
    line(width/2 + ppu*ysest.get(i).x, height/2 - ppu*ysest.get(i).y, width/2 + ppu*ysest.get(i).x + 10*ysest.get(i).vx/k, height/2 - ppu*ysest.get(i).y - 10*ysest.get(i).vy/k);
    
  }
  stroke(255, 255, 0, 255);
  fill(255, 255, 0, 255);
  ellipse(width/2 + ppu*pref.x, height/2 - ppu*pref.y, 5, 5);
  
  //ellipse(width/2 + ppu*x1, height/2 - ppu*x2, 5, 5);
}

void update(){
  State p    = new State(xes.get(xes.size() - 1));
  State pest    = new State(xest.get(xest.size() - 1));
  
  State yold = new State( ys.get( ys.size() - 1));
  State yestold = new State( ysest.get( ysest.size() - 1));
  
  State y    = new State();
  State yest = new State();
  
  pref.x = float(mouseX - width/2) / ppu;
  pref.y = float(height/2 - mouseY) / ppu;
  
  if (usefilter) {
    u.vx = pref.x - yestold.x;
    u.vy = pref.y - yestold.y;
  }
  else{
    u.vx = pref.x - yold.x;
    u.vy = pref.y - yold.y;
  }
  
  p    = add( multiply( S, p    ), multiply( multiply(B, dt), u ));
  pest = add( multiply( S, pest ), multiply( multiply(B, dt), u ));
  pest = add(pest, multiply(Kf, subtract(yold, yestold)));
  //pest.print();
  
  y = add(multiply(C, p), multiply(D, u));
  y.x += random(noiseSpread) - noiseSpread/2 + bias.x;
  y.y += random(noiseSpread) - noiseSpread/2 + bias.y;
  y.vx += random(noiseSpread) - noiseSpread/2 + bias.vx;
  y.vy += random(noiseSpread) - noiseSpread/2 + bias.vy;
  
  yest = add(multiply(C, pest), multiply(D, u));
  
  xes.add(p);
  xest.add(pest);
  ys.add(new State(y));
  ysest.add(new State(yest));
  if (xes.size() >= size) {
    xes.remove(0);
    xest.remove(0);
    ys.remove(0);
    ysest.remove(0);
  }
}