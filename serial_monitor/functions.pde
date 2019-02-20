

float[] matrixVectorProduct(float[][] m, float[] v){
  float[] r = {m[0][0]*v[0] + m[0][1] * v[1] + m[0][2] * v[2], m[1][0]*v[0] + m[1][1] * v[1] + m[1][2] * v[2], m[2][0]*v[0] + m[2][1] * v[1] + m[2][2] * v[2]};
  return r;
}

float lengthh(float[] vector){
  return sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
}

float[] normalizee(float[] vector){
  float lengthh = lengthh(vector);
  float[] r = {0.0, 0.0, 0.0};
  if (lengthh < 0.000001 && lengthh > -0.000001) {
    r[0] = 0.0;
    r[1] = 0.0;
    r[2] = 0.0;
  }else{
    r[0] = vector[0] / lengthh;
    r[1] = vector[1] / lengthh;
    r[2] = vector[2] / lengthh;
  }
  return r;
}

float[][] makeRotationMatrix(float angle, float[] directionVectorIn){
  float[] directionVector = normalizee(directionVectorIn);
  float[][] rotationMatrix = {{0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}};
  rotationMatrix[0][0] = pow(cos(angle/2),2) + pow(sin(angle/2),2) * (pow(directionVector[0], 2) - pow(directionVector[1], 2) - pow(directionVector[2], 2));
  rotationMatrix[1][1] = pow(cos(angle/2),2) + pow(sin(angle/2),2) * (-pow(directionVector[0], 2) + pow(directionVector[1], 2) - pow(directionVector[2], 2));
  rotationMatrix[2][2] = pow(cos(angle/2),2) + pow(sin(angle/2),2) * (-pow(directionVector[0], 2) - pow(directionVector[1], 2) + pow(directionVector[2], 2));
  
  rotationMatrix[0][1] = 2 * directionVector[0] * directionVector[1] * pow(sin(angle/2), 2) - 2 * directionVector[2] * cos(angle/2) * sin(angle/2);
  rotationMatrix[0][2] = 2 * directionVector[0] * directionVector[2] * pow(sin(angle/2), 2) + 2 * directionVector[1] * cos(angle/2) * sin(angle/2);
  rotationMatrix[1][2] = 2 * directionVector[1] * directionVector[2] * pow(sin(angle/2), 2) - 2 * directionVector[0] * cos(angle/2) * sin(angle/2);
  
  rotationMatrix[1][0] = 2 * directionVector[0] * directionVector[1] * pow(sin(angle/2), 2) + 2 * directionVector[2] * cos(angle/2) * sin(angle/2);
  rotationMatrix[2][0] = 2 * directionVector[0] * directionVector[2] * pow(sin(angle/2), 2) - 2 * directionVector[1] * cos(angle/2) * sin(angle/2);
  rotationMatrix[2][1] = 2 * directionVector[1] * directionVector[2] * pow(sin(angle/2), 2) + 2 * directionVector[0] * cos(angle/2) * sin(angle/2);

  return rotationMatrix;
}

float[] rotatee(float angle, float[] rotateAround, float[] vector){
  float[] returnVector = matrixVectorProduct(makeRotationMatrix(angle, rotateAround), vector);
  return returnVector;
}


float[] makeQuaternion(float angle, float[] axis){
  float[] vector = normalizee(axis);
  if (vector[0] == 0.0 && vector[1] == 0.0 && vector[2] == 0.0) {
    angle = 0.0;
  }
  float[] q = {cos(angle/2), vector[0] * sin(angle/2), vector[1] * sin(angle/2), vector[2] * sin(angle/2)};
  return q;
}

float[] scaleQuaternion(float a, float[] q){
  float[] returnQ = {a * q[0], a * q[1], a * q[2], a * q[3]};
  return returnQ;
}

float[] quaternionProduct(float[] q1, float[] q2){
  float[] returnQ = {0.0, 0.0, 0.0, 0.0};
  returnQ[0] = q1[0] * q2[0] - q1[1] * q2[1] - q1[2] * q2[2] - q1[3] * q2[3]; 
  returnQ[1] = q1[0] * q2[1] + q1[1] * q2[0] + q1[2] * q2[3] - q1[3] * q2[2];
  returnQ[2] = q1[0] * q2[2] + q1[2] * q2[0] + q1[3] * q2[1] - q1[1] * q2[3];
  returnQ[3] = q1[0] * q2[3] + q1[3] * q2[0] + q1[1] * q2[2] - q1[2] * q2[1];
  return returnQ;
}

float[] invertQuaternion(float[] q){
  float[] qr = {0.0, 0.0, 0.0, 0.0};
  qr[0] =  q[0];
  qr[1] = -q[1];
  qr[2] = -q[2];
  qr[3] = -q[3];
  return qr;
}

float[] rotateQ(float[] quaternion, float[] vector){
  float[] augmented = {0.0, vector[0], vector[1], vector[2]};
  augmented = quaternionProduct(quaternion, augmented);
  augmented = quaternionProduct(augmented, invertQuaternion(quaternion));
  float[] deAugmented = {augmented[1], augmented[2], augmented[3]};
  return deAugmented;
}

float[] quaternionDerivative(float[] q, float[] omega){
  float[] qDot = {0.0, 0.0, 0.0, 0.0};
  qDot[0] = 0.5 * (-q[1] * omega[0] - q[2] * omega[1] - q[3] * omega[2]);
  qDot[1] = 0.5 * ( q[0] * omega[0] + q[3] * omega[1] - q[2] * omega[2]);
  qDot[2] = 0.5 * (-q[3] * omega[0] + q[0] * omega[1] + q[1] * omega[2]); 
  qDot[3] = 0.5 * ( q[2] * omega[0] - q[1] * omega[1] + q[0] * omega[2]);
  return qDot;
}

float qNorm(float[] q){
  float a = 0.0;
  a = sqrt(q[0] * q[0] + q[1] * q[1] + q[2] * q[2] + q[3] * q[3]); 
  return a;
}