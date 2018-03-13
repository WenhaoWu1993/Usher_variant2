void bouncing() {
  for(int i = 0;i < cornerLength.length;i++) {
    cornerLength[i] += 1.5 * speeds[i];
    if(((targets[i][0] > targets[i][1] && cornerLength[i] > targets[i][0]) || (targets[i][0] < targets[i][1] && cornerLength[i] < targets[i][0])) && (speeds[i] * (targets[i][0] - targets[i][1]) > 0)) {
      speeds[i] *= -1;
    }
    if(speeds[i] * (targets[i][0] - targets[i][1]) < 0) {
      speeds[i] = 1.5 * 0.1 * (targets[i][1] - cornerLength[i]);
    }
  }
}

void updateSong() {
  int c = 0;
  for(boolean p : played) {
    if(p == false) c++;
  }
  if(c == 0) {
    for(int i = 0;i < fileNames.length;i++) {
      played[i] = false;
    }
  }
}