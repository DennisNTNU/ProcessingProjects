

boolean[] keys = new boolean[127];
float time = 0;
float oldtime = 0;
float halfsecond = 0;

// Dice
float[] positionDice = {450.0, 150.0, 350.0};
float[] orientation = {1.0, 0.0, 0.0};
float[] orientation2 = {0.0, 1.0, 0.0};
float sideLength = 70.0;
int[][] linesDice = {{0, 6}, {0, 2}, {0, 5}, {7, 5}, {7, 2}, {7, 1}, {4, 6}, {4, 2}, {4, 1}, {3, 6}, {3, 1}, {3, 5}};

//Pyramid
float[] positionPyramid = {0.0, 499.0, 500.0};
//float[] orientation1 = {-1.0, 0.0, 0.0};
//float[] orientation2 = {1.0, 0.0, 0.0};
float toplength = 48; 
float sidelength = 100;
int[][] lines = {{1, 3}, {1, 0}, {1, 4}, {4, 0}, {3, 0}, {2, 4}, {2, 3}, {2, 0}};

float[] initialOrientation = {1.0, 0.0, 0.0};
float[] initialOrientation2 = {0.0, 1.0, 0.0};

float mouseXold = mouseX;
float mouseYold = mouseY;

float[] x = {1.0, 0.0, 0.0};
float[] y = {0.0, 1.0, 0.0};
float[] z = {0.0, 0.0, 1.0};

float fx = 200.0;
float fy = 200.0;
float cx = 0.0;
float cy = 0.0;
float s = 0.0;
float near = 2;
float far = 1000;
float aspect = 1280/720;

float[][] projectionMatrix = {{fx, s, cx}, {0.0, fy, cy}, {0.0, 0.0, 1.0}};
float[][] projectionMatrix2 = {{1/(aspect*tan(fx/2)), 0, 0, 0}, {0.0, 1/tan(fy/2), 0, 0}, {0.0, 0.0, (near+far)/(near-far), 2*near*far/(near-far)}, {0.0, 0.0, -1.0, 0}};
float[] cameraPosition = {500.0, 150.0, 255.0};
float[] cameraViewDirection = {0.0, 1.0, 0.0};
float[] cameraOrientation = {0.0, 0.0, -1.0};
//float[] cameraOrientation2 = crossProduct(cameraViewDirection, cameraOrientation);
float[] cameraOrientation2 = crossProduct(cameraOrientation, cameraViewDirection);
float[][] viewMatrix = {{cameraOrientation2[0], cameraOrientation2[1], cameraOrientation2[2]}, {cameraOrientation[0], cameraOrientation[1], cameraOrientation[2]}, {cameraViewDirection[0], cameraViewDirection[1], cameraViewDirection[2]} };

/*  0 - orthogonal projection
    1 - oblique parallell projection
    
    3 - Perspective projection
*/
int chooseProjection = 3;

float alpha = 3.1415926535 / 3;
float phi = 3.1415926535 / 2;
float speed = 5;  
float[] quaternion = {1, 0, 0, 0};
float[] quaternionDot = {1, 0, 0, 0};
float timestep = 0.02;

float step = 0.01;
float[] gravity = {0, 0, -2.0};

float mass = 1;
float rotorDistance = 1;
float[][] inertiaMatrix = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}}; 
float[] position = {0, 200, 20};
float[] velocity = {0, 0, 0};
float[] q = {1, 0, 0, 0};
float[] omega = {0, 0, 0};


float thrust1 = 0.0;
float thrust2 = 0.0;
float thrust3 = 0.0;
float thrust4 = 0.0;

boolean drawT1 = false;
boolean drawT2 = false;
boolean drawT3 = false;
boolean drawT4 = false;

float[] acceleration(){
  float[] acc = gravity;
  acc = vector3Addition(acc, rotateQ(q, new float[] {0, 0, (thrust1 + thrust2 + thrust3 + thrust4)/mass}));
  return acc;
}

