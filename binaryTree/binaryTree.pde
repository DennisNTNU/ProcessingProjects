Node root;
Tree tree;

void setup() {
  size(800, 800);
  background(51);

  int[] data = {11, 34, 23, 54, 32, 69, 77, 45, 9, 45};

  root = new Node(10);

  Node node;
  node = root;

  Node newNode;

  boolean nodeAdded = false;

  for (int i = 0; i < data.length; i++) {
    node = root;
    newNode = new Node(data[i]);

    while (!nodeAdded) {

      if (node.val < newNode.val) {

        if (node.right == null) {
          node.right = newNode;
          nodeAdded = true;
        } else {
          node = node.right;
        }
      } else {
        if (node.left == null) {
          node.left = newNode;
          nodeAdded = true;
        } else {
          node = node.left;
        }
      }
    }
  }

  tree = new Tree();

  for (int i = 0; i < 20; i++) {
    tree.addValue(int(random(100)));
  }
  
  tree.traverse();
  
  node = tree.search(3);
  if (node != null) {
    println(node.val);
  } else {
    println(node);
  }
}

void draw() {
}