public float magX=70;
public float magY=70;
public float poleX=50;
public float poleY=100;
public float magMoveX;
public float magMoveY;
final float playerR=40;
final float poleR=45;
boolean move=false;
int down=4;
int right=4;
public Pole[][] pole=new Pole[down][right]; //N極S極判定奇数の時は赤、偶数の時は青
public float[][] pX=new float[down][right];
public float[][] pY=new float[down][right];


void setup() {
  size(750, 800);
  frameRate(60);
  noStroke();
}

void draw() {
  background(255);

  //障害物設定
  fill(0, 0, 255);
  for (int i=0; i<right; i++) {
    for (int j=0; j<down; j++) {
      pole[i][j]=new Pole(poleX,poleY);
      pole[i][j].PoleDraw();
      pX[i][j]=pole[i][j].getX();
      pY[i][j]=pole[i][j].getY();
      poleX+=200;
      
      /*デバッグ*/
      //print(i, j, "X="+(pX[i][j]=pole[i][j].getX())+" Y=");
      //println(pY[i][j]=pole[i][j].getY());
    }
    poleX=50;
    poleY+=150;
  }
  poleX=50;
  poleY=100;
  
  //プレイヤー設定
  fill(255, 0, 0);
  ellipse(magX, magY, playerR, playerR);

  //クリックした地点に磁石があったらくっつく
  for (int k=0; k<right; k++) {
    for (int l=0; l<down; l++) {
      if ((sqrt(((magX-pX[k][l])*(magX-pX[k][l]))+((magY-pY[k][l])*(magY-pY[k][l]))))<=150) { //磁石とポールの距離が近ければ吸い寄せられる
        //移動地点登録
        magMoveX=pX[k][l];
        magMoveY=pY[k][l];
        move=true;
      }
    }
  }
  if (move) {
    move();
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
  
  Pole(float pX,float pY){
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
    rect(pX, pY, poleR, poleR);
  }
}