float[] angularAcceleration(){
  float[] acc = {0.0, 0.0, 0.0};
  //float[] inputTorque = {rotorDistance*thrust2 - rotorDistance*thrust4, rotorDistance*thrust3 - rotorDistance*thrust1, thrust1 + thrust3 - thrust2 - thrust4};
  float[] inputTorque = {rotorDistance*thrust2 - rotorDistance*thrust4, rotorDistance*thrust3 - rotorDistance*thrust1, 0};
  //float[] inputTorque = {rotorDistance*thrust2 - rotorDistance*thrust4, rotorDistance*thrust3 - rotorDistance*thrust1, rotorDistance*thrust2 - rotorDistance*thrust4 + rotorDistance*thrust3 - rotorDistance*thrust1};
  acc = matrix3Vector3Product(invertMatrix3(inertiaMatrix), vector3Addition(inputTorque, scalar3Mult(-1, matrix3Vector3Product(matrix3Product(crossProductMatrix(omega), inertiaMatrix), omega))));
  //acc = matrix3Vector3Product(invertMatrix3(inertiaMatrix), vector3Addition(inputTorque, scalar3Mult(-1, matrix3Vector3Product(crossProductMatrix(omega), matrix3Vector3Product(inertiaMatrix, omega)))));
  //acc = matrix3Vector3Product(invertMatrix3(inertiaMatrix), vector3Addition(inputTorque, scalar3Mult(-0.5, omega)));
  return acc;
}

void setup () { 
  size(1680,920);
  background(255);
  println(q[0] + " : " + q[1] + " : " + q[2] + " : " + q[3]);
}

void draw (){
  //fill()
  background(0);
  stroke(200);
  
  oldtime = time;
  time = millis();
  halfsecond += time - oldtime;
  if(halfsecond > 500){/*
    float[] temp = rotateQ(q, new float[] {0, 0, 1});
    temp = normalize3(temp);
    println(q[0] + " : " + q[1] + " : " + q[2] + " : " + q[3]);
    println(temp[0] + " : " + temp[1] + " : " + temp[2]);*/
    println(cameraViewDirection[0] + " : " + cameraViewDirection[1] + " : " + cameraViewDirection[2]);
    halfsecond = 0;
  }
  
  handleKeys();
  
  //------------------------------------------------------------------------------------------
  //quad simulation part
  velocity = vector3Addition(velocity, scalar3Mult(step, acceleration()));
  position = vector3Addition(position, scalar3Mult(step, velocity));
  
  omega = vector3Addition(omega, scalar3Mult(step, angularAcceleration()));
  
  
  q = vector4Addition(q, scalar4Mult(0.5*timestep, quaternionProduct(q, new float[] {0, omega[0], omega[1], omega[2]})));
  q = normalize4(q);
  /*
  q = normalize4(quaternionProduct(q, makeQuaternion(step * length3(omega), normalize3(omega))));*/
  
  //quad simulation part end
  //------------------------------------------------------------------------------------------
  
  
  //method 1: q(k) = q(k-1) + h * q' ; does work
  quaternionDot = quaternionProduct(quaternion, new float[] {0, x[0], x[1], x[2]});
  quaternion = vector4Addition(quaternion, scalar4Mult(0.5*timestep, quaternionDot));
  quaternion = normalize4(quaternion);
  
  /*
  //method 2 (my method): q(k) = 
  quaternionDot = makeQuaternion(timestep * length3(x), normalize3(x));
  quaternion = normalize4(quaternionProduct(quaternion, quaternionDot));*/
  
  
  
  orientation = rotateQ(quaternion, initialOrientation);
  orientation2 = rotateQ(quaternion, initialOrientation2);
  
  printDice(orientation, orientation2, positionDice, sideLength, linesDice);
  printPyramid(orientation, orientation2, positionPyramid, sidelength, lines);
  printCylinder(new float[] {0.0,0.0,0.0});
  printCoordinateSystem();
  printQuadrotor(position, q);
}
 
