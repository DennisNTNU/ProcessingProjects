class Stars{
  int n;
  Star[] stars;
  
  Stars(int N){
    n = N;
    stars = new Star[n];
    for (int i = 0; i < n; i++) {
      float X = random(width);
      float Y = random(2 * height / 3);
      float size1 = 1 + random(2);
      float size2 = 1 + random(1);
      stars[i] = new Star(X, Y, size1, size2);
    }
  }
  
  void draw(){
    //update loop
    for (int i = 0; i < n; i++) {
      stars[i].posx -= 75;
      stars[i].posy -= 75;
      stars[i].posx = cos(dt)*stars[i].posx - sin(dt)*stars[i].posy; 
      stars[i].posy = sin(dt)*stars[i].posx + cos(dt)*stars[i].posy;
      stars[i].posx += 75;
      stars[i].posy += 75;
      if (outsideView(i)) {
        stars[i] = genNewStar();
      }
    }
    //draw loop
    for (int i = 0; i < n; i++) {
      line(stars[i].posx - stars[i].size1, stars[i].posy - stars[i].size1, stars[i].posx + stars[i].size1, stars[i].posy + stars[i].size1);
      line(stars[i].posx - stars[i].size2, stars[i].posy + stars[i].size2, stars[i].posx + stars[i].size2, stars[i].posy - stars[i].size2);
    }
  }
  
  Star genNewStar(){
    float X = random(width);
    float Y = -random(5);
    float size1 = 1 + random(2);
    float size2 = 1 + random(1);
    return new Star(X, Y, size1, size2);
  }
  
  boolean outsideView(int i){
    return stars[i].posx > width || stars[i].posx < 0 || stars[i].posy > height || stars[i].posy < 0;
  }
}


class Star{
  float posx;
  float posy;
  float size1;
  float size2;
  
  Star(float x, float y, float s1, float s2){
    posx = x;
    posy = y;
    size1 = s1;
    size2 = s2;
    
  }
  
}