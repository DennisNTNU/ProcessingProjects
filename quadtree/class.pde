
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

class Int2D
{
  Int2D(int x_, int y_)
  {
    x = x_;
    y = y_;
  }
  int x;
  int y;
};

class QTBoundary
{
  QTBoundary(float xmin_, float xmax_, float ymin_, float ymax_)
  {
    xmin = xmin_;
    xmax = xmax_;
    ymin = ymin_;
    ymax = ymax_;
  }
  float xmin;
  float xmax;
  float ymin;
  float ymax;
};

class Quadtree
{
  void initialize()
  {
    bdry = null;

    capacity = 10;
    points = new ArrayList<Pnt>();
    addCounter = 0;
    
    parent = null;
    neighbors = new ArrayList<Quadtree>();

    locationCode = "";

    subdivided = false;
    topleft = null;
    topright = null;
    botleft = null;
    botright = null;
    
    col = color(random(256), random(256), random(256));
  }

  Quadtree(int capacity_, float xmin, float xmax, float ymin, float ymax)
  {
    initialize();

    bdry = new QTBoundary(xmin, xmax, ymin, ymax);
    capacity = capacity_;
  }
  Quadtree(Quadtree parent_, int capacity_, float xmin, float xmax, float ymin, float ymax)
  {
    initialize();

    bdry = new QTBoundary(xmin, xmax, ymin, ymax);
    capacity = capacity_;
    parent = parent_;
  }

  QTBoundary bdry;

  int capacity;
  ArrayList<Pnt> points;
  int addCounter;
  
  Quadtree parent;
  ArrayList<Quadtree> neighbors;
  
  String locationCode;

  boolean subdivided;
  Quadtree topleft;
  Quadtree topright;
  Quadtree botleft;
  Quadtree botright;
  
  color col;
  
  boolean in(Pnt pnt)
  {
    return in(pnt.x, pnt.y);
  }
  
  boolean in(float x, float y)
  {
    // returns true if this point falls into this node, false otherwise.
    if (y < bdry.ymin)
    {
      return false;
    }
    if (y > bdry.ymax)
    {
      return false;
    }
    
    if (x < bdry.xmin)
    {
      return false;
    }
    if (x > bdry.xmax)
    {
      return false;
    }
    return true;
  }
  
  Quadtree check(float x, float y)
  {
    // Return quadtree node this point falls in
    if (!subdivided)
    {
      return this;
    }
    else
    {
      if (topleft.in(x, y))
      {
        return topleft.check(x,y);
      }
      else if (topright.in(x, y))
      {
        return topright.check(x,y);
      }
      else if (botleft.in(x, y))
      {
        return botleft.check(x,y);
      }
      else if (botright.in(x, y))
      {
        return botright.check(x,y);
      }
    }
    return null;
  }
  
  private void subdivide()
  {
    // subdivide the tree by dividing the boundary into four
    // creating four corresponding childern,
    // and distributing all points this node has across these four new children.
    subdivided = true;

    float w2 = (bdry.xmax - bdry.xmin)/2;
    float h2 = (bdry.ymax - bdry.ymin)/2;
    float xmid = bdry.xmin + w2;
    float ymid = bdry.ymin + h2;

    topleft = new Quadtree(this, capacity, bdry.xmin, xmid, bdry.ymin, ymid);
    topright = new Quadtree(this, capacity, xmid, bdry.xmax, bdry.ymin, ymid);
    botleft = new Quadtree(this, capacity, bdry.xmin, xmid, ymid, bdry.ymax);
    botright = new Quadtree(this, capacity, xmid, bdry.xmax, ymid, bdry.ymax);
    
    topleft.locationCode = locationCode + "0";
    topright.locationCode = locationCode + "1";
    botleft.locationCode = locationCode + "2";
    botright.locationCode = locationCode + "3";
    
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
    
    // housekeep neighbor list
    topleft.neighbors.add(topright);
    topleft.neighbors.add(botleft);
    topleft.neighbors.add(botright);
    
    topright.neighbors.add(topleft);
    topright.neighbors.add(botleft);
    topright.neighbors.add(botright);
    
    botleft.neighbors.add(topleft);
    botleft.neighbors.add(topright);
    botleft.neighbors.add(botright);
    
    botright.neighbors.add(topleft);
    botright.neighbors.add(topright);
    botright.neighbors.add(botleft);
    
    
    for (int i = 0; i < neighbors.size(); i++)
    {
      neighbors.get(i);
      // 
    }

    if (parent != null)
    {
      // recursively update neighbors somehow
    }
  }
  
