//set button status
void buttons() {
  for(int i = 0;i < 4;i++) {
    PVector pos = new PVector(width/2 - 250 + i * 500/3, height/2 + 330);
    stroke(255);
    if(buttonStatus[i] == 0){
      if(dist(mouseX, mouseY, pos.x, pos.y) < 22){
        fill(100);
      }else{
        fill(20);
      }  
    }else if(buttonStatus[i] == 1){
      fill(175);
    }
    ellipse(pos.x, pos.y, 35, 35);
    icons[i].disableStyle();
    noFill();
    stroke(255);
    shapeMode(CENTER);
    shape(icons[i], pos.x, pos.y, 30, 30);
  }
}

void mousePressed() {
  for(int i = 0;i < 4;i++) {
    PVector pos = new PVector(width/2 - 250 + i * 500/3, height/2 + 330);
    if(dist(mouseX, mouseY, pos.x, pos.y) < 22) {
      buttonStatus[i] = 1 - buttonStatus[i];
      if(i <= 1 && buttonStatus[i] == 1) {
        buttonStatus[3] = 0;
      }else if(i == 3 && buttonStatus[3] == 1) {
        buttonStatus[0] = 0;
        buttonStatus[1] = 0;
      }else if(i == 2 && buttonStatus[2] == 1) {
        buttonStatus[0] = 0;
        buttonStatus[1] = 0;
        buttonStatus[3] = 0;
      }
    }
  }
}

void mouseReleased() {  
  for(int i = 0;i < 6;i++) {
    if(tagStatus[i] > 0) {
      //"loop"
      if(dist(mouseX, mouseY, width/2 - 250, height/2 + 330) < 22) {
        targets[i][1] = cornerLength[i] + (2 * buttonStatus[0] - 1) * 10.0 * tagStatus[i] / 2.0;
        targets[i][0] = cornerLength[i] + (2 * buttonStatus[0] - 1) * 10.0 * 4 * tagStatus[i] / 2.0;
        speeds[i] = 1.5 * 2.1 * (targets[i][0] - cornerLength[i]) / abs(targets[i][0] - cornerLength[i]);
      }
      //"like"
      if(dist(mouseX, mouseY, width/2 - 250 + 500/3, height/2 + 330) < 22) {
        targets[i][1] = cornerLength[i] + (2 * buttonStatus[1] - 1) * 7.0 * tagStatus[i] / 2.0;
        targets[i][0] = cornerLength[i] + (2 * buttonStatus[1] - 1) * 7.0 * 4 * tagStatus[i] / 2.0;
        speeds[i] = 1.5 * 2.1 * (targets[i][0] - cornerLength[i]) / abs(targets[i][0] - cornerLength[i]);
      }
      //"skip"
      if(dist(mouseX, mouseY, width/2 - 250 + 2 * 500/3, height/2 + 330) < 22) {
        targets[i][1] = cornerLength[i] - skipWeight * 3 * tagStatus[i] / 2.0;
        targets[i][0] = cornerLength[i] - skipWeight * 3 * 4 * tagStatus[i] / 2.0;
        speeds[i] = 1.5 * 2.1 * (targets[i][0] - cornerLength[i]) / abs(targets[i][0] - cornerLength[i]);
      }
      //"dislike"
      if(dist(mouseX, mouseY, width/2 - 250 + 3 * 500/3, height/2 + 330) < 22) {
        targets[i][1] = cornerLength[i] + (1 - 2 * buttonStatus[3]) * 7.0 * tagStatus[i] / 2.0;
        targets[i][0] = cornerLength[i] + (1 - 2 * buttonStatus[3]) * 7.0 * 4 * tagStatus[i] / 2.0;
        speeds[i] = 1.5 * 2.1 * (targets[i][0] - cornerLength[i]) / abs(targets[i][0] - cornerLength[i]);
      }
    }
  }
  if(dist(mouseX, mouseY, width/2 - 250 + 2 * 500/3, height/2 + 330) < 22) {
    start = true;
    loop = false;
    buttonStatus[2] = 1 - buttonStatus[2];
    //calculate the factors
    for(int i = 0;i < factors.length;i++) {
      float factor = 0;
      for(int j = 0;j < 6;j++) {
        factor += tagValues[i][j] * targets[j][1];
      }
      factors[i] = factor;
    }
    //get the largest factor and play
    for(int i = 1;i < factorsOrder.length;i++) {
      for(int j = 0;j < factorsOrder.length - i;j++) {
        if(factors[factorsOrder[j]] < factors[factorsOrder[j + 1]]) {
          int temp = factorsOrder[j];
          factorsOrder[j] = factorsOrder[j + 1];
          factorsOrder[j + 1] = temp;
        }
      }
    }
    int sel = 0;
    while(played[factorsOrder[sel]]) {
      sel++;
    }
    song.pause();
    song = minim.loadFile(fileNames[factorsOrder[sel]]);
    song.play();
    beginTime = millis();
    played[factorsOrder[sel]] = true;
  }
  //record behavior
  //loop
  if(dist(mouseX, mouseY, width / 2 - 250, height / 2 + 330) < 22) {
    loop = !loop;
    minute = (millis() / 1000) / 60;
    second = millis() / 1000 - minute * 60;
    String m = nf(minute, 2);
    String s = nf(second, 2);
    write.println("loop" + "," + m + ":" + s);
  }
  //like
  if(dist(mouseX, mouseY, width / 2 - 250 + 500 / 3, height / 2 + 330) < 22) {
    minute = (millis() / 1000) / 60;
    second = millis() / 1000 - minute * 60;
    String m = nf(minute, 2);
    String s = nf(second, 2);
    write.println("like" + "," + m + ":" + s);
  }
  //skip
  if(dist(mouseX, mouseY, width / 2 - 250 + 2 * 500 / 3, height / 2 + 330) < 22) {
    minute = (millis() / 1000) / 60;
    second = millis() / 1000 - minute * 60;
    String m = nf(minute, 2);
    String s = nf(second, 2);
    meta = song.getMetaData();
    String n = meta.title();
    String nam = meta.fileName();
    String[] nams = splitTokens(nam, "_.");
    String[] tags = new String[6];
    for(int i = 0;i < tags.length;i++) {
      tags[i] = nams[1].substring(i, i + 1);
    }
    String t = join(tags, ",");
    write.println("skip," + m + ":" + s + "," + t + "," + n);
  }
  //dislike
  if(dist(mouseX, mouseY, width / 2 - 250 + 3 * 500 / 3, height / 2 + 330) < 22) {
    minute = (millis() / 1000) / 60;
    second = millis() / 1000 - minute * 60;
    String m = nf(minute, 2);
    String s = nf(second, 2);
    write.println("dislike," + m + ":" + s);
  }
  //adjusting learning

  //end record
}

void keyPressed() {
  if(keyCode == ESC) {
    minute = (millis() / 1000) / 60;
    second = millis() / 1000 - minute * 60;
    String m = nf(minute, 2);
    String s = nf(second, 2);
    write.println("end," + m + ":" + s);
    write.flush();
    write.close();
  }
}
//end button status