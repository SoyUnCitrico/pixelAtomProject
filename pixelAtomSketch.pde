//PROYECTO ATOM

//Este software toma una fotografia y la descompone en pixeles de colores 
//que pueden ser manipulados en el canvas
ArrayList<PixelAtom> pixeles = new ArrayList<PixelAtom>();
PImage img;
int dimension;
int cellSize = 2;
boolean isStatic = true;

void setup() {
  ellipseMode(CORNER);
  rectMode(CORNER);
  //size(1024,1280);
  //size(1280,720);
  size(512,512);
  //size(256,256);
  img = loadImage("./pictures/profile-nobg.png");
  img.resize(width,height);
  img.loadPixels();
  for (int y = 0; y < img.height; y+=cellSize ) {
    for (int x = 0; x < img.width; x+=cellSize ) {
      int loc = x + y*img.width;
      // The functions red(), green(), and blue() pull out the three color components from a pixel.
      float r = red(img.pixels [loc]); 
      float g = green(img.pixels[loc]);
      float b = blue(img.pixels[loc]);
      
      PixelAtom pix = new PixelAtom(x, y, cellSize, cellSize, color(r, g, b));
      pixeles.add(pix);
    }
  }
}


void draw() {
  background(#f6d2aD);
 if(isStatic) {
    for(PixelAtom pix : pixeles) {
      pix.arrivarTarget(pix.originalPosition, 35, "REVERSE_XY");
    }
  } else {
    for(PixelAtom pix : pixeles) {
      PVector mousePos = new PVector(mouseX, mouseY);
      pix.arrivarTarget(mousePos, 20, "OTHERSIDE");
    }
  }
}

void keyPressed() {
  println(keyCode);
  if(keyCode == 83) {
    // Letra "s"
    for(PixelAtom pix : pixeles) {
      pix.tooglePixelShape();    
    }
  }
  // if(keyCode == 77) pixel.changePixelShape();  //Letra "m"
  if(keyCode == 80) isStatic = !isStatic;  //Letra "p"
  
}
