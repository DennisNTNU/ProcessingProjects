
class Pnt
{
  Pnt(float x_, float y_)
  {
    x = x_;
    y = y_;
  }
  float x;
  float y;
};

class Quadtree
{
  Quadtree(int capacity_, float x, float y, float w, float h)
  {
    c = new Pnt(x,y);
    dims = new Pnt(w,h);

    capacity = capacity_;
    points = new ArrayList<Pnt>();
    
    parent = null;

    subdivided = false;
    topleft = null;
    topright = null;
    botleft = null;
    botright = null;
    
    col = color(random(256), random(256), random(256));
  }
  Quadtree(Quadtree parent_, int capacity_, float x, float y, float w, float h)
  {
    c = new Pnt(x,y);
    dims = new Pnt(w,h);

    capacity = capacity_;
    points = new ArrayList<Pnt>();
    
    parent = parent_;

    subdivided = false;
    topleft = null;
    topright = null;
    botleft = null;
    botright = null;
    
    col = color(random(256), random(256), random(256));
  }

  Pnt c;
  Pnt dims;

  int capacity;
  ArrayList<Pnt> points;
  
  Quadtree parent;

  boolean subdivided;
  Quadtree topleft;
  Quadtree topright;
  Quadtree botleft;
  Quadtree botright;
  
  color col;
  
  boolean in(Pnt pnt)
  {
    if (pnt.y < (c.y - dims.y/2))
    {
      return false;
    }
    if (pnt.y > (c.y + dims.y/2))
    {
      return false;
    }
    
    if (pnt.x < (c.x - dims.x/2))
    {
      return false;
    }
    if (pnt.x > (c.x + dims.x/2))
    {
      return false;
    }
    return true;
  }
  
  void add(Pnt pnt)
  {
    if (!subdivided)
    {
      
      if (points.size() == 0)
      {
        points.add(pnt);
      }
      else
      {
        // only add this point if another point with the same coordinates does not exist already.
        for (int i = 0; i < points.size(); i++)
        {
          Pnt pnt_ = points.get(i); 
          if (pnt_.x != pnt.x || pnt_.y != pnt.y)
          {
            points.add(pnt);
            break;
          }
        }
      }
      
      // check if above capacity
      // if yes, subdivide the tree.
      // add all points to its children
      // and remove all points in self.points
      
      // check if above capacity
      if (points.size() >= capacity)
      {
        subdivided = true;
        // if yes, subdivide the tree.
        topleft = new Quadtree(this, capacity, c.x - dims.x/4, c.y - dims.y/4, dims.x/2, dims.y/2);
        topright = new Quadtree(this, capacity, c.x + dims.x/4, c.y - dims.y/4, dims.x/2, dims.y/2);
        botleft = new Quadtree(this, capacity, c.x - dims.x/4, c.y + dims.y/4, dims.x/2, dims.y/2);
        botright = new Quadtree(this, capacity, c.x + dims.x/4, c.y + dims.y/4, dims.x/2, dims.y/2);
        
        // add all points to its children
        // and remove all points in self.points
        for (int i = points.size() - 1; i >= 0; i--)
        {
          Pnt pnt_ = points.get(i); 
          if (topleft.in(pnt_))
          {
            topleft.add(pnt_);
            points.remove(i);
          }
        }
        for (int i = points.size() - 1; i >= 0; i--)
        {
          Pnt pnt_ = points.get(i); 
          if (topright.in(pnt_))
          {
            topright.add(pnt_);
            points.remove(i);
          }
        }
        for (int i = points.size() - 1; i >= 0; i--)
        {
          Pnt pnt_ = points.get(i); 
          if (botleft.in(pnt_))
          {
            botleft.add(pnt_);
            points.remove(i);
          }
        }
        for (int i = points.size() - 1; i >= 0; i--)
        {
          Pnt pnt_ = points.get(i); 
          if (botright.in(pnt_))
          {
            botright.add(pnt_);
            points.remove(i);
          }
        }
      }
    }
    else
    {
      // check which child tree this point belong to and add it there
      if (topleft.in(pnt))
      {
        topleft.add(pnt);
      }
      else if (topright.in(pnt))
      {
        topright.add(pnt);
      }
      else if (botleft.in(pnt))
      {
        botleft.add(pnt);
      }
      else if (botright.in(pnt))
      {
        botright.add(pnt);
      }
    }
  }
  
  void add(float x, float y)
  {
    add(new Pnt(x,y));
  }
  
  void show(boolean print_depth, int depth)
  {
    if (subdivided)
    {
      topleft.show(print_depth, depth+1);
      topright.show(print_depth, depth+1);
      botleft.show(print_depth, depth+1);
      botright.show(print_depth, depth+1);
    }
    else
    {
      fill(0,0,0,0);
      stroke(0);
      rect(c.x - dims.x/2, c.y - dims.y/2, dims.x, dims.y);
      
      fill(col);
      ellipse(c.x, c.y, 11, 11);

      stroke(120);
      for (int i = 0; i < points.size(); i++)
      {
        Pnt pnt = points.get(i); 
        ellipse(pnt.x, pnt.y, 5, 5);
      }
      
      if (print_depth)
      {
        println("depth: ", depth, " ", c.x, ", ", c.y, "Points: ", points.size());
      }
    }
  }
};
