import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class MagnetGame extends PApplet {


/*ゲーム名: MagneTen */

/*ルール*/
//磁石を動かし、砂鉄を集めて得点を獲得！
//制限時間以内に砂鉄をたくさん集めてスコアハイスコアを目指そう！
//制限時間10秒、砂鉄100個、砂鉄1個で100pt
//13000pt<=Sランク,10000<=Aランク,7000<=Bランク,5000<=Cランク,その他 = Dランク

/*操作方法*/
//画面上のポールをクリックすると磁石が動きます。
//磁石とポールの磁極によって磁石の動き方が変わります。
//赤がN極、青がS極になります。
//(同じ極だと引きつけあい、　極が違うと反発し合いながら振り子のような動きをします)
//キーボードのSキー,Nキーを押すと磁石のS極,N極を切り替えられることができます！

/*細かい要素*/
//スコアが5000ptを超えると制限時間が5秒プラスされます
//ゲーム開始から5秒が経過すると砂鉄獲得時の得点が2倍(200pt)になります

/*制作: 醤油 (Twitter 醤油@53kcal4) */


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

public Result  result;

/*デバッグモード*/
public boolean debug=true;

public void setup() {
  
  frameRate(60);
  //集めるとスコアが上がる砂鉄の設定
  for (int i=0; i<sandN; i++) {
    //x,y,d,r,g,b
    sand[i]=new Sand(random(10, 1190), random(100, 790), random(6, 13), random(100, 256), random(100, 256), random(100, 200));
  }

  score=new Score(100, 100);  //nomalPoint,bonasPoint

  if (debug) {
    println(sandN+"個の砂鉄の設置完了");
    println();
  }

  //プレイヤーは赤青の磁石
  player=new Player(550, 400, 25, 50);     //(x,y,w,h)

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
  result=new Result();
}

public void draw() {
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
  if (result.getGameover()==false) {
    score.scoreDraw();
  }

  //制限時間描画
  time.timeDraw();

  //リザルト画面描画
  if (result.getGameover()==true) {
    result.resultDraw();
  }

  if (result.getGameover()==false) {
    //プレイヤー描画
    player.magDraw();
  }
}

//二点間の距離を計算
public float dis(float aX, float aY, float bX, float bY) {
  float distance=sqrt((aX-bX)*(aX-bX)+(aY-bY)*(aY-bY));
  return distance;
}
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
    this.leave=0.7f;
    this.clockwise=true;
    this.countReset=true;
  }
  public float getMagX() {
    return magX;
  }
  public float getMagY() {
    return magY;
  }

  //ここでプレイヤーの動きを司っているよ！
  public void magDraw() {
    linkMP();
    magSet();
    //異極だとプレイヤーがポールに引きつけられる
    //同極だとプレイヤーがポールの周りを公転し徐々に離れていく
    if (move) {
      move();
    }
  }

  //移動地点まで線を引く
  public void linkMP() {
    stroke(0, 255, 0, 50);
    strokeWeight(8);
    line(magX, magY, magMoveX, magMoveY);
    strokeWeight(1.5f);
    stroke(0, 0, 0);
    translate(magX, magY);
    if (move) {
      rot+=PI/100;
      rotate(rot);
    }
  }

  //プレイヤーの設定
  public void magSet() {
    if (magS==true) {
      //プレイヤーN極
      fill(200, 50, 0, unUsed);
      rect(-magW/2, -magH, magW, magH);
      //プレイヤーS極
      fill(0, 50, 255);
      rect(-magW/2, 0, magW, magH);
    } else {
      //プレイヤーN極
      fill(255, 0, 0);
      rect(-magW/2, -magH, magW, magH);
      //プレイヤーS極
      fill(0, 50, 100, unUsed);
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
  

  public void move() {
    final float variation=8;        //同極時の移動距離(可読性のためにmovementではなくvariationにした)
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
  public void pendulum_Wrap() {
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
class Pole {

  private float pX, pY;
  private boolean poleS;
  private boolean hitPole;

  Pole(float pX, float pY, boolean poleS) {
    this.pX=pX;
    this.pY=pY;
    this.poleS=poleS;
    this.hitPole=false;
  }

  public float getX() {
    return pX;
  }

  public float getY() {
    return pY;
  }
  public boolean getPoleS() {
    return poleS;
  }
  public void setHitPole(boolean hitPole) {
    this.hitPole=hitPole;
  }


  public void poleDraw() {
    if (poleS==true) {
      fill(0, 50, 255);
    } else {
      fill(255, 0, 0);
    }
    ellipse(pX, pY, poleD, poleD);
    display();
  }

  //ポールの中心ににSN極を表示する
  public void display() {
    if (hitPole==true) {
      if (poleS==true) {
        fill(255);
        textSize(30);
        text("S", pX-7, pY+11);
      } else {
        fill(255);
        textSize(30);
        text("N", pX-10, pY+11);
      }
    }
  }
}
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

  public void sandDraw() {

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

  public void collider() {
    pX=player.getMagX();
    pY=player.getMagY();
    if (dis(pX, pY, sX, sY)<110) {
      collision=true;
    }else{
      collision=false;
    }
  }

  public void sandMove() {
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
class Score {

  private int sumScore;
  private int point;
  private int nomalPoint;
  private int bonasPoint;
  private boolean[] scoreEffect=new boolean[sandN];
  //砂鉄獲得エフェクトを表示させた回数を記録
  private int effectNum;
  //砂鉄獲得エフェクトを表示させる時間
  private int[] countDown_EffectTime= new int[sandN];
  //砂鉄獲得時のプレイヤーの位置を記録
  private float[] pX=new float[sandN];
  private float[] pY=new float[sandN];
  //スコアアップ中のテキスト表示エフェクト用
  private float bonasEffect;
  private boolean bonasActive;

  //もちろん最初は0点スタート
  Score(int nomalPoint, int bonasPoint) {
    this.sumScore=0;
    this.nomalPoint=nomalPoint;
    this.point=this.nomalPoint;
    this.bonasPoint=bonasPoint;
    for (int i=0; i<scoreEffect.length; i++) {
      this.scoreEffect[i]=false;
      this.countDown_EffectTime[i]=60;   
      //60fだからcountDown_EffectTime[i]=90のときは60/60=1秒間のカウントダウン
      this.pX[i]=0;
      this.pY[i]=0;
    }
    this.effectNum=0;
    this.bonasEffect=0;
    this.bonasActive=true;
  }

  public int getsumScore() {
    return sumScore;
  }


  public void addScore() {

    //5秒たったらSCOREにボーナス追加
    if (5<=(time.getTimeCount()/60)) {
      point=nomalPoint+bonasPoint;
    }
    sumScore+=point;

    //砂鉄を獲得してからカウントダウンが0になるまでエフェクトを表示させる
    scoreEffect[effectNum]=true;
    pX[effectNum]=player.getMagX();
    pY[effectNum]=player.getMagY();
    if (effectNum<sandN) {
      effectNum++;
    }

    if (debug) {
      println("スコア="+sumScore);
    }
  }

  public void scoreDraw() {
    fill(0);
    textSize(45);
    text("SCORE : "+sumScore, 850, 60);
    effectDraw();
  }

  public void effectDraw() {
    for (int i=0; i<scoreEffect.length; i++) {
      if (scoreEffect[i]==true) {
        countDown_EffectTime[i]--;
        if (0<countDown_EffectTime[i]) {
          //エフェクト表示
          fill(255, 50, 0, countDown_EffectTime[i]*(255/60));
          textSize(18);
          text("+"+point, pX[i], pY[i]);
        } else {
          //カウントダウンが0になったらエフェクトの表示を止める
          scoreEffect[i]=false;
        }
      }
    }

    //スコアアップ中にテキスト表示
    if (point==nomalPoint+bonasPoint) {
      fill(255, 10, 0, bonasEffect);
      textSize(45);
      text("SCORE UP", 30, 55);
      if (bonasActive==true) {
        if (bonasEffect<=245) {
          bonasEffect+=5;
        } else {
          bonasActive=false;
        }
      }
      if (bonasActive==false) {
        if (10<=bonasEffect) {
          bonasEffect-=5;
        } else {
          bonasActive=true;
        }
      }
    }
  }
}
class Time {

  private int timeLimit;              //制限時間
  private int timeCount;              //フレームカウント
  private int remainingTime;          //残り時間
  private boolean notAddTimeLimit;    //一度だけ時間追加をするためのbool変数
  private int addTimeEffect;          //時間追加時のエフェクトを表示させる時間
  private float timeEffectY;          //時間追加時のエフェクトの位置調整 

  Time(int timeLimit) {
    this.timeLimit=timeLimit;
    this.timeCount=0;
    this.remainingTime=this.timeLimit;
    this.notAddTimeLimit=true;
    this.addTimeEffect=90;
    this.timeEffectY=0;
  }

  public int getTimeCount() {
    return timeCount;
  }
  public int getRemaingTime() {
    return remainingTime;
  }

  public void timeDraw() {
    addTimeLimit();
    fill(0);
    textSize(68);
    if (remainingTime<=3) {
      fill(255, 50, 0);
    }
    text(remainingTime, 560, 75);
    timeCount++;
    //制限時間を減らしていく
    if (remainingTime>0) {
      remainingTime=timeLimit-(timeCount/60);
    }else
    {
      result.setGameover(true);
    }
    //時間追加時のエッフェクト
    if (notAddTimeLimit==false) {
      addTimeEffectDraw();
      addTimeEffect--;
      timeEffectY-=0.5f;
    }
  }

  //スコアが5000ptを超えたら制限時間を5秒追加
  public void addTimeLimit() {
    if (notAddTimeLimit==true) {
      if (5000<score.sumScore) {
        timeLimit+=5;
        notAddTimeLimit=false;
      }
    }
  }
  //制限時間追加時のエフェクト描画
  public void addTimeEffectDraw() {
    fill(255, 0, 0, addTimeEffect*(255/90));
    textSize(68);
    text("+5", 600, 75+timeEffectY);
  }
}
class Result {
  private int resultScore;
  private int rankEffect;
  private boolean gameover;

  Result() {
    this.resultScore=0;
    this.rankEffect=0;
    this.gameover=false;
  }

  //Timeクラスでgameover=trueを設定
  public void setGameover(boolean gameover) {
    this.gameover=gameover;
  }

  public boolean getGameover() {
    return gameover;
  }


  public void resultDraw() {
    fill(255, 0, 0);
    textSize(80);
    text("G A M E", 270, 300);
    fill(0, 0, 255);
    text("O V E R", 630, 300);
    fill(0);
    text("SCORE : "+resultScore, 300, 500);

    if (resultScore<score.getsumScore()) {
      resultScore+=100;
      fill(255, 100, 0);
    } else {
      if (13000<=resultScore) {
        fill(225, 209, 0, rankEffect);
        text("Rank       S", 350, 600);
      } else if (10000<=resultScore) {
        fill(255, 0, 0, rankEffect);
        text("Rank       A", 350, 600);
      } else if (7000<=resultScore) {
        fill(0, 255, 0, rankEffect);
        text("Rank       B", 350, 600);
      } else if (5000<=resultScore) {
        fill(0, 100, 200, rankEffect);
        text("Rank       C", 350, 600);
      } else {
        fill(100, 100, 100, rankEffect);
        text("Rank       D", 350, 600);
      }
      if (rankEffect<255) {
        rankEffect+=2;
      }
    }
  }
}
  public void settings() {  size(1200, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "MagnetGame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
