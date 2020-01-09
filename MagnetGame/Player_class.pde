class Player {

  private float magX;
  private float magY;
  private float magW=25;
  private float magH=50;
  private float magMoveX;
  private float magMoveY;
  private boolean hitPoleS;
  private boolean magS;  //falseでN極
  private float unUsed;  //使わない極の色を薄くする
  private float rad;
  public float rot;
  private float leave;

  private boolean clockwise;
  private int pendulum_Count;
  private int pendulum_MaxTime;
  private boolean countReset;

  Player(float magX, float magY, float magW, float magH) {
    this.magX=magX;
    this.magY=magY;
    this.magW=magW;
    this.magH=magH;
    this.magMoveX=magX;
    this.magMoveY=magY;
    this.magS=true;
    this.unUsed=150;
    this.leave=0.5;
    this.clockwise=true;
    this.countReset=true;
  }
  float getMagX() {
    return magX;
  }
  float getMagY() {
    return magY;
  }

  //ここでプレイヤーの動きを司っているよ！
  void magDraw() {
    linkMP();
    magSet();
    //異極だとプレイヤーがポールに引きつけられる
    //同極だとプレイヤーがポールの周りを公転し徐々に離れていく
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
      fill(100, 0, 0, unUsed);
      rect(-magW/2, -magH, magW, magH);
      //プレイヤーS極
      fill(0, 0, 255);
      rect(-magW/2, 0, magW, magH);
    } else {
      //プレイヤーN極
      fill(255, 0, 0);
      rect(-magW/2, -magH, magW, magH);
      //プレイヤーS極
      fill(0, 0, 100, unUsed);
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
      for (int i=0; i<down; i++) {
        for (int j=0; j<right; j++) {
          if (dis(mouseX, mouseY, pX[i][j], pY[i][j])<=poleD) { 
            magMoveX=pole[i][j].getX();
            magMoveY=pole[i][j].getY();
            hitPoleS=pole[i][j].getPoleS();
            pole[i][j].setHitPole(true);   //今のところポール中心のSN表示に使っている

            //公転時の振り子設定
            if (magX<=magMoveX) {
              clockwise=true;
            } else {
              clockwise=false;
            }
            pendulum_Count=0;
            countReset=true;

            /*クリックされたプレイヤーが公転を開始するたびに公転の中心のポールが毎回変わるため、　　　*/
            /*そのままrad=0とすると、不自然な位置から回転を初めてしまう(瞬間移動してしまう）  　　　*/
            /*それを解決するためにクリックされたポールから見た、公転開始直前のプレイヤーの角度を　　　*/
            /*求めたかった。三角関数を使おうとしたががうまくいかなかったので(座標変換の影響？) 　　　*/
            /*下記の方法を採用した(もっといい方法があったらご教授ください)   　　　 　　     　　　*/

            //プレイヤーが公転するポールの位置が決まったら、プレイヤーの一周分の公転座標を取得
            //それと公転開始直前のプレイヤー座標との距離を比較し、一番距離が短い時の角度を登録
            //これによって、プレイヤーがワープすることなく自然に公転を始めることができる
            float distance_Min=1000;
            for (int inspect_Rad=0; inspect_Rad<20; inspect_Rad++) {
              float insX=magMoveX+(dis(magX, magY, magMoveX, magMoveY)+leave)*cos(inspect_Rad);
              float insY=magMoveY-(dis(magX, magY, magMoveX, magMoveY)+leave)*sin(inspect_Rad);

              if (dis(magX, magY, insX, insY)<distance_Min) {
                distance_Min=dis(magX, magY, insX, insY);
                rad=inspect_Rad;
              }
            }
            if (debug)println("角度"+rad+"から公転開始");
            move=true;
          }
          else{
            pole[i][j].setHitPole(false);
          }
        }
      }
    }
  }
  

  void move() {
    final float variation=6;        //移動距離(可読性のためにmovementではなくvariationにした)
    final int reduceSwing=7;        //振り子の揺れる時間減少

    //異極時にプレイヤーをポールにくっつける
    if (magS!=hitPoleS) {
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

    //同極時にプレイヤーを振り子のように公転&遠ざける
    if (magS==hitPoleS) {
      magX=magMoveX+(dis(magX, magY, magMoveX, magMoveY)+leave)*cos(rad);
      magY=magMoveY-(dis(magX, magY, magMoveX, magMoveY)+leave)*sin(rad);
      //振り子のように公転させる
      if (0<pendulum_MaxTime) {
        if (clockwise==true) {
          rad+=radians(1);
        } else {
          rad-=radians(1);
        }
      }

      //時計回りの時の振り子設定
      if (clockwise==true) {
        if (magX<=magMoveX) {
          pendulum_Count++;   //振り子の時間をはかる
          pendulum_MaxTime=pendulum_Count; //最下点までの時間を記録;
        } else if (countReset==true) {          
          pendulum_Count=0;
          countReset=false;
          pendulum_MaxTime-=reduceSwing;
        }
        //最下点後の折り返し
        pendulum_Wrap();
      }

      //反時計回りの振り子設定
      if (clockwise==false) {
        if (magMoveX<=magX) {
          pendulum_Count++;   //振り子の時間をはかる
          pendulum_MaxTime=pendulum_Count; //最下点までの時間を記録;
        } else if (countReset==true) {        
          pendulum_Count=0;
          countReset=false;
          pendulum_MaxTime-=reduceSwing;
        }
        //最下点後の折り返し
        pendulum_Wrap();
      }
    }
  }

  //振り子の最下点後の折り返し
  void pendulum_Wrap() {
    if ((countReset==false)&&(pendulum_Count<=pendulum_MaxTime)) {
      pendulum_Count++;
      if (pendulum_Count==pendulum_MaxTime) {
        clockwise=!clockwise;
        pendulum_Count=0;
        countReset=true;
      }
    }
  }
}
