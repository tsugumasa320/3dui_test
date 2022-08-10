import controlP5.*;
ControlP5 cp5;
Knob myKnobX, myKnobY, myKnobZ;
//その他変数
float dx, dy, dz;
float weightA, weightB, weightC, weightD, weightE, weightF, weightG, weightH, sum;
float rotX, rotY, rotZ;
boolean rotOpFlg = false;
float boxSize = 150;
PImage Img;
void setup() {
  size(600, 500, P3D);
  PFont font = createFont("Meiryo", 50);
  textFont(font); //日本語フォント有効化
  cp5 = new ControlP5(this);
  Img = loadImage("3dLinearInterpolation.png");
  Img.resize(100, 90);
  myKnobX = cp5.addKnob("x_coordinate") //設定したノブ名の関数に値が渡る
    .setRange(0, 1)
    .setValue(0.5)
    .setPosition(30, 50)
    .setRadius(50)
    .setDragDirection(Knob.VERTICAL)
    ;
  myKnobY = cp5.addKnob("y_coordinate")
    .setRange(0, 1)
    .setValue(0.5)
    .setPosition(30, 200)
    .setRadius(50)
    .setDragDirection(Knob.VERTICAL)
    ;
  myKnobZ = cp5.addKnob("z_coordinate")
    .setRange(0, 1)
    .setValue(0.5)
    .setPosition(30, 350)
    .setRadius(50)
    .setDragDirection(Knob.VERTICAL)
    ;
  rotX = PI; //回転モードの座標初期化
  rotZ = PI/2*3;
}
void draw() {
  background(0); //black
  image(Img, 450, 40);
  smooth();
  noFill(); //塗りつぶし無し
  translate(width/2, height/2); //画面の真ん中に座標系を移動
  changeRotateMode();
  rotateCtrl();
  stroke(255); //白色の線
  box(boxSize);
  translate(0, 0, (dz*boxSize)-boxSize/2); //dzが0~1なので補正する
  fill(0, 0, 100.128); //濃い青色
  box(boxSize, boxSize, 1); //z軸を分かりやすく表示
  translate((dx*boxSize)-boxSize/2, (dy*boxSize)-boxSize/2); //dx,dyの位置に座標系を移動.
  fill(255); //白色で塗りつぶし
  box(3); //ポインター
  camera(); //resets viewport to 2D equivalent
  CalcWeight(); //重みづけ計算
  dispText(); //テキスト表示
}
void CalcWeight() {
  weightA = (1-dx)*(1-dy)*(1-dz);
  weightB = (dx)*(1-dy)*(1-dz);
  weightC = (1-dx)*(dy)*(1-dz);
  weightD = (dx)*(dy)*(1-dz);
  weightE = (1-dx)*(1-dy)*(dz);
  weightF = (dx)*(1-dy)*(dz);
  weightG = (1-dx)*(dy)*(dz);
  weightH = (dx)*(dy)*(dz);
  sum = weightA + weightB +weightC + weightD + weightE + weightF + weightG + weightH;
  //  println("weight = " + weightA +","+ weightB +","+weightC +","+ weightD +","+ weightE +","+ weightF +","+ weightG +","+ weightH);
  //  println("sum = " + sum);
}
void dispText() { //テキスト表示関連
  float dispTextX = width-160;
  float dispTextY = height-160;
  float textSize = 15;
  textSize(textSize);
  text("A = "+ weightA, dispTextX, dispTextY);
  text("B = "+ weightB, dispTextX, dispTextY+textSize);
  text("C = "+ weightC, dispTextX, dispTextY+textSize*2);
  text("D = "+ weightD, dispTextX, dispTextY+textSize*3);
  text("E = "+ weightE, dispTextX, dispTextY+textSize*4);
  text("F = "+ weightF, dispTextX, dispTextY+textSize*5);
  text("G = "+ weightG, dispTextX, dispTextY+textSize*6);
  text("H = "+ weightH, dispTextX, dispTextY+textSize*7);
  text("SUM = "+ sum, dispTextX, dispTextY+textSize*8);
  text("Enter押下で座標系回転モードとデフォルト切替", 20, 490);
  text("方向キーで座標系回転", 400, 490);
}
void keyPressed() {//キー入力関連
  if (key == ENTER) {
    if (rotOpFlg == false) {
      rotOpFlg = true;
    } else if (rotOpFlg == true) {
      rotOpFlg = false;
      rotX = PI; //回転モードの座標初期化
      rotY = 0;
      rotZ = PI/2*3;
    }
  }
}
void rotateCtrl(){
  if ((keyPressed == true) && (key == CODED)) {      // コード化されているキーが押された
    if ((keyCode == UP) && (keyCode == LEFT))  {    // キーコードを判定
      rotX = rotX+0.1;
      rotY = rotY+0.1;
    } else if ((keyCode == UP ) && (keyCode == RIGHT)){
      rotX = rotX+0.1;
      rotY = rotY-0.1;
    } else if ((keyCode == DOWN ) && (keyCode == LEFT)){
      rotX = rotX-0.1;
      rotY = rotY+0.1;
    } else if ((keyCode == DOWN ) && (keyCode == RIGHT)){
      rotX = rotX-0.1;
      rotY = rotY-0.1;
    } else if (keyCode == UP ){
      rotX = rotX+0.1;
    } else if (keyCode == DOWN) {
      rotX = rotX-0.1;
    } else if (keyCode == LEFT) {
      rotY = rotY+0.1;
    } else if (keyCode == RIGHT) {
      rotY = rotY-0.1;
    }
  }
  println(rotX +"+"+ rotY);
}
void changeRotateMode() { //座標系回転モードのオンオフ
  if (rotOpFlg == false) { //ちょうどきれいに見える位置へ
    rotateX(PI);
    rotateZ(PI/2*3);
    rotateX(-(PI/6));
  } else if (rotOpFlg == true) {
    rotateX(rotX);
    rotateY(rotY);
    rotateZ(rotZ);
  }
}
void x_coordinate(float tmp) { //ノブからの値
  dx = tmp;
}
void y_coordinate(float tmp) {
  dy = tmp;
}
void z_coordinate(float tmp) {
  dz = tmp;
}
