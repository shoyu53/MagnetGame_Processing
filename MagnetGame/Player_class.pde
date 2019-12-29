class Player {

  private float magX;
  private float magY;
  private float magMoveX;
  private float magMoveY;
  private boolean magS;  //falseでN極

  Player(float magX, float magY) {
    this.magX=magX;
    this.magY=magY;
    this.magMoveX=magX;
    this.magMoveY=magY;
    this.magS=true;
  }

  //ここでプレイヤーの動きを司っているよ！
  void magDraw() {
    linkMP();
    magSet();
    if (move) {
      move();
    }

    //プレイヤーN極
    fill(255, 0, 0, 100);
    rect(-magW/2, -magH, magW, magH);
    //プレイヤーS極
    fill(0, 0, 255, 100);
    rect(-magW/2, 0, magW, magH);
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

  //プレイヤーを動かす
  void move() {
    if (magX<magMoveX) {
      magX+=5;
    } else if (magMoveX<magX) {
      magX-=5;
    }
    if (magY<magMoveY) {
      magY+=5;
    } else if (magMoveY<magY) {
      magY-=5;
    }
    if ((magX==magMoveX)&&(magY==magMoveY)) {
      move=false;
      if (debug)println("X="+magX+" Y="+magY+"へ移動完了");
    }
  }
}
