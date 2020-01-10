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
  void setGameover(boolean gameover) {
    this.gameover=gameover;
  }

  boolean getGameover() {
    return gameover;
  }


  void resultDraw() {
    fill(255, 0, 0);
    textSize(80);
    text("G A M E", 300, 300);
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
