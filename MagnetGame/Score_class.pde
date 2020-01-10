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

  int getsumScore() {
    return sumScore;
  }


  void addScore() {

    //5秒たったらSCOREにボーナス追加
    if (5<(time.getTimeCount()/60)) {
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

  void scoreDraw() {
    fill(0);
    textSize(45);
    text("SCORE : "+sumScore, 850, 60);
    effectDraw();
  }

  void effectDraw() {
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
