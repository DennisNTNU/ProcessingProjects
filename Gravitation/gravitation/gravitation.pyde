# Units used: Length: [km]; Mass: [kg]; Time: [s] 

sun_mass = 1.98855e30
earth_mass = 5.97219e24
mars_mass = 6.4185e23
ship_mass = 2.0e5

earth_x = 5.333333333333e8
earth_y = 3.0e8 + 1.47095e8
earth_vx = 30.28733
earth_vy = 0.0
earth_Fx = 0.0
earth_Fy = 0.0
mars_x = 5.333333333333e8
mars_y = 3.0e8 + 2.06654499e8
mars_vx = 26.49838033
mars_vy = 0.0
mars_Fx = 0.0
mars_Fy = 0.0
sun_x = 5.333333333333e8
sun_y = 3.0e8
sun_vx = 0.0
sun_vy = 0.0
sun_Fx = 0.0
sun_Fy = 0.0
ship_x = earth_x
ship_y = earth_y - 70e3
ship_vx = earth_vx + 3.546
ship_vy = earth_vy
ship_Fx = 0.0
ship_Fy = 0.0

thrustAngle = -3.14159265358979/4.0
thrustMagnitude = 2.0e-6 * ship_mass


clocktext = "Y: D: H: M: S"
seconds = 0.0
minutes = 0.0
hours = 0.0
days = 0.0
years = 0.0
G = 6.67385e-20
t = 0.0
dt = 7200

Fx = 0.0
Fy = 0.0
MFx = 0.0
MFy = 0.0

pixelX = 1280
pixelY = 720

pixel_per_kilometer = pixelY / (2 * 3.0e8)

def setup():
    size(pixelX, pixelY)
    fill(255)
    
#  
#    sun_x = 5.333333333333e8
#    sun_y = 3.0e8
#    
#    earth_x = 5.333333333333e8
#    earth_y = 3.0e8 + 1.49598261e8
#
#    mars_x = 5.333333333333e8
#    mars_y = 3.0e8 + 2.279391e8
#    



