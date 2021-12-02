//PROYECTO ATOM
//Este software toma una fotografia y la descompone en pixeles de colores
//que pueden ser manipulados en el canvas

import processing.video.*;

Capture cam;
FlowField campo;
PixelCluster cluster;
PImage img;
int cellSize = 5;
int selector = 1;
String barrerDirection = "DOWN";
boolean firstShake = true; 
boolean blackBack = true; 
boolean isCampoActive = false;
boolean isPlaying = false;
boolean isNew = true;

void setup() {
  //size(1280,1024);
  //size(1024,1280);
  //size(800,960);
  //size(1920,1080);
  size(1280,720);
  //size(1152,648);
  //size(640, 480);
  //size(512,640);
  //size(256,256);
  //fullScreen();
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("No hay camaras disponibles");
    exit();
  } else {
    println("Las cámaras disponibles son:");
    for (int i = 0; i < cameras.length; i++) {
      print(i);
      print(" ---- ");
      println(cameras[i]);
    }
    cam = new Capture(this, cameras[2]);
    cam.start();     
  }
  
  println("Modo Camara");
}

void draw() {
  
  if(isNew){
    if (cam.available()) {
      cam.read();
    }
    pushMatrix();
    translate(width, 0);
    scale(-1,1);
    image(cam, 0, 0,width,height);
    popMatrix();
  }
  else {
    
    //background(#11fad2);
    //image(img, 0, 0);
    if(isPlaying) {
      if(blackBack) background(0);
      play();
    }
  }
}

void play() {
  if (isCampoActive) campo.mostrarCampo();
  
  switch(selector) {
  case 1:
    cluster.initialPosition();
    firstShake = true;
    break;
  case 2:
    cluster.seguirMouse();
    firstShake = true;
    break;
  case 3:
    cluster.atravesarCampo(campo, "OTHERSIDE");
    firstShake = true;
    break;
  case 4:
    cluster.deambularCluster("OTHERSIDE");
    firstShake = true;
    break;
  case 5:
    cluster.barrerCluster(barrerDirection);
    firstShake = true;
    break;
  case 6:
    if(firstShake){
      cluster.savePosition();
      firstShake = false;
    }
    cluster.temblarCluster();
    break;
  //case 5:
  //   ArrayList<PixelAtom> otras = cluster.getPixels();
  //   cluster.manadaCluster(otras,"OTHERSIDE");
  //   break;
  default:
    cluster.initialPosition();
    firstShake = true;
    break;
  }
}

void keyPressed() {
  switch(keyCode) {
    case 37:
      barrerDirection = "LEFT";
      break;
    case 38:
      barrerDirection = "UP";
      break;
    case 39:
      barrerDirection = "RIGHT";
      break;
    case 40:
      barrerDirection = "DOWN";
      break;
    case 49:
      // Numero 1
      selector = 1;
      println("original mode");
      break;
    case 50:
      // Numero 2
      selector = 2;
      println("mouse mode");
      break;
    case 51:
      // Numero 3
      selector = 3; 
      println("field mode");
      break;
    case 52:
      // Numero 4
      selector = 4; 
      println("walk mode");
      break;
    case 53:
      // Numero 5
      selector = 5; 
      println("barrer mode");
      break;  
    case 54:
      // Numero 6
      selector = 6; 
      println("Shake mode");
      break;  
    case 66:
      // Letra "b"
      blackBack = !blackBack;
      println("Black background");
      break;
    case 67:
      // Letra "c"
      isCampoActive = !isCampoActive; 
      println("Cambio campo");
      break;
    case 68:
      // Letra "d"
      campo.initNoise(); 
      println("Noise Field");
      break;
    case 69:
      // Letra "e"
      campo.initImage(img); 
      println("Image Field"); 
      break;
    case 80:
      // Letra "p"
      isPlaying = !isPlaying;  
      println("Play / Pause");
      break;
    case 82:
      // Letra "r"
      if(isPlaying) {
        cluster.reset();
        selector = 1;
      }
      println("Reset");
      break;
    case 83:
      // Letra "s"
      cluster.cambiarShape();
      println("Cambio la forma");
      break;
    case 84:
      // Letra "t"
      if(isNew) {
        println("Foto tomada");
        loadPixels();
        isNew = false;
        cam.stop();
        img = createImage(width, height, ARGB);
        img.loadPixels();
        for (int i = 0; i < img.pixels.length; i++) 
          img.pixels[i] = pixels[i];
        img.updatePixels();
        campo = new FlowField(img, cellSize*2);
        cluster = new PixelCluster(img, cellSize);
        
      } else {
       println("Modo Camara");
       cluster.reset();
       selector = 1;
       isPlaying = false;
       cam.start();
       isNew = true;
      }
      break;
    case 86:
      // Letra "v"
      cluster.cambiarLifeMode(); 
      println("Cambio la vida");
      break;
    default:
      println(keyCode);
      break;
  } 
  
}