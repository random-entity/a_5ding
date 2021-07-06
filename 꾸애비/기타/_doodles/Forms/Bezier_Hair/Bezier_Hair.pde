int N = 100;
size(500, 500);
noFill();
for (int i = 0; i < N; i+=10) {
  for (int j = 0; j < N; j+=10) {
    bezier(i,j,0,500,500-i,500-j,500,0);
  }
}
