class Pole {

  private float pX, pY;
  private boolean poleS;
  private boolean hitPole;

  Pole(float pX, float pY, boolean poleS) {
    this.pX=pX;
    this.pY=pY;
    this.poleS=poleS;
    this.hitPole=false;
  }

  float getX() {
    return pX;
  }

  float getY() {
    return pY;
  }
  boolean getPoleS() {
    return poleS;
  }
  void setHitPole(boolean hitPole) {
    this.hitPole=hitPole;
  }


  void poleDraw() {
    if (poleS==true) {
      fill(0, 0, 255);
    } else {
      fill(255, 0, 0);
    }
    ellipse(pX, pY, poleD, poleD);
    display();
  }

  //ポールの中心ににSN極を表示する
  void display() {
    if (hitPole==true) {
      if (poleS==true) {
        fill(255);
        textSize(30);
        text("S", pX-7, pY+11);
      } else {
        fill(255);
        textSize(30);
        text("N", pX-10, pY+11);
      }
    }
  }
}
