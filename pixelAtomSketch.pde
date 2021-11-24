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
  //size(1024,1280);
  size(800,960);
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
    cluster.deambularCluster("OTHERSIDE");
    break;
  case 5:
     ArrayList<PixelAtom> otras = cluster.getPixels();
     cluster.manadaCluster(otras,"OTHERSIDE");
     break;
  default:
    cluster.initialPosition();
    break;
  }
}

void keyPressed() {
  println(keyCode);
  if (keyCode == 49) {selector = 1; println("original mode");} // Numero 1
  if (keyCode == 50) {selector = 2; println("mouse mode");}  // Numero 2
  if (keyCode == 51) {selector = 3; println("field mode");}  // Numero 3
  if (keyCode == 52) {selector = 4; println("walk mode"); } // Numero 4
  if (keyCode == 68) {campo.initNoise(); println("Noise Field");}// Letra "d"
  if (keyCode == 69) {campo.initImage(img); println("Image Field");} // Letra "e"
  if (keyCode == 80) {isPlaying = !isPlaying;  println("Play / Pause");} // Letra "p"
  if (keyCode == 83) {cluster.cambiarShape(); println("Cambio la forma");}  // Letra "s"
  if (keyCode == 86) {cluster.cambiarLifeMode(); println("Cambio la vida");}  // Letra "v"
  if (keyCode == 67) {isCampoActive = !isCampoActive; println("Cambio campo");}   // Letra "c"
}
