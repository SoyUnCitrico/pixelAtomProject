//PROYECTO ATOM

//Este software toma una fotografia y la descompone en pixeles de colores
//que pueden ser manipulados en el canvas
FlowField campo;
PixelCluster cluster;
PImage img;
int cellSize = 5;
int selector = 1;
boolean isCampoActive = false;
boolean isPlaying = false;

void setup() {
  size(1024,1280);
  //size(1280,720);
  //size(600, 600);
  //size(512,640);
  //size(256,256);
  img = loadImage("./pictures/teamFic.jpg");
  //img = loadImage("./pictures/cassete.png");
  img.resize(width, height);
  image(img, 0, 0);
  campo = new FlowField(img, cellSize*4);
  cluster = new PixelCluster(img, cellSize);
}


void draw() {
  if(isPlaying) {
    play();
  }
}

void play() {
  
  background(#11f0ar2);
  if (isCampoActive) campo.mostrarCampo();
  
  switch(selector) {
  case 1:
    cluster.initialPosition();
    break;
  case 2:
    cluster.seguirMouse();
    break;
  case 3:
    cluster.atravesarCampo(campo, "OTHERSIDE");
    break;
  case 4:
    cluster.deambularCluster("REVERSE_XY");
    break;
  default:
    cluster.initialPosition();
    break;
  }
}

void keyPressed() {
  println(keyCode);
  if (keyCode == 49) selector = 1;  // Numero 1
  if (keyCode == 50) selector = 2;  // Numero 2
  if (keyCode == 51) selector = 3;  // Numero 3
  if (keyCode == 52) selector = 4;  // Numero 4
  if (keyCode == 67)isCampoActive = !isCampoActive;  // Letra "c"
  if (keyCode == 68) campo.initNoise();  // Letra "d"
  if (keyCode == 80) isPlaying = !isPlaying;  // Letra "p"
  if (keyCode == 86) campo.initImage(img);  // Letra "v"
  if (keyCode == 83) cluster.cambiarShape();  // Letra "s"
}
