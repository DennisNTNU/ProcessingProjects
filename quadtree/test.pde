void test_touching_function(Quadtree quadtree)
{
  if (quadtree.topleft != null &&
      quadtree.topright.botleft != null &&
      quadtree.botright.topleft != null && 
      quadtree.botright.topleft.topleft != null &&
      quadtree.botright.botleft.topleft != null &&
      quadtree.botleft.topright.topleft != null)
  {
    
    // checking if 12 toches:
    /*
     *   0, 11, 20, 23, 211, 212, 213, 31, 33, 300, 301, 303, 321, 322
     *   y,  y,  n,  n,   y,   n,   n,  y,  n,   y,   y,   n,   n,   n
     *
     *
     * +---------------+-------+-------+
     * |               |10     |11     |
     * |               |       |       |
     * |       0       +-------+-------+
     * |               |12     |13     |
     * |               |       |       |
     * +-------+---+---+---+---+-------+
     * |20     |210|211|300|301|31     |
     * |       +---+---+---+---+       |
     * |       |212|213|302|303|       |
     * +-------+---+---+---+---+-------+
     * |22     |23     |320|321|33     |
     * |       |       +---+---+       |
     * |       |       |322|323|       |
     * +-------+-------+---+---+-------+
     */
    quadtree.topright.botleft.printBoundry(); // 12

    quadtree.topleft.printBoundry(); // 0
    quadtree.topright.topright.printBoundry(); // 11
    quadtree.botleft.topleft.printBoundry(); // 20
    quadtree.botleft.botright.printBoundry(); // 23
    quadtree.botleft.topright.topright.printBoundry(); // 211
    quadtree.botleft.topright.botleft.printBoundry(); // 212
    quadtree.botleft.topright.botright.printBoundry(); // 213
    quadtree.botright.topright.printBoundry(); // 31
    quadtree.botright.botright.printBoundry(); // 33
    quadtree.botright.topleft.topleft.printBoundry(); // 300
    quadtree.botright.topleft.topright.printBoundry(); // 301
    quadtree.botright.topleft.botright.printBoundry(); // 303
    quadtree.botright.botleft.topright.printBoundry(); // 321
    quadtree.botright.botleft.botleft.printBoundry(); // 322


    print("12 touching 0?");
    if (quadtree.touching(quadtree.topright.botleft.bdry, quadtree.topleft.bdry))
    {
      println(" yes");
    }
    else
    {
      println(" no");
    }
    print("12 touching 11?");
    if (quadtree.touching(quadtree.topright.botleft.bdry, quadtree.topright.topright.bdry))
    {
      println(" yes");
    }
    else
    {
      println(" no");
    }
    print("12 touching 20?");
    if (quadtree.touching(quadtree.topright.botleft.bdry, quadtree.botleft.topleft.bdry))
    {
      println(" yes");
    }
    else
    {
      println(" no");
    }
    print("12 touching 23?");
    if (quadtree.touching(quadtree.topright.botleft.bdry, quadtree.botleft.botright.bdry))
    {
      println(" yes");
    }
    else
    {
      println(" no");
    }
    print("12 touching 211?");
    if (quadtree.touching(quadtree.topright.botleft.bdry, quadtree.botleft.topright.topright.bdry))
    {
      println(" yes");
    }
    else
    {
      println(" no");
    }
    print("12 touching 212?");
    if (quadtree.touching(quadtree.topright.botleft.bdry, quadtree.botleft.topright.botleft.bdry))
    {
      println(" yes");
    }
    else
    {
      println(" no");
    }
    print("12 touching 213?");
    if (quadtree.touching(quadtree.topright.botleft.bdry, quadtree.botleft.topright.botright.bdry))
    {
      println(" yes");
    }
    else
    {
      println(" no");
    }
    print("12 touching 31?");
    if (quadtree.touching(quadtree.topright.botleft.bdry, quadtree.botright.topright.bdry))
    {
      println(" yes");
    }
    else
    {
      println(" no");
    }
    print("12 touching 33?");
    if (quadtree.touching(quadtree.topright.botleft.bdry, quadtree.botright.botright.bdry))
    {
      println(" yes");
    }
    else
    {
      println(" no");
    }
    print("12 touching 300?");
    if (quadtree.touching(quadtree.topright.botleft.bdry, quadtree.botright.topleft.topleft.bdry))
    {
      println(" yes");
    }
    else
    {
      println(" no");
    }
    print("12 touching 301?");
    if (quadtree.touching(quadtree.topright.botleft.bdry, quadtree.botright.topleft.topright.bdry))
    {
      println(" yes");
    }
    else
    {
      println(" no");
    }
    print("12 touching 303?");
    if (quadtree.touching(quadtree.topright.botleft.bdry, quadtree.botright.topleft.botright.bdry))
    {
      println(" yes");
    }
    else
    {
      println(" no");
    }
    print("12 touching 321?");
    if (quadtree.touching(quadtree.topright.botleft.bdry, quadtree.botright.botleft.topright.bdry))
    {
      println(" yes");
    }
    else
    {
      println(" no");
    }
    print("12 touching 322?");
    if (quadtree.touching(quadtree.topright.botleft.bdry, quadtree.botright.botleft.botleft.bdry))
    {
      println(" yes");
    }
    else
    {
      println(" no");
    }
    
    
    
    
    print("300 touching 12?");
    if (quadtree.touching(quadtree.botright.topleft.topleft.bdry, quadtree.topright.botleft.bdry))
    {
      println(" yes");
    }
    else
    {
      println(" no");
    }
    print("301 touching 12?");
    if (quadtree.touching(quadtree.botright.topleft.topright.bdry, quadtree.topright.botleft.bdry))
    {
      println(" yes");
    }
    else
    {
      println(" no");
    }
    print("302 touching 12?");
    if (quadtree.touching(quadtree.botright.topleft.botleft.bdry, quadtree.topright.botleft.bdry))
    {
      println(" yes");
    }
    else
    {
      println(" no");
    }
    
    
    print("12 touching 31?");
    if (quadtree.touching(quadtree.topright.botleft.bdry, quadtree.botright.topright.bdry))
    {
      println(" yes");
    }
    else
    {
      println(" no");
    }
    print("12 touching 23?");
    if (quadtree.touching(quadtree.topright.botleft.bdry, quadtree.botleft.botright.bdry))
    {
      println(" yes");
    }
    else
    {
      println(" no");
    }
  }
}
