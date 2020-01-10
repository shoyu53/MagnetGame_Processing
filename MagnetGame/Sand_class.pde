class Sand {

  //砂鉄を集めるとスコアが上がる

  private float sX, sY;
  private float sD;
  private float r, g, b;
  private boolean collision;
  private boolean active;
  private float pX;
  private float pY;
  private boolean addOnceScore;

  Sand(float sX, float sY, float sD, float r, float g, float b) {    //x,y,d,
    this.sX=sX;
    this.sY=sY;
    this.sD=sD;
    this.r=r;
    this.g=g;
    this.b=b;
    this.collision=false;
    this.active=true;
    this.addOnceScore=true;
  }

  void sandDraw() {

    if (active==true) {
      noStroke();
      fill(r, g, b);
      ellipse(sX, sY, sD, sD);
      collider();
      sandMove();
    }else if(addOnceScore){
      score.addScore();
      addOnceScore=false;
    }
  }

  void collider() {
    pX=player.getMagX();
    pY=player.getMagY();
    if (dis(pX, pY, sX, sY)<110) {
      collision=true;
    }else{
      collision=false;
    }
  }

  void sandMove() {
    pX=player.getMagX();
    pY=player.getMagY();
    if (collision==true) {
      float variation=8;
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
        active=false;
      }
    }
  }
}