  private void add_unsubdivided(Pnt pnt)
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
    // if yes:
    // - subdivide the tree.
    // - add all points to its children
    // - and remove all points in self.points
    
    // check if above capacity
    if (points.size() >= capacity)
    {
      subdivide();
    }
  }
  
  void add(float x, float y)
  {
    add(new Pnt(x,y));
  }
  
  void add(Pnt pnt)
  {
    addCounter++;
    // if not already subdivided, add point to this node.
    if (!subdivided)
    {
      add_unsubdivided(pnt);
    }
    else // if (!subdivided) 
    {
      // if this node is subdivided, check which child tree this 
      // point belongs to and add it there
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
      //rect(c.x - dims.x/2, c.y - dims.y/2, dims.x, dims.y);
      rect(bdry.xmin, bdry.ymin, bdry.xmax - bdry.xmin, bdry.ymax - bdry.ymin);
      
      float centerx = bdry.xmin/2 + bdry.xmax/2;
      float centery = bdry.ymin/2 + bdry.ymax/2;
      fill(col);
      ellipse(centerx, centery, 11, 11);

      stroke(120);
      for (int i = 0; i < points.size(); i++)
      {
        Pnt pnt = points.get(i); 
        ellipse(pnt.x, pnt.y, 5, 5);
      }
      
      text(locationCode, centerx-5, centery-7);
      
      if (print_depth)
      {
        println("depth:", depth, " ", centerx, " ", centery, " Points:", points.size(), " Code:", locationCode);
      }
    }
  }
  
  void printBoundry()
  {
    println(locationCode, "xmin max:", bdry.xmin, bdry.xmax, "ymin max:", bdry.ymin, bdry.ymax);
  }
  
  
  
  
  
  
  
  
  
  
  private boolean touching(QTBoundary bd1, QTBoundary bd2)
  {
    if ( (bd1.xmin > bd2.xmax) ||
         (bd1.xmax < bd2.xmin) ||
         (bd1.ymin > bd2.ymax) ||
         (bd1.ymax < bd2.ymin)    )
    {
      return false;
    }
    else
    {
      if ( (bd1.xmin == bd2.xmax) ||
           (bd1.xmax == bd2.xmin) ||
           (bd1.ymin == bd2.ymax) ||
           (bd1.ymax == bd2.ymin)    )
      {
        return true;
      }
      else
      {
        return false;
      }
    }
  }
  
  
  private ArrayList<Quadtree> getTouchingLeaves(Quadtree qt, Quadtree parent)
  {
    ArrayList<Quadtree> list = new ArrayList<Quadtree>();
    
    if (parent.topleft != qt && touching(parent.topleft.bdry, qt.bdry))
    {
      if (parent.topleft.subdivided)
      {
        ArrayList<Quadtree> list_leave = getTouchingLeaves(qt, parent.topleft);
        for (int i = 0; i < list_leave.size(); i++)
        {
          list.add(list_leave.get(i));
        }
      }
      else
      {
        list.add(parent.topleft);
      }
    }


    if (parent.topright != qt && touching(parent.topright.bdry, qt.bdry))
    {
      if (parent.topright.subdivided)
      {
        ArrayList<Quadtree> list_leave = getTouchingLeaves(qt, parent.topright);
        for (int i = 0; i < list_leave.size(); i++)
        {
          list.add(list_leave.get(i));
        }
      }
      else
      {
        list.add(parent.topright);
      }
    }


    if (parent.botleft != qt && touching(parent.botleft.bdry, qt.bdry))
    {
      if (parent.botleft.subdivided)
      {
        ArrayList<Quadtree> list_leave = getTouchingLeaves(qt, parent.botleft);
        for (int i = 0; i < list_leave.size(); i++)
        {
          list.add(list_leave.get(i));
        }
      }
      else
      {
        list.add(parent.botleft);
      }
    }


    if (parent.botright != qt && touching(parent.botright.bdry, qt.bdry))
    {
      if (parent.botright.subdivided)
      {
        ArrayList<Quadtree> list_leave = getTouchingLeaves(qt, parent.botright);
        for (int i = 0; i < list_leave.size(); i++)
        {
          list.add(list_leave.get(i));
        }
      }
      else
      {
        list.add(parent.botright);
      }
    }
    
    return list;
  }
  
  private void addTouchingLeaves(Quadtree qt, Quadtree parent, ArrayList<Quadtree> nbrList)
  {
    ArrayList<Quadtree> nbrList_local = getTouchingLeaves(qt, parent);
    
    for (int i = 0; i < nbrList_local.size(); i++)
    {
      nbrList.add(nbrList_local.get(i));
    }
  }
  
  private void iterateUp(Quadtree qt, Quadtree parent, ArrayList<Quadtree> nbrList)
  {
    addTouchingLeaves(qt, parent, nbrList);
    if (parent.parent != null)
    {
      iterateUp(qt, parent.parent, nbrList);
    }
  }
  
  void mkNeighborList_old()
  {
    neighbors = new ArrayList<Quadtree>();
    if (parent == null)
    {
      return;
    }
    iterateUp(this, parent, neighbors);
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  private Int2D[][] mkNeighborLUT()
  {
    // first index quadrant, second index direction.
    // Direction: R  L  D  U  RU  RD  LD  LU
    //            0  1  2  3   4   5   6   7  
    Int2D[][] lookuptable = new Int2D[4][8];
    lookuptable[0][0] = new Int2D(1, -1);
    lookuptable[1][0] = new Int2D(0, 0);
    lookuptable[2][0] = new Int2D(3, -1);
    lookuptable[3][0] = new Int2D(2, 0);
    
    lookuptable[0][1] = new Int2D(1, 1);
    lookuptable[1][1] = new Int2D(0, -1);
    lookuptable[2][1] = new Int2D(3, 1);
    lookuptable[3][1] = new Int2D(2, -1);
    
    lookuptable[0][2] = new Int2D(2, -1);
    lookuptable[1][2] = new Int2D(3, -1);
    lookuptable[2][2] = new Int2D(0, 2);
    lookuptable[3][2] = new Int2D(1, 2);
    
    lookuptable[0][3] = new Int2D(2, 3);
    lookuptable[1][3] = new Int2D(3, 3);
    lookuptable[2][3] = new Int2D(0, -1);
    lookuptable[3][3] = new Int2D(1, -1);
    
    lookuptable[0][4] = new Int2D(3, 3);
    lookuptable[1][4] = new Int2D(2, 4);
    lookuptable[2][4] = new Int2D(1, -1);
    lookuptable[3][4] = new Int2D(0, 0);
    
    lookuptable[0][5] = new Int2D(3, -1);
    lookuptable[1][5] = new Int2D(2, 0);
    lookuptable[2][5] = new Int2D(1, 2);
    lookuptable[3][5] = new Int2D(0, 5);
    
    lookuptable[0][6] = new Int2D(3, 1);
    lookuptable[1][6] = new Int2D(2, -1);
    lookuptable[2][6] = new Int2D(1, 6);
    lookuptable[3][6] = new Int2D(0, 2);
    
    lookuptable[0][7] = new Int2D(3, 7);
    lookuptable[1][7] = new Int2D(2, 3);
    lookuptable[2][7] = new Int2D(1, 1);
    lookuptable[3][7] = new Int2D(0, -1);
    
    return lookuptable;
  }
  
  String getDirectionStr(int dir)
  {
    switch (dir)
    {
    case 0:
      return "Right";
    case 1:
      return "Left";
    case 2:
      return "Bottom";
    case 3:
      return "Top";
    case 4:
      return "Right top";
    case 5:
      return "Right bottom";
    case 6:
      return "Left bottom";
    case 7:
      return "Left top";
    default:
    return "Not a direction";
    }
  }
  
  private String getNeighborCode(int direction)
  {
    Int2D[][] lookuptable = mkNeighborLUT();
    
    int locCodeLen = locationCode.length();
    char[] neighborLocCode = locationCode.toCharArray();
    int direction_state = direction; // left
    for (int level = locCodeLen-1; level >= 0; level--)
    {
      int quadrant_state = locationCode.charAt(level) - '0'; // 48 = ascii code for '0'
      Int2D temp = lookuptable[quadrant_state][direction_state];
      direction_state = temp.y;
      neighborLocCode[level] = char(48 + temp.x);
      if (direction_state == -1)
      {
        break;
      }
    }
    return String.valueOf(neighborLocCode);
  }
  
  private void addChildNeighbors(Quadtree neighbor, int direction)
  {
    if (!neighbor.subdivided)
    {
      neighbors.add(neighbor);
    }
    else
    {
        
      switch (direction)
      {
      case 0:
        // Right
        addChildNeighbors(neighbor.topleft, direction);
        addChildNeighbors(neighbor.botleft, direction);
        break;
      case 1:
        // Left neighbor
        addChildNeighbors(neighbor.topright, direction);
        addChildNeighbors(neighbor.botright, direction);
        break;
      case 2:
        // Bottom
        addChildNeighbors(neighbor.topleft, direction);
        addChildNeighbors(neighbor.topright, direction);
        break;
      case 3:
        // Top
        addChildNeighbors(neighbor.botright, direction);
        addChildNeighbors(neighbor.botleft, direction);
        break;
      case 4:
        // Right top
        addChildNeighbors(neighbor.botleft, direction);
        break;
      case 5:
        // Right bottom
        addChildNeighbors(neighbor.topleft, direction);
        break;
      case 6:
        // Left bottom
        addChildNeighbors(neighbor.topright, direction);
        break;
      case 7:
        // Left top
        addChildNeighbors(neighbor.botright, direction);
        break;
      default:
        break;
      }
    }
  }
  
  void mkNeighborList(boolean wrapEdge)
  {
    neighbors = new ArrayList<Quadtree>();

    // getting root node
    Quadtree root = parent;
    while (root.parent != null)
    {
      root = root.parent;
    }
    
    // iterating over the 8 directions
    for (int i = 0; i < 8; i++)
    {
      if (!wrapEdge)
      {
        // if the current direction wraps around edge, break the loop iteration.
      }
      String neighborCode = getNeighborCode(i);
      // iterate down root node to neighbor
      int neighborCodeLen = neighborCode.length();
      Quadtree neighbor = root;
      for (int j = 0; j < neighborCodeLen; j++)
      {
        if (neighbor.subdivided)
        {
          switch (neighborCode.charAt(j))
          {
          case '0':
            neighbor = neighbor.topleft;
            break;
          case '1':
            neighbor = neighbor.topright;
            break;
          case '2':
            neighbor = neighbor.botleft;
            break;
          case '3':
            neighbor = neighbor.botright;
            break;
          }
        }
        else
        {
          // If this code is reached, then the neighbor is not as deep as the target node.
          neighbors.add(neighbor);
          break;
        }
      }

      // here, either need to add neighbor to the neghbor list, or its children if its subdivided depending on the direction.
      addChildNeighbors(neighbor, i);
    }
    
    //println("\nLocation code:", locationCode);
    //println("Compute left (0) neighbor");
    //println(getDirectionStr(0), "neighbor location code:", getNeighborCode(0));
  }
};
