public float magX=100;
public float magY=100;
public float magW=25;
public float magH=50;
public float poleX=50;
public float poleY=100;
public float magMoveX;
public float magMoveY;
final float poleD=50;
boolean move=false;
final int down=3;
final int right=5;
public Pole[][] pole=new Pole[down][right]; //N極S極判定奇数の時は赤、偶数の時は青
public float[][] pX=new float[down][right];
public float[][] pY=new float[down][right];
public float magDis=150;
public float rot;

void setup() {
  size(1200, 800);
  frameRate(60);
}

void draw() {
  background(255);

  //障害物設定(ポール)
  for (int i=0; i<down; i++) {
    for (int j=0; j<right; j++) {
      fill(0, 0, 255);
      pole[i][j]=new Pole(poleX, poleY);
      pole[i][j].PoleDraw();
      pX[i][j]=pole[i][j].getX();
      pY[i][j]=pole[i][j].getY();
      poleX+=200;

      /*デバッグ*/
      //print(i, j, "X="+(pX[i][j]=pole[i][j].getX())+" Y=");
      //println(pY[i][j]=pole[i][j].getY());
    }
    poleX=50;
    poleY+=200;
  }
  poleX=50;
  poleY=100;

  //プレイヤー設定
  //回転
  translate(magX,magY);
  rot+=PI/100;
  rotate(rot);
  //磁石上
  fill(255, 0, 0);
  rect(-magW/2,-magH,magW,magH);
  //磁石下
  fill(0,0,255);
  rect(-magW/2,0,magW,magH);

  //プレイヤーを動かす
  /*
  moveSet();
  if (move) {
    move();
  }
  */
}

void moveSet() {

  //クリックした地点に磁石があったらくっつく
  for (int k=0; k<down; k++) {
    for (int l=0; l<right; l++) {
      if ((sqrt(((magX-pX[k][l])*(magX-pX[k][l]))+((magY-pY[k][l])*(magY-pY[k][l]))))<=magDis) { //磁石とポールの距離が近ければ吸い寄せられる
        //移動地点登録
        magMoveX=pX[k][l];
        magMoveY=pY[k][l];
        move=true;
      }
    }
  }
}

void move() {
  //登録地点へ移動
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
  if ((magX==magMoveX)&&(magY==magMoveY))
    move=false;
}

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
    ellipse(pX, pY, poleD, poleD);
  }
}
