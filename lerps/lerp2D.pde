

float[] lerp2D(float[] v1, float[] v2, float t){
  float a = lerp(v1[0], v2[0], t);
  float b = lerp(v1[1], v2[1], t);
  float[] v3 = {a, b};
  return v3;
}

float[] multilerp(float[][] v, float t){
  int l = v.length - 1;
  if (l == 0) {
    return v[0];
  }else{
    float[][] a = new float[l][2];
    for (int i = 0; i < l; i++) {
      a[i] = lerp2D(v[i], v[i+1], t);
    }
    return multilerp(a, t);
  }
}

float[] multilerp(ArrayList<float[]> v, float t){
  int l = v.size() - 1;
  if (l == -1) {
    float[] a = {width / 2, height / 2};
    return a;
  }else if (l == 0) {
    return v.get(0);
  }else{
    //float[][] a = new float[l][2];
    ArrayList<float[]> a = new ArrayList<float[]>(l);
    for (int i = 0; i < l; i++) {
      a.add( lerp2D(v.get(i), v.get(i+1), t) );
    }
    return multilerp(a, t);
  }
}