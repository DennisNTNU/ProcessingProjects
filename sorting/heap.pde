class Heap{
  int[] heap;
  int totalSize;
  int currentSize;
  int j;
  String changeOccured = "No";
  
  Heap(int n){
    heap = new int[n];
    for (int i = 0; i < n; i++) {
      heap[i] = -1;
    }
    totalSize = n;
    currentSize = 1;
  }
  
  void randomInit(int maxVal){
    for (int i = 0; i < totalSize; i++) {
      heap[i] = int(random(maxVal));
    }
    currentSize = totalSize;
  }
  
  void add(int value){
    if (currentSize + 1 < totalSize) {
      heap[currentSize++] = value;
    }else{
      println("Heap Overflow");
    }
  }
  
  int remove(int index){
    if (currentSize != 0) {
      int temp = heap[index];
      heap[index] = heap[currentSize--];
      maxHeapify(index);
      return temp;
    }else{
      println("Heap Underflow");
      return -1;
    }
  }
  
  int left(int i){
    return 2*i;
  }
  int right(int i){
    return 2*i + 1;
  }
  int parent(int i){
    return floor(i/2);
  }
  
  void maxHeapify(int i){
    int l = left(i);
    int r = right(i);
    int largest = 0;
    if (l < currentSize && heap[i] < heap[l]) {
      largest = l;
    }else{
      largest = i;
    } if (r < currentSize && heap[largest] < heap[r]) {
      largest = r;
    }
    if (largest != i) {
      changeOccured = "Yes";
      l = heap[i];
      heap[i] = heap[largest];
      heap[largest] = l;
      maxHeapify(largest);
    }
  }
  
  void buildMaxHeap(){
    for (int i = floor(currentSize/2); i >= 1; i--) {
      maxHeapify(i);
    }
    println("ChangeOccured", changeOccured);
    changeOccured = "No";
  }
  
  int heapMax(){
    return heap[1];
  }
  
  int heapExtractMax(){
    if (currentSize <= 0) {
      println("Heap Underflow");
      return -1;
    }else{
      int max = heap[1];
      heap[1] = heap[currentSize--];
      maxHeapify(1);
      return max;
    }
  }
  
  void heapIncreaseKey(int i, int keyy){
    if (keyy <= heap[i]) {
      println("Key is not bigger than the value already in heap");
    }else{
      heap[i] = keyy;
      int k = floor(i/2);
      while (i > 1 && heap[k] < heap[i]) {
        keyy = heap[k];
        heap[k] = heap[i];
        heap[i] = keyy;
        i = floor(i/2);
        k = floor(i/2);
      }
    }
  }
  
  void insert(int val){
    if (currentSize + 1 < totalSize) {
      heap[currentSize] = -2000000000;
      heapIncreaseKey(currentSize++, val);
    }else{
      println("Heap Overflow");
    }
  }
  
  void draw(){
    stroke(127);
    for (int i = 1; i < currentSize; i++) {
      line(i, 720, i, 720 - heap[i]);
    }
  }
  
  void heapifyInit(){ j = floor(currentSize/2); }
}

//-------------------------------------------------------------

void maxHeapify(int[] heap, int heapSize, int i){
  int l = 2*i;
  int r = 2*i + 1;
  int largest = 0;
  if (l < heapSize && heap[i] < heap[l]) {
    largest = l;
  }else{
    largest = i;
  } if (r < heapSize && heap[largest] < heap[r]) {
    largest = r;
  }
  if (largest != i) {
    l = heap[i];
    heap[i] = heap[largest];
    heap[largest] = l;
    maxHeapify(heap, heapSize, largest);
  }
}

void buildMaxHeap(int[] heap, int heapSize){
  for (int i = floor(heapSize/2); i >= 1; i--) {
    maxHeapify(heap, heapSize, i);
  }
  
}