void printDice(float[] orientation, float[] orientation2, float[] position, float sideLength, int[][] lines){ //position, orientation, sidelength
  float[][] vertices = {{0.0,0.0,0.0},{0.0,0.0,0.0},{0.0,0.0,0.0},{0.0,0.0,0.0},{0.0,0.0,0.0},{0.0,0.0,0.0},{0.0,0.0,0.0},{0.0,0.0,0.0}};
  //float[] helpvector = normalizee(rotatee(0.6154797087, crossProduct(position, orientation), orientation));
  float[] helpvector = normalize3(rotatee(0.9553166181, orientation2, orientation));
  
  vertices[0] = vector3Addition(position, scalar3Mult(sideLength, helpvector));
  vertices[1] = vector3Addition(position, scalar3Mult(-1.0 * sideLength, helpvector));
  
  helpvector = rotatee(1.570796327, orientation, helpvector);
  
  vertices[2] = vector3Addition(position, scalar3Mult(sideLength, helpvector));
  vertices[3] = vector3Addition(position, scalar3Mult(-1.0 * sideLength, helpvector));
  
  helpvector = rotatee(1.570796327, orientation, helpvector);
  
  vertices[4] = vector3Addition(position, scalar3Mult(sideLength, helpvector));
  vertices[5] = vector3Addition(position, scalar3Mult(-1.0 * sideLength, helpvector));
  
  helpvector = rotatee(1.570796327, orientation, helpvector);
  
  vertices[6] = vector3Addition(position, scalar3Mult(sideLength, helpvector));
  vertices[7] = vector3Addition(position, scalar3Mult(-1.0 * sideLength, helpvector));
  
  
  
  
  switch(chooseProjection){
    
  case 0:
      orthoProjection(vertices, 8, lines, 12);
    break;
  case 1:
    for (int i = 0; i < 8; ++i) {
      vertices[i] = matrix3Vector3Product(viewMatrix, vector3Addition(vertices[i], scalar3Mult(-1.0, cameraPosition)));
      vertices[i][0] = vertices[i][0] - vertices[i][2] * cos(phi) / tan(alpha);
      vertices[i][1] = vertices[i][1] - vertices[i][2] * sin(phi) / tan(alpha);
    }
    for (int i = 0; i < 12; ++i) {
      line(width/2 + vertices[lines[i][0]][0], height/2 + vertices[lines[i][0]][1], width/2 + vertices[lines[i][1]][0], height/2 + vertices[lines[i][1]][1]);
    }
    break;
  case 2:
    break;
    
  case 3:
    perspectiveProjection(vertices, 8, lines, 12);
    break;
  case 4:
    break;
  }
} 

void printPyramid(float[] orientation, float[] orientation2, float[] position, float sideLength, int[][] lines){
  float[][] vertices = {{0.0,0.0,0.0},{0.0,0.0,0.0},{0.0,0.0,0.0},{0.0,0.0,0.0},{0.0,0.0,0.0}};
  
  vertices[0] = vector3Addition(position, scalar3Mult(sideLength, orientation));
  vertices[1] = vector3Addition(position, scalar3Mult(sideLength, orientation2));
  vertices[2] = vector3Addition(position, scalar3Mult(-1.0 * sideLength, orientation2));
  
  orientation2 = rotatee(1.570796327, orientation, orientation2);
  
  vertices[3] = vector3Addition(position, scalar3Mult(sideLength, orientation2));
  vertices[4] = vector3Addition(position, scalar3Mult(-1.0 * sideLength, orientation2));
  
  
  switch(chooseProjection){
    
  case 0:
    orthoProjection(vertices, 5, lines, 8);
    break;
  case 1:
    for (int i = 0; i < 5; ++i) {
      vertices[i] = matrix3Vector3Product(viewMatrix, vector3Addition(vertices[i], scalar3Mult(-1.0, cameraPosition)));
      vertices[i][0] = vertices[i][0] - vertices[i][2] * cos(phi) / tan(alpha);
      vertices[i][1] = vertices[i][1] - vertices[i][2] * sin(phi) / tan(alpha);
    }
    for (int i = 0; i < 8; ++i) {
      if (vertices[lines[i][0]][2]>0 && vertices[lines[i][1]][2] > 0) {
        line(width/2 + vertices[lines[i][0]][0], height/2 + vertices[lines[i][0]][1], width/2 + vertices[lines[i][1]][0], height/2 + vertices[lines[i][1]][1]);
      }
    }
    break;
  case 2:
    break;
    
  case 3:
    perspectiveProjection(vertices, 5, lines, 8);
    break;
  case 4:
    break;
  }
}

