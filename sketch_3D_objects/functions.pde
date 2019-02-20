
float[] vector3Addition(float[] v1, float[] v2){
  float[] r = {v1[0] + v2[0], v1[1] + v2[1], v1[2] + v2[2]};
  return r;
}

float[] vector4Addition(float[] v1, float[] v2){
  float[] r = {v1[0] + v2[0], v1[1] + v2[1], v1[2] + v2[2], v1[3] + v2[3]};
  return r;
}

float length3(float[] vector){
  float l = sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2]);
  if (l == 0.0) { 
    return 1.0;
  }else{
    return l;
  }
}

float length4(float[] vector){
  return sqrt(vector[0] * vector[0] + vector[1] * vector[1] + vector[2] * vector[2] + vector[3] * vector[3]);
}

float[] normalize3(float[] vector){
  float lengthh = length3(vector);
  if (lengthh == 0.0) {
    float[] out = {0.0, 0.0, 0.0};
    return out;
  }else{
    float[] out = {vector[0] / lengthh, vector[1] / lengthh, vector[2] / lengthh};
    return out;
  }
}

float[] normalize4(float[] vector){
  float lengthh = length4(vector);
  if (lengthh == 0.0) {
    float[] out = {0.0, 0.0, 0.0, 0.0};
    return out;
  }else{
    float[] out = {vector[0] / lengthh, vector[1] / lengthh, vector[2] / lengthh, vector[3] / lengthh};
    return out;
  }
}


float[] crossProduct(float[] v1, float[] v2){
  float[] returnV = {v1[1]*v2[2] - v1[2]*v2[1], v1[2]*v2[0] - v1[0]*v2[2], v1[0]*v2[1] - v1[1]*v2[0]};
  return returnV;
}

float scalar3Product(float[] v1, float[] v2){
  return v1[0]*v2[0] + v1[1]*v2[1] + v1[2]*v2[2];
}

float scalar4Product(float[] v1, float[] v2){
  return v1[0]*v2[0] + v1[1]*v2[1] + v1[2]*v2[2] + v1[3]*v2[3];
}

float[] scalar3Mult(float a, float[] v){
  float[] r = {a*v[0], a*v[1], a*v[2]};
  return r;
}

float[] scalar4Mult(float a, float[] v){
  float[] r = {a*v[0], a*v[1], a*v[2], a*v[3]};
  return r;
}

float[] matrix3Vector3Product(float[][] m, float[] v){
  float[] r = {m[0][0]*v[0] + m[0][1] * v[1] + m[0][2] * v[2], m[1][0]*v[0] + m[1][1] * v[1] + m[1][2] * v[2], m[2][0]*v[0] + m[2][1] * v[1] + m[2][2] * v[2]};
  return r;
}

float[] matrix4Vector3Product(float[][] m, float[] v){
  float s = m[3][0]*v[0] + m[3][1] * v[1] + m[3][2] * v[2] + m[3][3];
  float[] r = { (m[0][0]*v[0] + m[0][1] * v[1] + m[0][2] * v[2] + m[0][3])/s,
                (m[1][0]*v[0] + m[1][1] * v[1] + m[1][2] * v[2] + m[1][3])/s,
                (m[2][0]*v[0] + m[2][1] * v[1] + m[2][2] * v[2] + m[2][3])/s };
  return r;
}

float[] matrix4Vector4Product(float[][] m, float[] v){
  float[] r = { (m[0][0] * v[0] + m[0][1] * v[1] + m[0][2] * v[2] + m[0][3] * v[3]),
                (m[1][0] * v[0] + m[1][1] * v[1] + m[1][2] * v[2] + m[1][3] * v[3]),
                (m[2][0] * v[0] + m[2][1] * v[1] + m[2][2] * v[2] + m[2][3] * v[3]),
                (m[3][0] * v[0] + m[3][1] * v[1] + m[3][2] * v[2] + m[3][3] * v[3]), };
  return r;
}

float[][] matrix3Product(float[][] mat1, float[][] mat2){
  float[][] matOut = new float[3][3];
  for(int i = 0; i < 3; i++){
    for(int j = 0; j < 3; j++){
      matOut[i][j] = mat1[i][0] * mat2[0][j] + mat1[i][1] * mat2[1][j] + mat1[i][2] * mat2[2][j];
    }
  }
  return matOut;
}

float[][] crossProductMatrix(float[] vec){
  float[][] matOut = new float[3][3];
  matOut[0][0] = matOut[1][1] = matOut[2][2] = 0;
  matOut[0][1] = -vec[2];
  matOut[0][2] = vec[1];
  matOut[1][2] = -vec[0];
  matOut[1][0] = vec[2];
  matOut[2][0] = -vec[1];
  matOut[2][1] = vec[0];
  return matOut;
}

float determinant3(float[][] mat){
  float det = mat[0][0] * (mat[1][1]*mat[2][2] - mat[1][2]*mat[2][1]) - mat[0][1] * (mat[1][0]*mat[2][2] - mat[1][2]*mat[2][0]) + mat[0][2]*(mat[1][0]*mat[2][1] - mat[1][1]*mat[2][0]);
  return det;
}

float[][] invertMatrix3(float[][] mat){
  float[][] out = new float[3][3];
  float det = determinant3(mat);
  
  out[0][0] = (mat[1][1] * mat[2][2] - mat[1][2] * mat[2][1]) / det;
  out[0][1] = (mat[0][2] * mat[2][1] - mat[0][1] * mat[2][2]) / det;
  out[0][2] = (mat[0][1] * mat[1][2] - mat[0][2] * mat[1][1]) / det;
  
  out[1][0] = (mat[1][2] * mat[2][0] - mat[1][0] * mat[2][2]) / det;
  out[1][1] = (mat[0][0] * mat[2][2] - mat[0][2] * mat[2][0]) / det;
  out[1][2] = (mat[0][2] * mat[1][0] - mat[0][0] * mat[1][2]) / det;
  
  out[2][0] = (mat[1][0] * mat[2][1] - mat[1][1] * mat[2][0]) / det;
  out[2][1] = (mat[0][1] * mat[2][0] - mat[0][0] * mat[2][1]) / det;
  out[2][2] = (mat[0][0] * mat[1][1] - mat[0][1] * mat[1][0]) / det;
  
  return out;
}

float[][] makeRotationMatrix(float angle, float[] vector){
  float[] directionVector = normalize3(vector);
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
  float[] returnVector = matrix3Vector3Product(makeRotationMatrix(angle, rotateAround), vector);
  return returnVector;
}


float[] makeQuaternion(float angle, float[] vector){
  float[] axis = normalize3(vector);
  float[] q = {cos(angle/2), axis[0] * sin(angle/2), axis[1] * sin(angle/2), axis[2] * sin(angle/2)};
  return q;
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
  float[] outq = {q[0], -q[1], -q[2], -q[3]};
  return outq;
  
}

float[] rotateQ(float[] quaternion, float[] vector){
  float[] augmented = {0.0, vector[0], vector[1], vector[2]};
  augmented = quaternionProduct(quaternion, augmented);
  augmented = quaternionProduct(augmented, invertQuaternion(quaternion));
  float[] deAugmented = {augmented[1], augmented[2], augmented[3]};
  return deAugmented;
}