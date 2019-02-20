class Graph {
  ArrayList<Node> nodes = new ArrayList<Node>();
  FloatList bfsQueue = new FloatList();
  FloatList dfsStack = new FloatList();
  int[][] array; //adjacency matrix (neighbor array)
  int[][] treeArray;
  boolean useTreeArray = false;
  boolean controlToDesPos = false;
  int size;
  float gravity = -10;
  int time = 0;
  
  Graph(){
    size = 0;
    array = null;
  }
  Graph(int n){
    size = n;
    for (int i = 0; i < n; i++) {
      nodes.add(new Node(100 + random(300), 100 + random(300), 8 + random(15), color(random(255), random(256), random(256), 255)));
    }
    array = new int[n][n];
    treeArray = new int[n][n];
    
    for (int i = 0; i < n; i++) {
      for (int j = i; j < n; j++) {
        array[i][j] = (int)(random(100.0) / 50.0);
        treeArray[i][j] = 0;
        if (i == j) {
          array[i][j] = 0;
        }
      }
      for (int j = 0; j < i; j++) {
        array[i][j] = array[j][i];
      }
    }
  }
  Graph(int n, int x, int y){
    size = n;
    for (int i = 0; i < n; i++) {
      nodes.add(new Node(100 + random(x - 200), 100 + random(y - 200), 20 + 0 * random(15), color(random(255), random(256), random(256), 255)));
    }
    array = new int[n][n];
    treeArray = new int[n][n];
    
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        array[i][j] = int(random(100.0) / (60.0 + size));
        if (array[i][j] != 0) {
          array[i][j] += int(random(10));
        }
        treeArray[i][j] = 0;
        if (i == j) {
          array[i][j] = 0;
        }
      }
    }
  }
  
  void initGridPoses(){
    int xd = 50;
    int yd = 50;
    int stage = 0;
    int a = 1;
    for (int i = 0; i < size; i++) {
      nodes.get(i).pos.xd = 300 + 2*xd;
      nodes.get(i).pos.yd = 2*yd;
      switch (stage) {
      case 0:
        yd = 50;
        xd += a*50;
        stage = 1;
        break;
      case 1:
        yd += 50;
        if (yd == xd) {
          stage = 2;
        }
        break;
      case 2:
        xd -= 50;
        if (xd == 50) {
          stage = 0;
          a++;
        }
        break;
      }
    }
  }
  
  void initTreePoses(){
    int root = -1;
    int maxDepth = getMaxDepth();
    
    //finding index for the root node of the spanning tree
    for (int i = 0; i < size; i++) {
      if (nodes.get(i).predecessor == 0 && nodes.get(i).depth == 0) {
        root = i;
      }
    }
    
    int[] nodesInEachDepth = new int[maxDepth + 1];
    int[] nodesFinishedInEachDepth = new int[maxDepth + 1];
    
    for (int i = 0; i < size; i++) {
      nodesInEachDepth[nodes.get(i).depth]++;
      nodesFinishedInEachDepth[nodes.get(i).depth] = 0;
    }
    
    FloatList stack = new FloatList();
    stack.append(root);
    int currentNode = -1;
    int treeWidth = width/3;
    int currentDepth = -1;
    
    //traversing the BFS spanning tree from the root down using a stack 
    while (stack.size() != 0) {
      //poping current element from stack
      currentNode = int(stack.get(stack.size() - 1));
      currentDepth = nodes.get(currentNode).depth;
      stack.remove(stack.size() - 1);
      
      //enqueueing all the childs of the current node on stack
      for (int i = 0; i < size; i++) {
        if (treeArray[currentNode][i] != 0 && nodes.get(i).depth > nodes.get(currentNode).depth) {
          stack.append(i);
        }
      }
      
      //setting x-position of the root node
      if (nodes.get(currentNode).predecessor == 0 && nodes.get(currentNode).depth == 0) {
        nodes.get(currentNode).pos.xd = width/2;
      }else{
        //setting x-positions of all other nodes
        nodes.get(currentNode).pos.xd = nodes.get(nodes.get(currentNode).predecessor).pos.xd 
                                        - treeWidth / (2*currentDepth + 1)
                                        + treeWidth * nodesFinishedInEachDepth[currentDepth] / (nodesInEachDepth[currentDepth] * currentDepth + 1)
                                        + treeWidth / (nodesInEachDepth[currentDepth] * currentDepth * 2 + 1);
      }
      //setting y-positions
      nodes.get(currentNode).pos.yd = 100 + 60 * currentDepth;
      
      nodesFinishedInEachDepth[currentDepth]++;
    }
    
    //setting positions of all the nodes in graph not covered by the spanning tree
    int i = 0;
    while (nodesInEachDepth[0] > 1) {
      if (nodes.get(i).depth == 0 && nodes.get(i).predecessor != 0) {
        nodes.get(i).pos.xd = 40;
        nodes.get(i).pos.yd = 700 - 46 * nodesInEachDepth[0]--;
      }
      i++;
    }
  }
  
  void initTopologicalSortPoses(){
    int numberOfNodesInDfs = 0;
    int numberOfNodesNotInDfs = 0;
    
    for (int i = 0; i < size; i++) {
      if (nodes.get(i).start != 0) {
        numberOfNodesInDfs++;
      }else{
        numberOfNodesNotInDfs++;
      }
    }
    
    int[] nodesInDfs = new int[numberOfNodesInDfs];
    int[] nodesNotInDfs = new int[numberOfNodesNotInDfs];
    
    int k = 0; int l = 0;
    for (int i = 0; i < size; i++) {
      if (nodes.get(i).start != 0) {
        nodesInDfs[k++] = i;
      }else{
        nodesNotInDfs[l++] = i;
      }
    }
    
    //sort the nodes after finish time in decresing order
    //via selection sort, for now
    int biggestFinishTime = 0;
    int biggestNodeIndex = 0;
    
    for (int i = 0; i < numberOfNodesInDfs; i++) {
      //finding node with biggest finish time
      for (int j = i; j < numberOfNodesInDfs; j++) {
        
        if (biggestFinishTime < nodes.get(nodesInDfs[j]).finish) {
          biggestFinishTime = nodes.get(nodesInDfs[j]).finish;
          biggestNodeIndex = j;
        }
      }
      //setting that node to the beginning of the unsorted part of the array
      
      //int temp = nodesInDfs[i];
      biggestFinishTime = nodesInDfs[i];
      nodesInDfs[i] = nodesInDfs[biggestNodeIndex];
      nodesInDfs[biggestNodeIndex] = biggestFinishTime;
    }
    
    //now that the nodes are sorted by decreasing finish time, set the positions of each node
    for (int i = 0; i < numberOfNodesInDfs; i++) {
      nodes.get(nodesInDfs[i]).pos.xd = width * (i + 1) / (numberOfNodesInDfs + 1);
      nodes.get(nodesInDfs[i]).pos.yd = height / 2 + height * sin(i) * sqrt(i) * pow(-1, i) / numberOfNodesInDfs;
      //nodes.get(nodesInDfs[i]).pos.yd = height / 2 + height * sin(i) * pow(-1, i) / numberOfNodesInDfs;
    }
    
    for (int i = 0; i < numberOfNodesNotInDfs; i++) {
      nodes.get(nodesNotInDfs[i]).pos.xd = width * (i + 1) / (numberOfNodesNotInDfs + 1);
      nodes.get(nodesNotInDfs[i]).pos.yd = 640;
    }
    
  }
    
  void initGridEdges(){
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        array[i][j] = 0;
      }
    }
    
    float largestSquareNumber = int(sqrt(size));
    int k = 0; int l = 1;
    int m = 0; int n = 1;
    
    for (int i = 2; i <= largestSquareNumber; i++) {
      m++;
      n++;
      for (int j = 0; j < i-1; j++) {
        array[k++][l++] = 1;
        array[m++][n++] = 1;
      }
      k--; l++;
      for (int j = 0; j < i-1; j++) {
        array[k++][l++] = 1;
        array[m++][n++] = 1;
      }
    }
    
    print(m, n);
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < i; j++) {
        array[i][j] = array[j][i];
      }
    }
  }
  
  void toggleArray(){
    useTreeArray = !useTreeArray;
  }
  void toggleUpdate(){
    for (int i = 0; i < size; i++) {
      nodes.get(i).pos.vx += random(40) - 20;
      nodes.get(i).pos.vy += random(40) - 20;
    }
    controlToDesPos = !controlToDesPos;
  }
  
  void drawEdge(int[][] adjMat, int i, int j){
    strokeWeight(1);
    //stroke(0);
    fill(0);
    
    //line if edge goes both ways
    if (adjMat[i][j] != 0 && adjMat[j][i] != 0) {
      strokeWeight(2);
      line(nodes.get(i).pos.x, nodes.get(i).pos.y, nodes.get(j).pos.x, nodes.get(j).pos.y);
      
      //drawing edge length/capacity
      text(str(adjMat[i][j]), (nodes.get(i).pos.x + nodes.get(j).pos.x)/2, (nodes.get(i).pos.y + nodes.get(j).pos.y)/2);
    //arrow if line goes one way
    }else if (adjMat[i][j] != 0) {
      
      int arrowheadSize = 8;
      float dx = nodes.get(j).pos.x - nodes.get(i).pos.x;
      float dy = nodes.get(j).pos.y - nodes.get(i).pos.y;
      float distance = sqrt(dx*dx + dy*dy);
      dx = dx / distance;
      dy = dy / distance;
      float t = 1 - nodes.get(j).r/(1.5 * distance);
      
      //drawing arrow-line
      line(nodes.get(i).pos.x, nodes.get(i).pos.y, nodes.get(i).pos.x + t*dx*distance, nodes.get(i).pos.y + t*dy*distance);
      
      //drawing arrow-head
      line(nodes.get(i).pos.x + t*dx*distance, nodes.get(i).pos.y + t*dy*distance, nodes.get(i).pos.x + t*dx*distance + arrowheadSize * (dy - dx)/sqrt(2), nodes.get(i).pos.y + t*dy*distance - arrowheadSize * (dx + dy)/sqrt(2));
      line(nodes.get(i).pos.x + t*dx*distance, nodes.get(i).pos.y + t*dy*distance, nodes.get(i).pos.x + t*dx*distance - arrowheadSize * (dx + dy)/sqrt(2), nodes.get(i).pos.y + t*dy*distance + arrowheadSize * (dx - dy)/sqrt(2));
      
      //drawing edge length/capacity
      text(str(adjMat[i][j]), nodes.get(i).pos.x + dx*distance/2, nodes.get(i).pos.y + dy*distance/2);
      
    }else if (adjMat[j][i] != 0) {
      
      int arrowheadSize = 8;
      float dx = nodes.get(i).pos.x - nodes.get(j).pos.x;
      float dy = nodes.get(i).pos.y - nodes.get(j).pos.y;
      float distance = sqrt(dx*dx + dy*dy);
      dx = dx / distance;
      dy = dy / distance;
      float t = 1 - nodes.get(i).r/(1.5 * distance);
      
      line(nodes.get(j).pos.x, nodes.get(j).pos.y, nodes.get(j).pos.x + t*dx*distance, nodes.get(j).pos.y + t*dy*distance);
      
      line(nodes.get(j).pos.x + t*dx*distance, nodes.get(j).pos.y + t*dy*distance, nodes.get(j).pos.x + t*dx*distance + arrowheadSize * (dy - dx)/sqrt(2), nodes.get(j).pos.y + t*dy*distance - arrowheadSize * (dx + dy)/sqrt(2));
      line(nodes.get(j).pos.x + t*dx*distance, nodes.get(j).pos.y + t*dy*distance, nodes.get(j).pos.x + t*dx*distance - arrowheadSize * (dx + dy)/sqrt(2), nodes.get(j).pos.y + t*dy*distance + arrowheadSize * (dx - dy)/sqrt(2));
      
      //drawing edge length/capacity
      text(str(adjMat[j][i]), nodes.get(j).pos.x + dx*distance/2, nodes.get(j).pos.y + dy*distance/2);
    }
  }
  
  void draww(){
    stroke(0, 0, 0, 255);
    for (int i = 0; i < size; i++) {
      for (int j = i; j < size; j++) {
        if (useTreeArray) {
          drawEdge(treeArray, i, j);
        } else {
          drawEdge(array, i, j);
        }
      }
    }
    
    for (int i = 0; i < size; i++) {
      nodes.get(i).draww(i);
    }
  }
  
  void update(float dt, float t){
    for (int i = 0; i < size; i++) {
      
      if (controlToDesPos) {
        nodes.get(i).updateDesPos(dt);
      }else{
        float Fx = 0;
        float Fy = 0;
      
        for (int j = 0; j < size; j++) {
          float ix = nodes.get(i).pos.x;
          float iy = nodes.get(i).pos.y;
          float jx = nodes.get(j).pos.x;
          float jy = nodes.get(j).pos.y;
          
          float d = sqrt( (ix - jx) * (ix - jx) + (iy - jy) * (iy - jy) ); //distance between node i and j
          
          float unitx = (ix - jx) / (d + 0.0001);
          float unity = (iy - jy) / (d + 0.0001);
          
          if (d < 40.0) {
            Fx += 57 * unitx / (abs(d) + 0.01);
            Fy += 57 * unity / (abs(d) + 0.01);
          }
          
          if (useTreeArray) {
            if (treeArray[i][j] != 0 || treeArray[j][i] != 0) {
              //linear spring force
              //Fx -= unitx * (d - 200);
              //Fy -= unity * (d - 200);
              //power of 1.5 spring force
              Fx -= unitx * (d - 200) * sqrt(abs(d - 200));
              Fy -= unity * (d - 200) * sqrt(abs(d - 200));
              //square spring force
              //Fx -= unitx * (d - 200) * (d - 200) * (d - 200) / abs(d - 200);
              //Fy -= unity * (d - 200) * (d - 200) * (d - 200) / abs(d - 200);
              //cubic spring force
              //Fx -= unitx * (d - 200) * (d - 200) * (d - 200);
              //Fy -= unity * (d - 200) * (d - 200) * (d - 200);
            }
          }else{
            if (array[i][j] != 0 || array[j][i] != 0) {
              //linear spring force
              //Fx -= unitx * (d - 200);
              //Fy -= unity * (d - 200);
              //power of 1.5 spring force
              Fx -= unitx * (d - 200) * sqrt(abs(d - 200));
              Fy -= unity * (d - 200) * sqrt(abs(d - 200));
              //square spring force
              //Fx -= unitx * (d - 200) * (d - 200) * (d - 200) / abs(d - 200);
              //Fy -= unity * (d - 200) * (d - 200) * (d - 200) / abs(d - 200);
              //cubic spring force
              //Fx -= unitx * (d - 200) * (d - 200) * (d - 200);
              //Fy -= unity * (d - 200) * (d - 200) * (d - 200);
            }
          }
        }
        
        Fx -= 0.9 * nodes.get(i).pos.vx;
        Fy -= 0.9 * nodes.get(i).pos.vy - gravity;
        
        nodes.get(i).update(Fx, Fy, dt);
        
        float r = nodes.get(i).r / 2;
        if(nodes.get(i).pos.y + r > 720){
          nodes.get(i).pos.y = 720 - r;
          nodes.get(i).pos.vy *= -1;
        }else if (nodes.get(i).pos.y - r < 0) {
          nodes.get(i).pos.y = r;
          nodes.get(i).pos.vy *= -1;
        }
        
        if(nodes.get(i).pos.x - r < 0){
          nodes.get(i).pos.x = r;
          nodes.get(i).pos.vx *= -1;
        }else if (nodes.get(i).pos.x + r > 1280) {
          nodes.get(i).pos.x = 1280 - r;
          nodes.get(i).pos.vx *= -1;
        }
      }
    }
  }
  
  void initBfs(){
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        treeArray[i][j] = 0;
      }
      nodes.get(i).rgba = #FFFFFF;
      nodes.get(i).predecessor = -1;
      //nodes.get(i).depth = 2147483647; //max values storable in an signed int
      //nodes.get(i).depth = -1;
      nodes.get(i).depth = 0;
    }
    bfsQueue.clear();
    int i = (int)random(size);
    nodes.get(i).rgba = #888888;
    nodes.get(i).predecessor = 0;
    nodes.get(i).depth = 0;
    bfsQueue.append(i);
  }

  void nextBfsStep(){
    /* Unknown node: White, #FFFFFF
     * Discovered and enqueued: Grey, #888888
     * Dequeued: Black, #000000
     */
    
    //getting first node in queue
    if (bfsQueue.size() != 0) {
      int currentNode = int(bfsQueue.get(0));
      //iterating through every other node
      for (int i = 0; i < size; i++) {
        //if the node is a neighbor and has not been seen before,
        if (array[currentNode][i] != 0 && nodes.get(i).rgba == #FFFFFF) {
          //add it to the queue,
          bfsQueue.append(i);
          //and set its color to "in queue" (grey).
          nodes.get(i).rgba = #888888;
          nodes.get(i).depth = nodes.get(currentNode).depth + 1;
          nodes.get(i).predecessor = currentNode;
          
          treeArray[currentNode][i] = array[currentNode][i];
          //treeArray[i][currentNode] = 1;
        }
      }
      //set the first node in queue to visited
      nodes.get(currentNode).rgba = #000000;
      //and remove it from the queue
      bfsQueue.remove(0);
      println("Node ID: ", currentNode, " Node Depth: ", int(nodes.get(currentNode).depth), " Node Predecessor ID: ", int(nodes.get(currentNode).predecessor));
    }
    
    if (bfsQueue.size() == 0) {
      println("bfs Finished");
      //printTreeArray();
      colorNodesByDepth();
    }
  }
  
  void initDfs(){
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        treeArray[i][j] = 0;
      }
      nodes.get(i).rgba = #ffffff;
      nodes.get(i).predecessor = -1;
      nodes.get(i).start = 0;
      nodes.get(i).finish = 0;
    }
    time = 0;
  }
  
  void dfs(){
    initDfs();
    dfsvisit(int(random(size)));
  }
  
  void dfsvisit(int currentNode) {
    time += 1;
    nodes.get(currentNode).start = time;
    nodes.get(currentNode).rgba = #888888;
    for (int i = 0; i < size; i++) {
      if (array[currentNode][i] != 0) {
        if (nodes.get(i).rgba == #ffffff) {
          nodes.get(i).predecessor = currentNode;
          
          treeArray[currentNode][i] = array[currentNode][i];
          
          dfsvisit(i);
        }
      }
    }
    nodes.get(currentNode).rgba = #000000;
    time += 1;
    nodes.get(currentNode).finish = time;
  }
  
  // dfs implemented using no recursion and a stack. possible?
  void dfsStack(){
    dfsStack.append(int(random(size)));
    
    int currentNode = -1;
    
    while(dfsStack.size() != 0){
      currentNode = int(dfsStack.get(int(dfsStack.size() - 1)));
      dfsStack.remove(int(dfsStack.size() - 1));
      
      nodes.get(currentNode).rgba = 
      nodes.get(currentNode).start = ++time;
      
      //while not iterated through alle possible neighbors and not yet found a new neighbor
        //try to find a new neighbor
        //if found, set a variable to true
        
      //if variable == true, push the new neighbor on stack
      //it not true, pop current node off stack
      
      
      nodes.get(currentNode).finish = ++time;
      
    }
  }
  
  void printArray(){
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        //array[i][j] = i+j;
        print(array[i][j], "  ");
      }
      println("");
    }
  }
  void printTreeArray(){
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        //array[i][j] = i+j;
        print(treeArray[i][j], "  ");
      }
      println("");
    }
  }
  void colorNodesByDepth(){
    int maxDepth = getMaxDepth();
    int greyscale = 0;
    for (int i = 0; i < size; i++) {
      //greyscale = 255 * (maxDepth - nodes.get(i).depth) / maxDepth;
      greyscale = 205 * nodes.get(i).depth / (maxDepth + 1) + 20;
      nodes.get(i).rgba = color(greyscale,greyscale,greyscale,255);
    }
  }
  
  int getMaxDepth(){
    int maxDepth = 0;
    for (int i = 0; i < size; i++) {
      if (maxDepth < nodes.get(i).depth) {
        maxDepth = nodes.get(i).depth;
      }
    }
    
    return maxDepth;
  }
}

void test(){
  println("works");
}