void printCylinder(float[] position){
  float[][] vertices = {{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},
                        {0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0} };
  int[][] linesCy = {{ 0, 1},{ 1, 2},{ 2, 3},{ 3, 4},{ 4, 5},{ 5, 6},{ 6, 7},{ 7, 8},{ 8, 9},{ 9,10},{10,11},{11,12},{12,13},{13,14},{14,15},{15, 0},
                     {16,17},{17,18},{18,19},{19,20},{20,21},{21,22},{22,23},{23,24},{24,25},{25,26},{26,27},{27,28},{28,29},{29,30},{30,31},{31,16},
                     {16, 1},{17, 2},{18, 3},{19, 4},{20, 5},{21, 6},{22, 7},{23, 8},{24, 9},{25,10},{26,11},{27,12},{28,13},{29,14},{30,15},{31, 0},
                     {16, 0},{17, 1},{18, 2},{19, 3},{20, 4},{21, 5},{22, 6},{23, 7},{24, 8},{25, 9},{26,10},{27,11},{28,12},{29,13},{30,14},{31,15} };
                     
  for (int i = 0; i < 32; i++) {
    vertices[i][0] = 300*sin(2*3.1415926535*i/16);
    vertices[i][1] = 600 + 300*cos(2*3.1415926535*i/16);
    if (i < 16) {
      vertices[i][2] = 0;
    }else{
      vertices[i][2] = 100;
    }
  }
  
  switch(chooseProjection){
  case 0:
    orthoProjection(vertices, 32, linesCy, 64);
    break;
  case 1:
    for (int i = 0; i < 32; i++) {
      vertices[i] = matrix3Vector3Product(viewMatrix, vector3Addition(vertices[i], scalar3Mult(-1.0, cameraPosition)));
      vertices[i][0] = vertices[i][0] - vertices[i][2] * cos(phi) / tan(alpha);
      vertices[i][1] = vertices[i][1] - vertices[i][2] * sin(phi) / tan(alpha);
    }
    for (int i = 0; i < 64; i++) {
      if (vertices[linesCy[i][0]][2] > 0 && vertices[linesCy[i][1]][2] > 0) {
        line(width/2 + vertices[linesCy[i][0]][0], height/2 + vertices[linesCy[i][0]][1], width/2 + vertices[linesCy[i][1]][0], height/2 + vertices[linesCy[i][1]][1]);
      }
    }
    break;
  case 2:
    
    break;
  case 3:
    perspectiveProjection(vertices, 32, linesCy, 64);
    break;
  case 4:
    break;
  }
}

void printCoordinateSystem(){
  float[][] vertices = {{0, 0, 0}, {100, 0, 0}, {0, 100, 0}, {0, 0, 100}, };
  int[][] lines = {{0,1},{0,2},{0,3}};
  float[][] colorBuffer = {{255, 0, 0}, {0, 255, 0}, {0, 0, 255}};
  stroke(255,0,0);
  
  switch(chooseProjection){
  case 0:
    orthoProjection(vertices, 4, lines, 3);
    break;
  case 1:
    for (int i = 0; i < 3; i++) {
      vertices[i] = matrix3Vector3Product(viewMatrix, vector3Addition(vertices[i], scalar3Mult(-1.0, cameraPosition)));
      vertices[i][0] = vertices[i][0] - vertices[i][2] * cos(phi) / tan(alpha);
      vertices[i][1] = vertices[i][1] - vertices[i][2] * sin(phi) / tan(alpha);
    }
    for (int i = 0; i < 3; i++) {
      if (vertices[lines[i][0]][2] > 0 && vertices[lines[i][1]][2] > 0) {
        line(width/2 + vertices[lines[i][0]][0], height/2 + vertices[lines[i][0]][1], width/2 + vertices[lines[i][1]][0], height/2 + vertices[lines[i][1]][1]);
      }
    }
    break;
  case 2:
    
    break;
  case 3:
    //perspectiveProjection(vertices, 4, lines, 3);
    perspectiveProjectionWithColor(vertices, 4, lines, 3, colorBuffer);
    break;
  case 4:
    break;
   }
   stroke(0);
}

