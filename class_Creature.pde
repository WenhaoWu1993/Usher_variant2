class Creature {
  float[] cornerLength = new float[6];
  float[] animationDistance = new float[6];
  float[] animationSpeed = new float[6];
  float cenX, cenY;
  
  Creature(float[] cornerLength_, float[] animationDistance_, float[] animationSpeed_, float cenX_, float cenY_) {
    cornerLength = cornerLength_;
    animationDistance = animationDistance_;
    animationSpeed = animationSpeed_;
    cenX = cenX_;
    cenY = cenY_;
  }
  
  void drawFinal() {
    float[] creatureShadow = new float[6];
    for(int i = 0;i < 6;i++) {
      creatureShadow[i] = cornerLength[i];
    }
    for(int i = 0;i < 16;i++) {
      for(int j = 0;j < 6;j++) {
        creatureShadow[j] -= map(cornerLength[j],30,200,0.2,0.4)*i;
      }
      stroke(255,255-i*255/15);
      strokeWeight(1);
      drawPolygon(creatureShadow);
    }
  }
  
  void drawPolygon(float[] Length) {
    pushMatrix();
    translate(cenX, cenY);
    noFill();
    curveTightness(0.1);
    beginShape();
    for(int i = 0;i < 6;i++) {
      float dx = 1.5 * cos(frameCount*animationSpeed[i]) * animationDistance[i] * cos(-i*PI/3);
      float dy = 1.5 * cos(frameCount*animationSpeed[i]) * animationDistance[i] * sin(-i*PI/3);
      curveVertex(Length[i] * sin(i * PI/3) + dx, Length[i] * cos(i * PI/3) + dy);
    }
    //repeat 1st, 2nd and 3rd points
    for(int i = 0;i < 3;i++) {
      float dx = 1.5 * cos(frameCount*animationSpeed[i]) * animationDistance[i] * cos(-i*PI/3);
      float dy = 1.5 * cos(frameCount*animationSpeed[i]) * animationDistance[i] * sin(-i*PI/3);
      curveVertex(Length[i] * sin(i * PI/3) + dx, Length[i] * cos(i * PI/3) + dy);
    }
    endShape();
    popMatrix();    
  } 
}