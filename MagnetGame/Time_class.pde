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

  int getTimeCount() {
    return timeCount;
  }

  void timeDraw() {
    addTimeLimit();
    fill(0);
    textSize(68);
    if(remainingTime<=3){
      fill(255,50,0);
    }
    text(remainingTime, 550, 75);
    timeCount++;
    //制限時間を減らしていく
    if (remainingTime>0) {
      remainingTime=timeLimit-(timeCount/60);
    }
    //時間追加時のエッフェクト
    if(notAddTimeLimit==false){
      addTimeEffectDraw();
      addTimeEffect--;
      timeEffectY-=0.5;
    }
  }
  
  void addTimeLimit() {
    if (notAddTimeLimit==true) {
      if (5000<score.sumScore) {
        timeLimit+=5;
        notAddTimeLimit=false;
      }
    }
  }
  
  void addTimeEffectDraw(){
    fill(255,0,0,addTimeEffect*(255/90));
    textSize(68);
    text("+5",600,75+timeEffectY);
  }
}