void printQuadrotor(float[] position, float[] quatern){
  float[][] vertices = {{0, 0, 0}, {100, 0, 0}, {0, 100, 0}, {-100, 0, 0}, {0, -100, 0}, {0, 0, 50}, {15*omega[0], 15*omega[1], 15*omega[2]}};
  int[][] lines = {{0,1},{0,2},{0,3},{0,4},{0,5},{0,6}};
  float[][] colorBuffer = {{255, 0, 0}, {255, 255, 255}, {255, 255, 255}, {255, 255, 255}, {0, 255, 0}, {0, 255, 255}};
  
  for (int i = 0; i < 7; i++) {
    vertices[i] = rotateQ(quatern, vertices[i]);
    vertices[i] = vector3Addition(position, vertices[i]);
  }
  
  float[][] t1 = {{100, 0, 0}, {100, 0, 20}};
  int[][] t1l = {{0, 1}};
  float[][] t2 = {{0, 100, 0}, {0, 100, 20}};
  int[][] t2l = {{0, 1}};
  float[][] t3 = {{-100, 0, 0}, {-100, 0, 20}};
  int[][] t3l = {{0, 1}};
  float[][] t4 = {{0, -100, 0}, {0, -100, 20}};
  int[][] t4l = {{0, 1}};
  
  t1[0] = rotateQ(quatern, t1[0]); t1[1] = rotateQ(quatern, t1[1]);
  t2[0] = rotateQ(quatern, t2[0]); t2[1] = rotateQ(quatern, t2[1]);
  t3[0] = rotateQ(quatern, t3[0]); t3[1] = rotateQ(quatern, t3[1]);
  t4[0] = rotateQ(quatern, t4[0]); t4[1] = rotateQ(quatern, t4[1]);
  
  t1[0] = vector3Addition(position, t1[0]); t1[1] = vector3Addition(position, t1[1]);
  t2[0] = vector3Addition(position, t2[0]); t2[1] = vector3Addition(position, t2[1]);
  t3[0] = vector3Addition(position, t3[0]); t3[1] = vector3Addition(position, t3[1]);
  t4[0] = vector3Addition(position, t4[0]); t4[1] = vector3Addition(position, t4[1]);
  
  switch(chooseProjection){
  case 0:
    orthoProjection(vertices, 3, lines, 3);
    break;
  case 1:
    for (int i = 0; i < 3; i++) {
      vertices[i] = matrix3Vector3Product(viewMatrix, vector3Addition(vertices[i], scalar3Mult(-1.0, cameraPosition)));
      vertices[i][0] = vertices[i][0] - vertices[i][2] * cos(phi) / tan(alpha);
      vertices[i][1] = vertices[i][1] - vertices[i][2] * sin(phi) / tan(alpha);
    }
    for (int i = 0; i < 3; i++) {
      if (vertices[lines[i][0]][2] > 0 && vertices[lines[i][1]][2] > 0) {
        line(width/2 + vertices[lines[i][0]][0], height/2 + vertices[lines[i][0]][1], width/2 + vertices[lines[i][1]][0], height/2 + vertices[lines[i][1]][1]);
      }
    }
    break;
  case 2:
    
    break;
  case 3:
    //perspectiveProjection(vertices, 6, lines, 3);
    perspectiveProjectionWithColor(vertices, 7, lines, 6, colorBuffer);
    if(drawT1){
      perspectiveProjection(t1, 2, t1l, 1);
    }
    if(drawT2){
      perspectiveProjection(t2, 2, t2l, 1);
    }
    if(drawT3){
      perspectiveProjection(t3, 2, t3l, 1);
    }
    if(drawT4){
      perspectiveProjection(t4, 2, t4l, 1);
    }
    break;
  case 4:
    break;
   }
   stroke(0);
}

