class Sand {

  //砂鉄を集めるとスコアが上がる

  private float sX, sY;
  private float sD;
  private float r, g, b;
  private boolean collision;
  private boolean possesion;
  private float pX;
  private float pY;

  Sand(float sX, float sY, float sD, float r, float g, float b) {    //x,y,d,
    this.sX=sX;
    this.sY=sY;
    this.sD=sD;
    this.r=r;
    this.g=g;
    this.b=b;
    this.collision=false;
    this.possesion=false;
  }

  void sandDraw() {

    if (possesion==false) {
      noStroke();
      fill(r, g, b);
      ellipse(sX, sY, sD, sD);
      collider();
      sandMove();
    }
  }

  void collider() {
    pX=player.get_magX();
    pY=player.get_magY();
    if (dis(pX, pY, sX, sY)<100) {
      collision=true;
    }
  }

  void sandMove() {
    pX=player.get_magX();
    pY=player.get_magY();
    if (collision==true) {
      float variation=8.5;
      if (sX<pX) {
        sX+=variation;
      } else if (pX<sX) {
        sX-=variation;
      }
      if (sY<pY) {
        sY+=variation;
      } else if (pY<sY) {
        sY-=variation;
      }
      if(dis(pX, pY, sX, sY)<10){
        possesion=true;
      }
    }
  }
}
