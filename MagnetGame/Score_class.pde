class Score {

  int sumScore;
  int point;
  int bonas;

  //もちろん最初は0点スタート
  Score() {
    this.sumScore=0;
    this.point=100;
    this.bonas=50;
  }


  void addScore() {
    sumScore+=
      point;

    if (debug) {
      println("スコア="+sumScore);
    }
  }

  void scoreDraw() {
    fill(0);
    textSize(45);
    text(sumScore, 1030, 60);
  }
}