void mouseClicked(){
  if (mouseButton == LEFT) {
    orientation = rotatee(0.1963495408 , y, orientation);
    orientation2 = rotatee(0.1963495408 , y, orientation2);
  }else{
    positionDice = rotatee(0.1963495408 , y, positionDice);
    print(positionDice[0]);
    print(" ");
    print(positionDice[1]);
    print(" ");
    println(positionDice[2]);
  }   
}

void mouseMoved(){
  float dx = mouseXold - mouseX;
  float dy = mouseYold - mouseY;
  /*
    orientation = rotatee(0.0163495408*dx, scalarMult(-1.0, y), orientation);
    orientation2 = rotatee(0.0163495408*dx, scalarMult(-1.0, y), orientation2);
  
    orientation = rotatee(0.0163495408*dy, scalarMult(-1.0, x), orientation);
    orientation2 = rotatee(0.0163495408*dy, scalarMult(-1.0, x), orientation2);
    */
    
    cameraViewDirection = rotatee(-0.0163495408*dx, cameraOrientation, cameraViewDirection);
    //cameraOrientation2 = crossProduct(cameraViewDirection, cameraOrientation);
    cameraOrientation2 = crossProduct(cameraOrientation, cameraViewDirection);
    
    cameraViewDirection = rotatee(0.0163495408*dy, cameraOrientation2, cameraViewDirection);
    cameraOrientation = rotatee(0.0163495408*dy, cameraOrientation2, cameraOrientation);
    
    viewMatrix[0][0] = cameraOrientation2[0]; viewMatrix[0][1] = cameraOrientation2[1]; viewMatrix[0][2] = cameraOrientation2[2]; 
    viewMatrix[1][0] = cameraOrientation[0]; viewMatrix[1][1] = cameraOrientation[1]; viewMatrix[1][2] = cameraOrientation[2]; 
    viewMatrix[2][0] = cameraViewDirection[0]; viewMatrix[2][1] = cameraViewDirection[1]; viewMatrix[2][2] = cameraViewDirection[2]; 
    
  mouseXold = mouseX;
  mouseYold = mouseY;
  
}

void keyPressed() {
  //println(int(key));
  if(key < 128){
    keys[key] = true;
  }else{
    println(key);
    println(15*omega[0], 15*omega[1], 15*omega[2]);
  }
}

void keyReleased(){
  if(key < 128){
    keys[key] = false;
  }
}

void handleKeys(){
  if (keys[32]) {
    speed = 25;
  }else{
    speed = 5;
  }
  if (keys[119]) { //w
    cameraPosition = vector3Addition(cameraPosition, scalar3Mult(speed, cameraViewDirection));
  }
  if (keys[115]) { //s
    cameraPosition = vector3Addition(cameraPosition, scalar3Mult(-speed, cameraViewDirection));
  }
  if (keys[97]) { //a
    cameraPosition = vector3Addition(cameraPosition, scalar3Mult(-speed, cameraOrientation2));
  }
  if (keys[100]) { //d
    cameraPosition = vector3Addition(cameraPosition, scalar3Mult(speed, cameraOrientation2));
  }
  
  if (keys[114]) { //r
    cameraPosition = vector3Addition(cameraPosition, scalar3Mult(-speed, cameraOrientation));
  }
  if (keys[102]) { //f
    cameraPosition = vector3Addition(cameraPosition, scalar3Mult(speed, cameraOrientation));
  }
  
  if (keys[113]) { //q
    cameraOrientation = rotatee(0.0163495408, cameraViewDirection, cameraOrientation);
  }
  if (keys[101]) { //e
    cameraOrientation = rotatee(-0.0163495408, cameraViewDirection, cameraOrientation);
  }
  
  if(keys[113] || keys[101]){
    //cameraOrientation2 = crossProduct(cameraViewDirection, cameraOrientation);
    cameraOrientation2 = crossProduct(cameraOrientation, cameraViewDirection);
  
    viewMatrix[0][0] = cameraOrientation2[0]; viewMatrix[0][1] = cameraOrientation2[1]; viewMatrix[0][2] = cameraOrientation2[2]; 
    viewMatrix[1][0] = cameraOrientation[0]; viewMatrix[1][1] = cameraOrientation[1]; viewMatrix[1][2] = cameraOrientation[2]; 
    viewMatrix[2][0] = cameraViewDirection[0]; viewMatrix[2][1] = cameraViewDirection[1]; viewMatrix[2][2] = cameraViewDirection[2];
  }
  
  if (keys[103]) { //g
    thrust1 = 10;
    drawT1 = true;
  }else{
    thrust1 = 0;
    drawT1 = false;
  }
  if (keys[98]) { //b
    thrust3 = 10;
    drawT3 = true;
  }else{
    thrust3 = 0;
    drawT3 = false;
  }
  
  if (keys[104]) { //h
    thrust2 = 10;
    drawT2 = true;
  }else{
    thrust2 = 0;
    drawT2 = false;
  }
  if (keys[110]) { //n
    thrust4 = 10;
    drawT4 = true;
  }else{
    thrust4 = 0;
    drawT4 = false;
  }
}

