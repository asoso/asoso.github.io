// ファイルを指定して電力データを読み込む
// クラス（Class）バージョン
// 

EneTable ene;
String[] filelist;
int dataNum = 0;
int hour = 0;
float sunHeight = 0;
PImage img;
PImage wave;
PImage sun;

void setup() {
  // 画面初期化
  size(1224, 400);
  noStroke();
  frameRate(12);
  textSize(30);

  filelist = loadStrings("filelist.txt"); 
  // データ読み込み用クラスEneTableをインスタンス化（初期化）
  ene = new EneTable(filelist[dataNum]);

  img = loadImage("penguin.png");
  wave = loadImage("wave.png");
  sun = loadImage("sun.png");
 
}

void draw() {
  if(hour==0){
  sunHeight= 0;
  }else if(hour>12){
  sunHeight++;
}else{
  sunHeight--;}
  
  ///////////////////////////////////////////////////////////////////
  //空の色////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////
    
  float skyColor = map(sunHeight,0,12,0,45);
  background(160-skyColor, 190-skyColor, 250);

  
  ///////////////////////////////////////////////////////////////////
  //太陽の高さ////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////
  noTint();
  tint(165-skyColor*2,120+skyColor*3,0);
  image(sun,1070,300+sunHeight*23,100,100);
  
   
  // 日付
  fill(80,80,180);
  text(ene.date + " : "  + hour, 10, 30);
  pushMatrix();
  // 全体を少し右下へ
  translate(2, 20);
  // 行と列の数だけ繰り返し  
  for (int i = 0; i < ene.data.length-1; i++) {
    // データの数値を文字で画面に表示
    float graphHeight = map(ene.data[i][hour], 0, 1000, 0, 800);
    if (graphHeight > 800) {
      graphHeight = 800;
    }
    float value = map(ene.data[i][hour], 0, 100, 0, 255);
    if (value > 255) {
      value = 255;
    }
  
   
    fill(255-value, 255-value, 255);
    rect(11 * i, 200+graphHeight*5, 11, 500);


    
  }
  ///////////////////////////////////////////////////////////////////
  //ペンギンの高さ/////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////
  
  for(int i = 0;i < 3;i++){
    float penguinHeight = map(ene.data[i*35+25][hour], 0, 1000, 0, 800);
    if (penguinHeight > 800) {
      penguinHeight = 800;
    }
    noTint();
    image(img, 10*(i * 35+25), 115+penguinHeight*5);
  }
  
  ///////////////////////////////////////////////////////////////////
  //波の高さ//////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////
  
  float sum = 0;
  for(int i = 0; i < ene.data.length-1; i++){
    sum += ene.data[i][hour];
  }
  float ave = sum / ene.data.length-1;
  float waveHeight = map(ave, 0, 1000, 0, 800);
    if (waveHeight > 800) {
      waveHeight = 800;
    }
  image(wave,-2,335-waveHeight);
  fill(80,80,180);
  text("total:" + sum,1000,10);
  
   



  popMatrix();
  // 一つ先のファイルを再読み込み
  // データ番号を更新
  hour++;
  if (hour > 23) {
    hour = 0;
    dataNum++;
  }
  // もしファイル数よりも多ければリセット
  if (dataNum > filelist.length - 1) {
    dataNum = 0;
  }
  // クラスを再度初期化する
  ene = new EneTable(filelist[dataNum]);
}

// EneTable
// 電力データ読み込み用クラス

class EneTable {
  String date;  // 日付
  int data[][]; // データ

  // コンストラクタ（初期化関数）
  // ファイルを指定して、データをパース
  EneTable(String filename) {
    String[] rows = loadStrings(filename);
    String[] header = split(rows[0], ",");
    date = header[1];    
    data = new int[rows.length - 1][];

    for (int i = 1; i < rows.length - 1; i++) {
      int[] row = int(split(rows[i], ","));
      data[i - 1] = (int[]) subset(row, 1);
    }
  }
}


