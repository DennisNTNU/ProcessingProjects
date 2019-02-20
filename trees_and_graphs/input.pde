

void keyPressed() {
  
  switch(key) {
  case '1':
    graf.initBfs();
    break;
  case '2':
    graf.nextBfsStep();
    break;
  case '3':
    graf.toggleArray();
    break;
  case '4':
    graf.toggleUpdate();
    break;
  case '5':
    graf.initGridEdges();
    break;
  case '6':
    graf.initGridPoses();
    break;
  case '7':
    graf.initTreePoses();
    break;
  case '8':
    graf.initTopologicalSortPoses();
    break;
    
  case 'q':
    graf.dfs();
    break;
    
  case 'u':
    doMotionUpdates = !doMotionUpdates;
    break;
  case 'g':
    if (graf.gravity == 0) {
      graf.gravity = -10;
    } else {
      graf.gravity = 0;
    }
    break;
  }
}