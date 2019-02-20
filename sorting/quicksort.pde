
int partition(int[] A, int p, int r){
  int pivot = A[r];
  int i = p - 1;
  int exchangeConst;
  for (int j = p; j <= r - 1; j++) {
    if (A[j] <= pivot) {
      //i++; exchange A[i] with A[j]
      exchangeConst = A[++i];
      A[i] = A[j];
      A[j] = exchangeConst;
    }
  }
  //exchange A[i+1] with A[r]
  exchangeConst = A[++i];
  A[i] = A[r];
  A[r] = exchangeConst;
  
  return i;
}

int randomizedPartition(int[] A, int p, int r){
  int exchangeConst;
  int pivotIndex = int(random(p + r) - p);
  
  exchangeConst = A[pivotIndex];
  A[pivotIndex] = A[r];
  A[r] = exchangeConst;
  
  int pivot = A[r];
  int i = p - 1;
  for (int j = p; j <= r - 1; j++) {
    if (A[j] <= pivot) {
      //i++; exchange A[i] with A[j]
      exchangeConst = A[++i];
      A[i] = A[j];
      A[j] = exchangeConst;
    }
  }
  //exchange A[i+1] with A[r]
  exchangeConst = A[++i];
  A[i] = A[r];
  A[r] = exchangeConst;
  
  return i;
}

void quicksort(int[] A, int p, int r){
  if (p < r) {
    int q = partition(A, p, r);
    quicksort(A, p, q-1);
    quicksort(A, q+1, r);
  }
}

void randomizedQuicksort(int[] A, int p, int r){
  if (p < r) {
    int q = randomizedPartition(A, p, r);
    quicksort(A, p, q-1);
    quicksort(A, q+1, r);
  }
}