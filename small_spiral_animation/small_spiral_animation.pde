
int i;

void setup()
{
  size(120, 120);
  i = 0;
  background(255-51);
  fill(30);
  stroke(255-130);
}

void draw()
{
  
  i++;
  if (i > 40){ i = 0; background(255-51);}
  
//  for(int j = 0; j < i; j++){
    rect(width/2 + i*cos(i) - 10, height/2 + i*sin(i) - 10, 20, 20);
    ellipse(width/2 + i*cos(i), height/2 + i*sin(i), 16, 16);
//  }
  
}