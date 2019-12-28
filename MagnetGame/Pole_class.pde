class Pole {

  private float pX;
  private float pY;

  Pole(float pX, float pY) {
    this.pX=pX;
    this.pY=pY;
  }

  float getX() {
    return pX;
  }

  float getY() {
    return pY;
  }


  void PoleDraw() {
    fill(0, 0, 255);
    ellipse(pX, pY, poleD, poleD);
  }
}
