color getRGBFromNM(float nm){
  
  //nm is in the range of 350 to 800
  float r = 255*pow(2.718281828, -(nm - 660)*(nm - 660)/(2*45*45)) + 155*pow(2.718281828, -(nm - 410)*(nm - 410)/700);
  float g = 255*pow(2.718281828, -(nm - 530)*(nm - 525)/(2*40*40));
  float b = 255*pow(2.718281828, -(nm - 440)*(nm - 440)/(2*30*30));
  
  
  //normalize if nm is between 440 and 660
  if (nm < 660 && nm > 440) {
    float d = sqrt(r*r + g*g + b*b);
    r = 255 * r / d;
    g = 255 * g / d;
    b = 255 * b / d;
  }
  
  color rgb = color(r,g,b,255);
  
  return rgb;
}

color rgbFromTemp(float kelvin){
  
  kelvin = kelvin / 100;
  float r = 0;
  float g = 0;
  float b = 0;
  
  //red
  if (kelvin < 66) {
    r = 255;
  }else{
    r = kelvin - 60;
    r = 329.698727446*pow(r, -0.1332047592);
    if (r <= 0) { r = 0; }
    if (r >= 255) { r = 255; }
  }
  
  //green
  if (kelvin <= 66) {
    g = kelvin;
    g = 99.4708025861 * log(g) - 161.1195681661;
  } else {
    g = kelvin - 60;
    g = 288.1221695283 * pow(g, -0.0755148492);
  }
  if (g <= 0) { g = 0; }
  if (g >= 255) { g = 255; }
  
  //blue
  if (kelvin >= 66) {
    b = 255;
  }else if (kelvin <= 19) {
    b = 0;
  }else{
    b = kelvin - 10;
    b = 138.5177312231*log(b) - 305.0447927307;
    if (b <= 0) { b = 0; }
    if (b >= 255) { b = 255; }
  }
  
  if (kelvin <= 12) {
    r *= (kelvin - 6)/6;
    g *= (kelvin - 6)/6;
  }
  
  return color(r, g, b, 255);
}