void orthoProjection(float[][] verts, int vertNumber, int[][] indices, int indexNumber){
  float xmin = -600;
  float ymin = -600;
  //float zmin = -10000;
  float xmax = -xmin;
  float ymax = -ymin;
  float zmax = 2000;
  
  for(int i = 0; i < vertNumber; i++){
    verts[i] = matrix3Vector3Product(viewMatrix, vector3Addition(verts[i], scalar3Mult(-1.0, cameraPosition)));
    //verts[i] = matrixVectorProduct(projectionMatrix, verts[i]);
    verts[i][0] = verts[i][0]/xmax; 
    verts[i][1] = verts[i][1]/ymax;
    verts[i][2] = verts[i][2]/zmax;
  }
  
  for (int i = 0; i < indexNumber; i++) {
    if( //checks if both vertices connected by a line are inside the clip-volume
    ( (verts[indices[i][0]][0] < 1 && verts[indices[i][0]][0] > -1) &&
      (verts[indices[i][0]][1] < 1 && verts[indices[i][0]][1] > -1) &&
      (verts[indices[i][0]][2] < 1 && verts[indices[i][0]][2] > 0)   ) &&
    ( (verts[indices[i][1]][0] < 1 && verts[indices[i][1]][0] > -1) &&
      (verts[indices[i][1]][1] < 1 && verts[indices[i][1]][1] > -1) &&
      (verts[indices[i][1]][2] < 1 && verts[indices[i][1]][2] > 0)   )  ){
      line(width/2 + width/2*verts[indices[i][0]][0], height/2 + height/2*verts[indices[i][0]][1], width/2 + width/2*verts[indices[i][1]][0], height/2 + height/2*verts[indices[i][1]][1]);
      //line(width/2 + verts[indices[i][0]][0] / log(verts[indices[i][0]][2]), height/2 + verts[indices[i][0]][1] / log(verts[indices[i][0]][2]), width/2 + verts[indices[i][1]][0] / log(verts[indices[i][1]][2]), height/2 + verts[indices[i][1]][1] / log(verts[indices[i][1]][2]));
    }
    //line(width/2 + verts[indices[i][0]][0] / log(verts[indices[i][0]][2]), height/2 + verts[indices[i][0]][1] / log(verts[indices[i][0]][2]), width/2 + verts[indices[i][1]][0] / log(verts[indices[i][1]][2]), height/2 + verts[indices[i][1]][1] / log(verts[indices[i][1]][2]));
  }
}

void obliqueParallellProjection(){
  
}

