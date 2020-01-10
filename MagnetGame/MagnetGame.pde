
/*ゲーム名: MagneTen */

/*ルール*/
//磁石を動かし、砂鉄を集めて得点を獲得！
//制限時間以内に砂鉄をたくさん集めてスコアハイスコアを目指そう！
//制限時間10秒、砂鉄100個、砂鉄1個で100pt

/*操作方法*/
//画面上のポールをクリックすると磁石が動きます。
//磁石とポールの磁極によって磁石の動き方が変わります。
//赤がN極、青がS極になります。
//(同じ極だと引きつけあい、　極が違うと反発し合いながら振り子のような動きをします)
//キーボードのSキー,Nキーを押すと磁石のS極,N極を切り替えられることができます！

/*隠し要素*/
//スコアが5000ptを超えると制限時間が5秒プラスされます
//ゲーム開始から5秒が経過すると砂鉄獲得時の得点が2倍(200pt)になります


public float magX=100;
public float magY=100;
public float magW=25;
public float magH=50;

public float poleX=70;
public float poleY=150;
final float poleD=50;

public float magMoveX;
public float magMoveY;
public boolean move=false;

final int down=3;    //縦
final int right=5;   //横
public Pole[][] pole=new Pole[down][right]; //SN極判定、奇数の時は赤N、偶数の時は青S
public float[][] pX=new float[down][right];
public float[][] pY=new float[down][right];
public boolean[][] poleS=new boolean[down][right];
public Player player;

public int sandN=100;
public Sand[] sand=new Sand[sandN];
public Score score;

public Time time;


/*デバッグモード*/
public boolean debug=true;

void setup() {
  size(1200, 800);
  frameRate(60);
  //集めるとスコアが上がる砂鉄の設定
  for (int i=0; i<sandN; i++) {
    //x,y,d,r,g,b
    sand[i]=new Sand(random(10, 1190), random(100, 790), random(6, 13), random(100, 256), random(100, 256), random(100, 200));
  }

  score=new Score(100,100);  //nomalPoint,bonasPoint

  if (debug) {
    println(sandN+"個の砂鉄の設置完了");
    println();
  }

  //プレイヤーは赤青の磁石
  player=new Player(100, 100, 25, 50);     //(x,y,w,h)

  //障害物設定(ポール)
  if (debug) {  
    println("障害物の初期設定開始");
  }
  for (int i=0; i<down; i++) {
    for (int j=0; j<right; j++) {
      if (j%2==0) {
        pole[i][j]=new Pole(poleX, poleY, true); //x,y,SNのbool
      } else {
        pole[i][j]=new Pole(poleX, poleY, false);
      }
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
  if (debug) {
    println("障害物の初期設定完了");
  }

  //制限時間設定
  time=new Time(10);
}

void draw() {
  background(255);

  //障害物描画
  for (int i=0; i<down; i++) {
    for (int j=0; j<right; j++) {
      pole[i][j].poleDraw();
    }
  }

  //砂鉄描画
  for (int i=0; i<100; i++) {
    sand[i].sandDraw();
  }
  //スコア描画
  score.scoreDraw();

  //制限時間描画
  time.timeDraw();

  //プレイヤー描画
  player.magDraw();
}

//二点間の距離を計算
float dis(float aX, float aY, float bX, float bY) {
  float distance=sqrt((aX-bX)*(aX-bX)+(aY-bY)*(aY-bY));
  return distance;
}
