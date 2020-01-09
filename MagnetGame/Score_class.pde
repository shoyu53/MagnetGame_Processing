class Score {

  private int sumScore;
  private int point;
  private int bonas;
  private boolean[] scoreEffect=new boolean[sandN];
  //砂鉄獲得エフェクトを表示させた回数を記録
  private int effectNum;
  //砂鉄獲得エフェクトを表示させる時間
  private int[] countDown= new int[sandN];
  //砂鉄獲得時のプレイヤーの位置を記録
  private float[] pX=new float[sandN];
  private float[] pY=new float[sandN];
  //float pX=player.getMagX();
  //float pY=player.getMagY();

  //もちろん最初は0点スタート
  Score() {
    this.sumScore=0;
    this.point=100;
    this.bonas=50;
    for (int i=0; i<scoreEffect.length; i++) {
      this.scoreEffect[i]=false;
      this.countDown[i]=30;   //60fだからcountdown[i]--;のときは30/60=0.5秒間のカウントダウン
      this.pX[i]=0;
      this.pY[i]=0;
    }
    this.effectNum=0;
  }


  void addScore() {
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
    text(sumScore, 1030, 60);
    effectDraw();
  }

  void effectDraw() {
    for (int i=0; i<scoreEffect.length; i++) {
      if (scoreEffect[i]==true) {
        countDown[i]--;
        if (0<countDown[i]) {
          //エフェクト表示
          fill(255, 0, 0);
          textSize(15);
          text("+"+point, pX[i], pY[i]);
        } else {
          //カウントダウンが0になったらエフェクトの表示を止める
          scoreEffect[i]=false;
        }
      }
    }
  }
}
