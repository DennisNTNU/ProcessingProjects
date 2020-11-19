
int capacity = 25;
Quadtree quadtree;

void setup()
{
  println("Contorls:");
  println("Left click to add random point to quadtree");
  println("Right click to add point at mouse location to quadtree");
  println("Press 'r' on keyboard to reset");
  println("##########################################################");
  size(1280, 720);
  quadtree = new Quadtree(capacity, width/2, height/2, width, height);
}

void draw()
{
  background(120);
  if (frameCount % 120 == 0)
  {
    quadtree.show(true, 1);
    println("-----------------------------------------------------------------");
  }
  else
  {
    quadtree.show(false, 1); 
  }
}

void mousePressed()
{
  if (mouseButton == LEFT)
  {
    float x = random(0, width);
    float y = random(0, height);
    quadtree.add(x, y);
  }
  else
  {
    quadtree.add(mouseX, mouseY);
  }
}

void keyPressed()
{
  if (key == 'r')
  {
    if (quadtree.subdivided)
    {
      quadtree = new Quadtree(capacity, width/2, height/2, width, height);
    }
  }
}
