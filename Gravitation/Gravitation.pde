// Units used: Length: [km]; Mass: [kg]; Time: [s] 

float sun_mass = 1.98855e30;
float earth_mass = 5.97219e24;
float mars_mass = 6.4185e23;

float earth_x = 0.0;
float earth_y = 0.0;
float earth_vx = 29.78;
float earth_vy = 0.0;
float earth_Fx = 5.0;
float earth_Fy = 0.0;

float mars_x = 0.0;
float mars_y = 0.0;
float mars_vx = 24.077;
float mars_vy = 0.0;
float mars_Fx = 0.0;
float mars_Fy = 0.0;

float sun_x = 0.0;
float sun_y = 0.0;
float sun_vx = 0.0;
float sun_vy = 0.0;
float sun_Fx = 0.0;
float sun_Fy = 0.0;



float t = 0.0;
float G = 6.67384e-20;
float dt = 5.0;

float Fx = 0.0;
float Fy = 0.0;
float MFx = 0.0;
float MFy = 0.0;

int pixelX = 1280;
int pixelY = 720;

float pixel_per_kilometer = pixelY / (2 * 3.0e8);


void setup(){
  size(1280, 720);
  fill(255);
  
  sun_x = 5.333333333333e8;
  sun_y = 3.0e8;
  
  earth_x = 5.333333333333e8;
  earth_y = 3.0e8 + 1.49598261e8;

  mars_x = 5.333333333333e8;
  mars_y = 3.0e8 + 2.279391e8; 
}


void draw(){
  background(255);
  fill(255);

  
  
  ellipse(earth_x * pixel_per_kilometer, earth_y * pixel_per_kilometer, 5, 5);
  ellipse(mars_x * pixel_per_kilometer, mars_y * pixel_per_kilometer, 4, 4);
  ellipse(sun_x * pixel_per_kilometer, sun_y * pixel_per_kilometer, 20, 20);
  
  t = t + dt;
  
  //force on earth
  earth_Fx = G * earth_mass * ( sun_mass * (sun_x - earth_x) / pow( pow(sun_x - earth_x, 2) + pow(sun_y - earth_y, 2), 3/2) + mars_mass * (mars_x - earth_x) / pow( pow(mars_x - earth_x, 2) + pow(mars_y - earth_y, 2), 3/2) );
  earth_Fy = G * earth_mass * ( sun_mass * (sun_y - earth_y) / pow( pow(sun_x - earth_x, 2) + pow(sun_y - earth_y, 2), 3/2) + mars_mass * (mars_y - earth_y) / pow( pow(mars_x - earth_x, 2) + pow(mars_y - earth_y, 2), 3/2) );
  
  //force on mars
  mars_Fx = G * mars_mass * ( 1.0e-5 * sun_mass * (sun_x - mars_x) / pow( pow(sun_x - mars_x, 2) + pow(sun_y - mars_y, 2), 3/2) + 1.0e-5 * earth_mass * (earth_x - mars_x) / pow( pow(earth_x - mars_x, 2) + pow(earth_y - mars_y, 2), 3/2) );
  mars_Fy = G * mars_mass * ( 1.0e-5 * sun_mass * (sun_y - mars_y) / pow( pow(sun_x - mars_x, 2) + pow(sun_y - mars_y, 2), 3/2) + 1.0e-5 * earth_mass * (earth_y - mars_y) / pow( pow(earth_x - mars_x, 2) + pow(earth_y - mars_y, 2), 3/2) );
    
  //force on sun
  sun_Fx = G * sun_mass * ( earth_mass * (earth_x - sun_x) / pow( pow(earth_x - sun_x, 2) + pow(earth_y - sun_y, 2), 3/2) + mars_mass * (mars_x - sun_x) / pow( pow(mars_x - sun_x, 2) + pow(mars_y - sun_y, 2), 3/2) );
  sun_Fy = G * sun_mass * ( earth_mass * (earth_y - sun_y) / pow( pow(earth_x - sun_x, 2) + pow(earth_y - sun_y, 2), 3/2) + mars_mass * (mars_y - sun_y) / pow( pow(mars_x - sun_x, 2) + pow(mars_y - sun_y, 2), 3/2) );
  
  //integrate earth velocity
  earth_vx = earth_vx + earth_Fx * dt / earth_mass; 
  earth_vy = earth_vy + earth_Fy * dt / earth_mass;
  //integrate earth position
  earth_x = earth_x + earth_vx * dt; 
  earth_y = earth_y + earth_vy * dt;
  
  //integrate mars velocity
  mars_vx = mars_vx + 1.0e5 * mars_Fx * dt / mars_mass; 
  mars_vy = mars_vy + 1.0e5 * mars_Fy * dt / mars_mass;
  //integrate mars position
  mars_x = mars_x + mars_vx * dt; 
  mars_y = mars_y + mars_vy * dt;
  
  //integrate sun velocity
  sun_vx = sun_vx + sun_Fx * dt / sun_mass; 
  sun_vy = sun_vy + sun_Fy * dt / sun_mass;
  //integrate sun position
  sun_x = sun_x + sun_vx * dt; 
  sun_y = sun_y + sun_vy * dt;
  
  
}