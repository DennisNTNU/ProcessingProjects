
int capacity = 10;
Quadtree quadtree;
int dragDivider = 15;
int dragCounter = 0;

// list contating nodes of the quadtree corresponding to
// your selection with middle mouse button and its neighbors.
ArrayList<Quadtree> selection_and_neighbour_list;

void setup()
{
  println("Contorls:");
  println("Left click to add random point to quadtree");
  println("Left drag to add tons of random points to quadtree");
  println("Right click to add point at mouse location to quadtree");
  println("Other mouse button click to show node neighbors");
  println("Press 'r' on keyboard to reset");
  println("##########################################################");
  size(1280, 720);
  quadtree = new Quadtree(capacity, 0, width, 0, height);
  selection_and_neighbour_list = new ArrayList<Quadtree>();
}

void draw()
{
  background(120);
  if (frameCount % 120000 == 0)
  {
    quadtree.show(true, 1);
    println("Total add cals:", quadtree.addCounter, "---------------------------------------");
  }
  else
  {
    quadtree.show(false, 1); 
  }
  
  draw_SANL(selection_and_neighbour_list);
}

void draw_SANL(ArrayList<Quadtree> SANL)
{
  if (SANL.size() >= 1)
  {
    stroke(250);
    fill(200, 0, 0);
    Quadtree qt = SANL.get(0);
    float cx = qt.bdry.xmin/2 + qt.bdry.xmax/2;
    float cy = qt.bdry.ymin/2 + qt.bdry.ymax/2;
    ellipse(cx, cy, 6, 6);
    
    stroke(200, 0, 0);
    fill(0, 0, 0, 0);
    rect(cx-6, cy-6, 12, 12);
    rect(cx-8, cy-8, 16, 16);
    stroke(0);
    rect(cx-7, cy-7, 14, 14);

    //stroke(250);
    //fill(200, 200, 0);
    for (int i = 1; i < SANL.size(); i++)
    {
      qt = SANL.get(i);
      cx = qt.bdry.xmin/2 + qt.bdry.xmax/2;
      cy = qt.bdry.ymin/2 + qt.bdry.ymax/2;
      //ellipse(cx, cy, 5, 5);
      
      stroke(200, 0, 0);
      fill(0, 0, 0, 0);
      rect(cx-6, cy-6, 12, 12);
      rect(cx-8, cy-8, 16, 16);
      stroke(255);
      rect(cx-7, cy-7, 14, 14);
    }
  }
}

void mousePressed()
{
  if (mouseButton == RIGHT)
  {
    quadtree.add(mouseX, mouseY);
  }
  else if (mouseButton != LEFT) // midle mouse button
  {
    // get what node this point falls in
    Quadtree qt = quadtree.check(mouseX, mouseY);
    
    qt.mkNeighborList(false);

    // plot it and its neightbors into list to be plottet
    // add it
    selection_and_neighbour_list = new ArrayList<Quadtree>();
    selection_and_neighbour_list.add(qt);
    
    // add neighbors
    for (int i = 0; i < qt.neighbors.size(); i++)
    {
      selection_and_neighbour_list.add(qt.neighbors.get(i));
    }
  }
}

void mouseClicked()
{
  if (mouseButton == LEFT)
  {
    float x = random(0, width);
    float y = random(0, height);
    quadtree.add(x, y);
  }
}

void mouseDragged()
{
  if (mouseButton == LEFT)
  {
    dragCounter++;
    if ((dragCounter % dragDivider) == 0)
    {
      float x = random(0, width);
      float y = random(0, height);
      quadtree.add(x, y);
    }
  }
}

void keyPressed()
{
  if (key == 'r')
  {
    if (quadtree.subdivided)
    {
      quadtree = new Quadtree(capacity, 0, width, 0, height);
      selection_and_neighbour_list = new ArrayList<Quadtree>();
    }
  }
}