def draw():
    background(255)
    fill(255)
    
    global earth_x
    global earth_y
    global earth_vx
    global earth_vy
    global earth_Fx
    global earth_Fy
    global mars_x
    global mars_y
    global mars_vx
    global mars_vy
    global mars_Fx
    global mars_Fy
    global sun_x
    global sun_y
    global sun_vx
    global sun_vy
    global sun_Fx
    global sun_Fy
    global ship_x
    global ship_y
    global ship_vx
    global ship_vy
    global ship_Fx
    global ship_Fy
    global seconds
    global minutes
    global hours
    global days
    global years
    global t
    global dt
    global G
    
  
    t = t + dt
  
    #force on earth
    earth_Fx = G * earth_mass * (( sun_mass * (sun_x - earth_x)) / (pow( pow(sun_x - earth_x, 2) + pow(sun_y - earth_y, 2), 3.0/2.0)) + (mars_mass * (mars_x - earth_x)) / (pow( pow(mars_x - earth_x, 2) + pow(mars_y - earth_y, 2), 3.0/2.0)) )
    earth_Fy = G * earth_mass * (( sun_mass * (sun_y - earth_y)) / (pow( pow(sun_x - earth_x, 2) + pow(sun_y - earth_y, 2), 3.0/2.0)) + (mars_mass * (mars_y - earth_y)) / (pow( pow(mars_x - earth_x, 2) + pow(mars_y - earth_y, 2), 3.0/2.0)) )
    #force on mars
    mars_Fx = G * mars_mass * ( sun_mass * (sun_x - mars_x) / pow( pow(sun_x - mars_x, 2) + pow(sun_y - mars_y, 2), 3.0/2.0) + earth_mass * (earth_x - mars_x) / pow( pow(earth_x - mars_x, 2) + pow(earth_y - mars_y, 2), 3.0/2.0) )
    mars_Fy = G * mars_mass * ( sun_mass * (sun_y - mars_y) / pow( pow(sun_x - mars_x, 2) + pow(sun_y - mars_y, 2), 3.0/2.0) + earth_mass * (earth_y - mars_y) / pow( pow(earth_x - mars_x, 2) + pow(earth_y - mars_y, 2), 3.0/2.0) )
    #force on sun
    sun_Fx = G * sun_mass * ( earth_mass * (earth_x - sun_x) / pow( pow(earth_x - sun_x, 2) + pow(earth_y - sun_y, 2), 3.0/2.0) + mars_mass * (mars_x - sun_x) / pow( pow(mars_x - sun_x, 2) + pow(mars_y - sun_y, 2), 3.0/2.0) )
    sun_Fy = G * sun_mass * ( earth_mass * (earth_y - sun_y) / pow( pow(earth_x - sun_x, 2) + pow(earth_y - sun_y, 2), 3.0/2.0) + mars_mass * (mars_y - sun_y) / pow( pow(mars_x - sun_x, 2) + pow(mars_y - sun_y, 2), 3.0/2.0) )
    #force on ship
    ship_Fx = G * ship_mass * ( earth_mass * (earth_x - ship_x) / pow( pow(earth_x - ship_x, 2) + pow(earth_y - ship_y, 2), 3.0/2.0) + mars_mass * (mars_x - ship_x) / pow( pow(mars_x - ship_x, 2) + pow(mars_y - ship_y, 2), 3.0/2.0) + sun_mass * (sun_x - ship_x) / pow( pow(sun_x - ship_x, 2) + pow(sun_y - ship_y, 2), 3.0/2.0) )
    ship_Fy = G * ship_mass * ( earth_mass * (earth_y - ship_y) / pow( pow(earth_x - ship_x, 2) + pow(earth_y - ship_y, 2), 3.0/2.0) + mars_mass * (mars_y - ship_y) / pow( pow(mars_x - ship_x, 2) + pow(mars_y - ship_y, 2), 3.0/2.0) + sun_mass * (sun_y - ship_y) / pow( pow(sun_x - ship_x, 2) + pow(sun_y - ship_y, 2), 3.0/2.0) )
     
    #integrate earth velocity
    earth_vx = earth_vx + earth_Fx * dt / earth_mass
    earth_vy = earth_vy + earth_Fy * dt / earth_mass
    #integrate earth position
    earth_x = earth_x + earth_vx * dt
    earth_y = earth_y + earth_vy * dt
    
    #integrate mars velocity
    mars_vx = mars_vx + mars_Fx * dt / mars_mass
    mars_vy = mars_vy + mars_Fy * dt / mars_mass
    #integrate mars position
    mars_x = mars_x + mars_vx * dt
    mars_y = mars_y + mars_vy * dt
    
    #integrate sun velocity
    sun_vx = sun_vx + sun_Fx * dt / sun_mass
    sun_vy = sun_vy + sun_Fy * dt / sun_mass
    #integrate sun position
    sun_x = sun_x + sun_vx * dt
    sun_y = sun_y + sun_vy * dt
    
    ship_Fx = ship_Fx + thrustMagnitude * cos(thrustAngle)
    ship_Fy = ship_Fy + thrustMagnitude * sin(thrustAngle)
        
    
    #integrate ship velocity
    ship_vx = ship_vx + ship_Fx * dt / ship_mass
    ship_vy = ship_vy + ship_Fy * dt / ship_mass
    #integrate earth position
    ship_x = ship_x + ship_vx * dt
    ship_y = ship_y + ship_vy * dt
    
    textSize(15)
    fill(0)
    text(int(dt), 5, 15)  
    text(int(t), 5, 35)
           
    if int(t / 31536000) != int((t - dt) / 31536000):
        years = years + 1
        days = 0
        hours = 0
        minutes = 0
        seconds = 0
    elif int(t / 86400) != int((t - dt) / 86400):
        days = days + 1
        hours = 0
        minutes = 0
        seconds = 0
    elif int(t / 3600) != int((t - dt) / 3600):
        hours = hours + 1
        minutes = 0
        seconds = 0
    elif int(t / 60) != int((t - dt) / 60):
        minutes = minutes + 1
        seconds = 0
    else:
        seconds = seconds +1
        
    if dt <= 1:
        s = str(int(years)) + ":" + str(int(days)) + ":" + str(int(hours)) + ":" + str(int(minutes)) + ":" + str(int(seconds))
    elif dt <= 60:
        s = str(int(years)) + ":" + str(int(days)) + ":" + str(int(hours)) + ":" + str(int(minutes))
    elif dt <= 3600:
        s = str(int(years)) + ":" + str(int(days)) + ":" + str(int(hours))
    elif dt <= 86400:
        s = str(int(years)) + ":" + str(int(days))
    else:
        s = str(int(years))
    text(clocktext, 5 , 55)
    text(s, 5, 75)
        
    ellipse(earth_x * pixel_per_kilometer, earth_y * pixel_per_kilometer, 5, 5)
    ellipse(mars_x * pixel_per_kilometer, mars_y * pixel_per_kilometer, 4, 4)
    ellipse(sun_x * pixel_per_kilometer, sun_y * pixel_per_kilometer, 20, 20)
    
    fill(100)
    ellipse(ship_x * pixel_per_kilometer, ship_y * pixel_per_kilometer, 3, 3)
    fill(0)
    
def mouseClicked():
    global dt
    if mouseButton == LEFT:
        if dt > 2:
            dt = dt / 2
    else:
        dt = 2 * dt
    
    

