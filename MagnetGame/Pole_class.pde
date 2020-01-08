class Pole {

  private float pX,pY;
  private boolean poleS;

  Pole(float pX, float pY, boolean poleS) {
    this.pX=pX;
    this.pY=pY;
    this.poleS=poleS;
  }

  float getX() {
    return pX;
  }

  float getY() {
    return pY;
  }
  boolean getPoleS(){
    return poleS;
  }


  void PoleDraw() {
    if (poleS==true) {
      fill(0, 0, 255);
    } else {
      fill(255, 0, 0);
    }
    ellipse(pX, pY, poleD, poleD);
  }
}
