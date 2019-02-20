class Tree {
  Node root = null;

  Tree() {
  }

  void addValue(int val) {
    Node n = new Node(val);
    if (root == null) {
      root = n;
      root.x = width/2;
      root.y = 16;
    }else{
      root.addNode(n);
    }
  }
  
  void traverse(){
    root.visit();
  }
  
  Node search(int val){
    Node node = root.search(val);
    return node;
  }
  
}