void perspectiveProjection(float[][] verts, int vertNumber, int[][] indices, int indexNumber){
  float xmin = -1.0*float(width)/height;
  float ymin = -1;
  float zNearClip = 1;
  float xmax = -xmin;
  float ymax = -ymin;
  float zFarClip = 6000;
  
  for(int i = 0; i < vertNumber; i++){
    verts[i] = matrix3Vector3Product(viewMatrix, vector3Addition(verts[i], scalar3Mult(-1.0, cameraPosition)));
    if (verts[i][2] > zNearClip && verts[i][2] < zFarClip) {
      verts[i][0] = verts[i][0]/verts[i][2] * zNearClip / xmax;
      verts[i][1] = verts[i][1]/verts[i][2] * zNearClip / ymax;
      verts[i][2] = zNearClip;
    }
  }
  
  for (int i = 0; i < indexNumber; i++) {
    if( //checks if both vertices connected by a line are inside the clip-volume
    ( (verts[indices[i][0]][0] < 1 && verts[indices[i][0]][0] > -1) &&
      (verts[indices[i][0]][1] < 1 && verts[indices[i][0]][1] > -1) &&
      (verts[indices[i][0]][2] == zNearClip )   ) &&
    ( (verts[indices[i][1]][0] < 1 && verts[indices[i][1]][0] > -1) &&
      (verts[indices[i][1]][1] < 1 && verts[indices[i][1]][1] > -1) &&
      (verts[indices[i][1]][2] == zNearClip )   )  ){
      line(width/2 + width/2*verts[indices[i][0]][0], height/2 + height/2*verts[indices[i][0]][1], width/2 + width/2*verts[indices[i][1]][0], height/2 + height/2*verts[indices[i][1]][1]);
    }
    //line(width/2 + verts[indices[i][0]][0] / log(verts[indices[i][0]][2]), height/2 + verts[indices[i][0]][1] / log(verts[indices[i][0]][2]), width/2 + verts[indices[i][1]][0] / log(verts[indices[i][1]][2]), height/2 + verts[indices[i][1]][1] / log(verts[indices[i][1]][2]));
  }
}

void perspectiveProjectionWithColor(float[][] verts, int vertNumber, int[][] indices, int indexNumber, float[][] colorBuffer){
  float xmin = -1.0*float(width)/height;
  float ymin = -1;
  float zNearClip = 1;
  float xmax = -xmin;
  float ymax = -ymin;
  float zFarClip = 2000;
  
  for(int i = 0; i < vertNumber; i++){
    verts[i] = matrix3Vector3Product(viewMatrix, vector3Addition(verts[i], scalar3Mult(-1.0, cameraPosition)));
    if (verts[i][2] > zNearClip && verts[i][2] < zFarClip) {
      verts[i][0] = verts[i][0]/verts[i][2] * zNearClip / xmax;
      verts[i][1] = verts[i][1]/verts[i][2] * zNearClip / ymax;
      verts[i][2] = zNearClip;
    }
  }
  
  for (int i = 0; i < indexNumber; i++) {
    if( //checks if both vertices connected by a line are inside the clip-volume
    ( (verts[indices[i][0]][0] < 1 && verts[indices[i][0]][0] > -1) &&
      (verts[indices[i][0]][1] < 1 && verts[indices[i][0]][1] > -1) &&
      (verts[indices[i][0]][2] == zNearClip )   ) &&
    ( (verts[indices[i][1]][0] < 1 && verts[indices[i][1]][0] > -1) &&
      (verts[indices[i][1]][1] < 1 && verts[indices[i][1]][1] > -1) &&
      (verts[indices[i][1]][2] == zNearClip )   )  ){
      stroke(colorBuffer[i][0], colorBuffer[i][1], colorBuffer[i][2]);
      line(width/2 + width/2*verts[indices[i][0]][0], height/2 + height/2*verts[indices[i][0]][1], width/2 + width/2*verts[indices[i][1]][0], height/2 + height/2*verts[indices[i][1]][1]);
    }
    //line(width/2 + verts[indices[i][0]][0] / log(verts[indices[i][0]][2]), height/2 + verts[indices[i][0]][1] / log(verts[indices[i][0]][2]), width/2 + verts[indices[i][1]][0] / log(verts[indices[i][1]][2]), height/2 + verts[indices[i][1]][1] / log(verts[indices[i][1]][2]));
  }
}