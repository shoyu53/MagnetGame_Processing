class Player {

  private float magX;
  private float magY;
  private float magW=25;
  private float magH=50;
  private float magMoveX;
  private float magMoveY;
  private boolean magS;  //falseでN極
  private float unUsed;  //使わない極の色を薄くする
  private float rad;
  private float centerX, centerY;

  Player(float magX, float magY, float magW, float magH) {
    this.magX=magX;
    this.magY=magY;
    this.magW=magW;
    this.magH=magH;
    this.magMoveX=magX;
    this.magMoveY=magY;
    this.magS=true;
    this.unUsed=150;
  }

  //ここでプレイヤーの動きを司っているよ！
  void magDraw() {
    linkMP();
    magSet();
    if (move) {
      move();
    }
  }

  //移動地点まで線を引く
  void linkMP() {
    stroke(0, 255, 0, 50);
    strokeWeight(8);
    line(magX, magY, magMoveX, magMoveY);
    strokeWeight(1.5);
    stroke(0, 0, 0);
    translate(magX, magY);
    if (move) {
      rot+=PI/100;
      rotate(rot);
    }
  }

  //プレイヤーの設定
  void magSet() {
    if (magS==true) {
      //プレイヤーN極
      fill(255, 0, 0);
      rect(-magW/2, -magH, magW, magH);
      //プレイヤーS極
      fill(0, 0, 255, unUsed);
      rect(-magW/2, 0, magW, magH);
    } else {
      //プレイヤーN極
      fill(255, 0, 0, unUsed);
      rect(-magW/2, -magH, magW, magH);
      //プレイヤーS極
      fill(0, 0, 255);
      rect(-magW/2, 0, magW, magH);
    }

    if (keyPressed) {
      if (key=='s') {
        magS=true;
        if (debug)println("S極に設定");
      }
      if (key=='n') { 
        magS=false;
        if (debug)println("N極に設定");
      }
    }

    //移動地点登録
    if (mousePressed) {
      for (int k=0; k<down; k++) {
        for (int l=0; l<right; l++) {
          if (dis(mouseX, mouseY, pX[k][l], pY[k][l])<=poleD) { 
            magMoveX=pX[k][l];
            magMoveY=pY[k][l];
            //rad=atan2(magX, magY);
            println(rad);
            move=true;
          }
        }
      }
    }
  }

  //二点間の距離を計算
  float dis(float aX, float aY, float bX, float bY) {
    float distance=sqrt((aX-bX)*(aX-bX)+(aY-bY)*(aY-bY));
    return distance;
  }

  void move() {
    //異極時にプレイヤーをポールにくっつける
    float variation=6;        //移動距離(可読性のためにmovementではなくvariationにした)
    if (magS==true) {
      if (magX<magMoveX-variation) {
        magX+=variation;
      } else if (magMoveX<magX) {
        magX-=variation;
      }
      if (magY<magMoveY-variation) {
        magY+=variation;
      } else if (magMoveY<magY) {
        magY-=variation;
      }
      if (dis(magX, magY, magMoveX, magMoveY)<=poleD/2) {
        move=false;
        if (debug)println("X="+magX+" Y="+magY+"へ移動完了");
      }
    }
    //同極時にプレイヤーを回転&遠ざける
    if (magS==false) {      
      float leave=0.5;
      magX=magMoveX+(dis(magX, magY, magMoveX, magMoveY)+leave)*cos(rad);
      magY=magMoveY-(dis(magX, magY, magMoveX, magMoveY)+leave)*sin(rad);
      rad+=radians(1.5);
    }
  }
}
