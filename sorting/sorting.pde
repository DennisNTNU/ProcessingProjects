//import processing.sound.*

//int j = floor(1279/2);
int j = 0;
int k = 0;
int least = 1000;

int l = 0;

int kay = 0; 

int[] arrayToSort = new int[1280];
Heap heap = new Heap(1200);

void setup(){
  size(1280, 720);
  background(0);
  
  for (int i = 0; i < 600; i++) {
    heap.add(int(random(720)));
  }
  heap.buildMaxHeap();
  
  for (int i = 0; i < 1280; i++) {
    arrayToSort[i] = int(random(720));
  }
  arrayToSort[0] = -1;
}

void draw(){
  delay(15);
  l++;
  background(0);
  /*
  heap.draw();
  if (l % 10 == 0) {
    println(heap.heapExtractMax());
    heap.insert(int(random(720)));
  }*/
  
  drawArray(arrayToSort, 1280);
  delay(10);
  //quicksort(arrayToSort, 0, 1279);
  //randomizedQuicksort(arrayToSort, 0, 1279);
  
  selectionSortStep(arrayToSort);
}

void drawArray(int[] A, int size){
  for (int i = 0; i < size; i++) {
    line(i, 720, i, 720 - A[i]);
    if (i == j) {
      stroke(255, 0, 0, 255);
      line(i, 720, i, 720 - A[i]);
      stroke(127);
    }
  }
}

void selectionSortStep(int[] arr){
  if (j < 1280) {
    least = 1000;
    for (int i = j; i < 1280; i++) {
      if(least > arr[i]){
        least = arr[i];
        k = i;
      }
    }
    arr[k] = arr[j];
    arr[j] = least;
    j++;
  }
}

void insertionSortStep(int[] arr){
  kay = arr[j + 1];
  int i = j;
  while (i >= 0 && arr[i] > kay) {
    arr[i + 1] = arr[i];
    i -= 1;
  }
  arr[i+1] = kay;
  j++;
}

void heapsortStep(int[] arr){
  int temp = arr[1];
  arr[1] = arr[j];
  arr[j] = temp;
  j--;
  maxHeapify(arr, j, 1);
}