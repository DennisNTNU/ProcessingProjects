class Madgwick {
  float q0, q1, q2, q3;
  PVector w_b;

  float gain;
  float zeta;

  Madgwick() {
    q0 = 1.0;
    q1 = 0.0;
    q2 = 0.0;
    q3 = 0.0;
  }
  void setAlgorithmGain(float gain_)
  {
    gain = gain_;
  }

  void setDriftBiasGain(float zeta_)
  {
    zeta = zeta_;
  }

  void madgwickAHRSupdateIMU(
    float gx, float gy, float gz, 
    float ax, float ay, float az, 
    float dt)
  {
    float recipNorm;
    float s0 = 0.0, s1 = 0.0, s2 = 0.0, s3 = 0.0;
    float qDot1, qDot2, qDot3, qDot4;

    //Orientation change from gyro
    qDot1 = - 0.5*( q1*gx + q2*gy + q3*gz);
    qDot2 = 0.5*( q0*gx - q3*gy + q2*gz);
    qDot3 = 0.5*( q3*gx + q0*gy - q1*gz);
    qDot4 = 0.5*(-q2*gx + q1*gy + q0*gz);

    //normalize accelerometer measurements

    //gradient descent step
    float f0, f1, f2;
    float _2dx = 0.0, _2dy = 0.0, _2dz = 2.0;

    f0 = _2dx * (0.5f - q2 * q2 - q3 * q3)
      + _2dy * (q0 * q3 + q1 * q2)
      + _2dz * (q1 * q3 - q0 * q2);
    f1 = _2dx * (q1 * q2 - q0 * q3)
      + _2dy * (0.5f - q1 * q1 - q3 * q3)
      + _2dz * (q0 * q1 + q2 * q3);
    f2 = _2dx * (q0 * q2 + q1 * q3)
      + _2dy * (q2 * q3 - q0 * q1)
      + _2dz * (0.5f - q1 * q1 - q2 * q2);

    f0 -= ax;
    f1 -= ay;
    f2 -= az;

    // EQ 22, 34
    // Jt * f
    s0 += (_2dy * q3 - _2dz * q2) * f0
      + (-_2dx * q3 + _2dz * q1) * f1
      + (_2dx * q2 - _2dy * q1) * f2;
    s1 += (_2dy * q2 + _2dz * q3) * f0
      + (_2dx * q2 - 2.0f * _2dy * q1 + _2dz * q0) * f1
      + (_2dx * q3 - _2dy * q0 - 2.0f * _2dz * q1) * f2;
    s2 += (-2.0f * _2dx * q2 + _2dy * q1 - _2dz * q0) * f0
      + (_2dx * q1 + _2dz * q3) * f1
      + (_2dx * q0 + _2dy * q3 - 2.0f * _2dz * q2) * f2;
    s3 += (-2.0f * _2dx * q3 + _2dy * q0 + _2dz * q1) * f0
      + (-_2dx * q0 - 2.0f * _2dy * q3 + _2dz * q2) * f1
      + (_2dx * q1 + _2dy * q2) * f2;

    recipNorm = 1/sqrt(s0*s0 + s1*s1 + s2*s2 + s3*s3);
    qDot1 -= gain * s0;
    qDot2 -= gain * s1;
    qDot3 -= gain * s2;
    qDot4 -= gain * s3;


    q0 += qDot1 * dt;
    q1 += qDot2 * dt;
    q2 += qDot3 * dt;
    q3 += qDot4 * dt;
    recipNorm = 1 / sqrt(q0 * q0 + q1 * q1 + q2 * q2 + q3 * q3);
    q0 *= recipNorm;
    q1 *= recipNorm;
    q2 *= recipNorm;
    q3 *= recipNorm;
  }
}