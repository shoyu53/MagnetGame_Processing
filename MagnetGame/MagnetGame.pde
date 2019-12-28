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
public Pole[][] pole=new Pole[down][right]; //SN極判定、奇数の時は赤、偶数の時は青
public float[][] pX=new float[down][right];
public float[][] pY=new float[down][right];
public Player player;
//public float magDis=150;
public float rot;

public float magCount;

void setup() {
  size(1200, 800);
  frameRate(60);
  //プレイヤーは赤青の磁石
  player=new Player(magX, magY);
  //障害物設定(ポール)
  for (int i=0; i<down; i++) {
    for (int j=0; j<right; j++) {
      fill(0, 0, 255);
      pole[i][j]=new Pole(poleX, poleY);
      pX[i][j]=pole[i][j].getX();
      pY[i][j]=pole[i][j].getY();
      poleX+=250;
      /*デバッグ*/
      //print(i, j, "X="+(pX[i][j]=pole[i][j].getX())+" Y=");
      //println(pY[i][j]=pole[i][j].getY());
    }
    poleX=50;
    poleY+=200;
  }
  poleX=50;
  poleY=100;
}

void draw() {
  background(255);

  //障害物描画
  for (int i=0; i<down; i++) {
    for (int j=0; j<right; j++) {
      pole[i][j].PoleDraw();
    }
  }
  //磁石描画
  player.magDraw();
}
