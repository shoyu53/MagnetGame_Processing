public float magX=100;
public float magY=100;
public float magW=25;
public float magH=50;
public float poleX=70;
public float poleY=150;
public float magMoveX;
public float magMoveY;
final float poleD=50;
public boolean move=false;
final int down=3;
final int right=5;
public Pole[][] pole=new Pole[down][right]; //SN極判定、奇数の時は赤N、偶数の時は青S
public float[][] pX=new float[down][right];
public float[][] pY=new float[down][right];
public boolean[][] poleS=new boolean[down][right];
public Player player;

/*デバッグモード*/
public boolean debug=true;

void setup() {
  size(1200, 800);
  frameRate(60);
  //プレイヤーは赤青の磁石
  player=new Player(100, 100, 25, 50);     //(x,y,w,h)
  //障害物設定(ポール)
  for (int i=0; i<down; i++) {
    for (int j=0; j<right; j++) {
      if (j%2==0) {
        pole[i][j]=new Pole(poleX, poleY, true); //x,y,SNのbool
      } else {
        pole[i][j]=new Pole(poleX, poleY, false);
      }
      pX[i][j]=pole[i][j].getX();
      pY[i][j]=pole[i][j].getY();
      poleS[i][j]=pole[i][j].getPoleS();
      poleX+=260;
      if (debug) {
        print(i, j, "X="+(pX[i][j]=pole[i][j].getX()));
        println(" Y="+(pY[i][j]=pole[i][j].getY()));
      }
    }
    poleX=70;
    poleY+=250;
    if (i==0) {
      poleX=200;
    }
  }
  println("障害物の初期設定完了");
}

void draw() {
  background(255);

  //障害物描画
  for (int i=0; i<down; i++) {
    for (int j=0; j<right; j++) {
      pole[i][j].PoleDraw();
    }
  }
  //プレイヤー描画
  player.magDraw();
}
