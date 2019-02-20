class Node {
  Node left = null;
  Node right = null;
  int val;
  float x;
  float y;

  Node(int val_) {
    val = val_;
  }

  void addNode(Node n) {
    if (n.val < val) {
      if (left == null) {
        left = n;
        left.x = x - width/(4*pow(2, (y - 16) / 40));
        left.y = y + 40;
      } else {
        left.addNode(n);
      }
    } else if (n.val > val) {
      if (right == null) {
        right = n;
        right.x = x + width/(4*pow(2, (y - 16) / 40));
        right.y = y + 40;
      } else {
        right.addNode(n);
      }
    }
  }

  void visit() {
    if (left != null) {
      left.visit();
      stroke(255);
      line(x, y, left.x, left.y-10);
    }
    println(val);
    stroke(255);
    noFill();
    ellipse(x, y-6.25, 25, 25);
    fill(255);
    noStroke();
    textAlign(CENTER);
    text(val, x, y);
    if (right != null) {
      right.visit();
      stroke(255);
      line(x, y, right.x, right.y-10);
    }
  }

  Node search(int val_) {
    if (val == val_) {
      //println("Found ", val);
      return this;
    } else if (val_ < val && left != null) {
      return left.search(val_);
    } else if (val_ > val && right != null) {
      return right.search(val_);
    }
    return null;
  }
}