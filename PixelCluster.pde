import java.util.ArrayList;
import java.util.Iterator;

class PixelCluster {
  ArrayList<PixelAtom> cluster = new ArrayList<PixelAtom>();
  PImage img;
  float noiseValue;
  float noiseStep;
  float shakeFactor;

  PixelCluster(PImage picture, int cellSize) {
    picture.loadPixels();
    for (int y = 0; y < picture.height; y+=cellSize ) {
      for (int x = 0; x < picture.width; x+=cellSize ) {
        int loc = x + y*picture.width;
        //    // The functions red(), green(), and blue() pull out the three color components from a pixel.
        float r = red(picture.pixels [loc]);
        float g = green(picture.pixels[loc]);
        float b = blue(picture.pixels[loc]);
        float a = alpha(picture.pixels[loc]);
        //println("Los colores son: ", r,g,b);
        //PixelAtom pix = new PixelAtom(x, y, cellSize, cellSize, color(r, g, b));
        //cluster.add(new PixelAtom(x, y, cellSize, cellSize, color(r, g, b)));
        cluster.add(new PixelAtom(x, y, cellSize, cellSize, color(r, g, b, a)));
      }
    }
    noiseStep = 5;
    noiseValue = 0;
    shakeFactor = 100;
    picture.updatePixels();
    println("Creando el cluster");
  }

  void initialPosition() {
    Iterator<PixelAtom> it = cluster.iterator();

    while (it.hasNext()) {
      PixelAtom b = it.next();
      b.arrivarTarget(b.originalPosition, 35, "REVERSE_XY");
      if (b.isDead()) {
        it.remove();
        String logOut = String.format("Bolitas en el cluster: %d\n", cluster.size());
        print(logOut);
      }
    }
  }

  void barrerCluster(String barrerMode) {
    Iterator<PixelAtom> it = cluster.iterator();

    while (it.hasNext()) {
      PixelAtom b = it.next();
      PVector dir = b.position.copy();

      switch(barrerMode) {
      case "LEFT":
        dir.set(0, dir.y + random(b.h*(-10), b.h*10));
        b.arrivarTarget(dir, 5, "REVERSE_X");
        break;
      case "RIGHT":
        dir.set(width, dir.y + random(b.h*(-10), b.h*10));
        b.arrivarTarget(dir, 5, "REVERSE_X");
        break;
      case "DOWN":
        dir.set(dir.x + random(b.w*(-10), b.w*10), height);
        b.arrivarTarget(dir, 5, "REVERSE_Y");
        break;
      case "UP":
        dir.set(dir.x + random(b.w*(-10), b.w*10), 0);
        b.arrivarTarget(dir, 5, "REVERSE_Y");
        break;
      default:
        dir.set(dir.x + random(b.w*(-10), b.w*10), height);
        b.arrivarTarget(dir, 5, "REVERSE_Y");
        break;
      }

      if (b.isDead()) {
        it.remove();
        String logOut = String.format("Bolitas en el cluster: %d\n", cluster.size());
        print(logOut);
      }
    }
  }

  void temblarCluster() {
    Iterator<PixelAtom> it = cluster.iterator();
    
    float aumento = noise(noiseValue)*shakeFactor;
    while (it.hasNext()) {
      PixelAtom b = it.next();
      b.temblar(aumento, shakeFactor/2,  "REVERSE_XY");
      //b.arrivarTarget(dir,5, "REVERSE_XY");
      if (b.isDead()) {
        it.remove();
        String logOut = String.format("Bolitas en el cluster: %d\n", cluster.size());
        print(logOut);
      }
    }
    noiseValue += noiseStep;
  }

  void seguirMouse() {
    PVector mousePosition = new PVector(mouseX, mouseY);
    Iterator<PixelAtom> it = cluster.iterator();

    while (it.hasNext()) {
      PixelAtom b = it.next();
      b.seguirTarget(mousePosition, "OTHERSIDE");
      if (b.isDead()) {
        it.remove();
        String logOut = String.format("Bolitas en el cluster: %d\n", cluster.size());
        print(logOut);
      }
    }
  }

  void arrivarMouse() {
    PVector mousePosition = new PVector(mouseX, mouseY);
    Iterator<PixelAtom> it = cluster.iterator();
    //Using an Iterator object instead of counting with int i
    while (it.hasNext()) {
      PixelAtom b = it.next();
      //b.buscarTarget(mousePosition);
      b.arrivarTarget(mousePosition, 50.0, "OTHERSIDE");

      if (b.isDead()) {
        it.remove();
        String logOut = String.format("Bolitas en el cluster: %d\n", cluster.size());
        print(logOut);
      }
    }
  }

  void deambularCluster(String typeBoundaries) {
    Iterator<PixelAtom> it = cluster.iterator();
    //Using an Iterator object instead of counting with int i
    while (it.hasNext()) {
      PixelAtom b = it.next();
      b.pasear(typeBoundaries);

      if (b.isDead()) {
        it.remove();
        String logOut = String.format("Bolitas en el cluster: %d\n", cluster.size());
        print(logOut);
      }
    }
  }

  void atravesarCampo(FlowField campo, String typeBoundaries) {
    Iterator<PixelAtom> it = cluster.iterator();
    //Using an Iterator object instead of counting with int i
    while (it.hasNext()) {
      PixelAtom b = it.next();
      b.seguirCampo(campo, typeBoundaries);

      if (b.isDead()) {
        it.remove();
        String logOut = String.format("Bolitas en el cluster: %d\n", cluster.size());
        print(logOut);
      }
    }
  }


  void manadaCluster(ArrayList<PixelAtom> otras, String typeBoundaries) {
    Iterator<PixelAtom> it = cluster.iterator();
    //Using an Iterator object instead of counting with int i
    while (it.hasNext()) {
      PixelAtom b = it.next();
      b.manadaSensor(otras, typeBoundaries);

      if (b.isDead()) {
        it.remove();
        String logOut = String.format("Bolitas en el cluster: %d\n", cluster.size());
        print(logOut);
      }
    }
  }

  void reset() {
    for (PixelAtom pixy : cluster) {
      pixy.setPosition(pixy.originalPosition);
    }
  }

  void crecer() {
    cluster.add(new PixelAtom());
    String logOut = String.format("Bolitas en el cluster: %d\n", cluster.size());
    print(logOut);
  }

  void debugDeambular() {
    for (int i = 0; i < cluster.size(); i++) {
      PixelAtom b = cluster.get(i);
      b.toogleDebug();
    }
  }

  void cambiarLifeMode() {
    for (PixelAtom pix : cluster) {
      pix.toogleLife();
    }
  }

  void cambiarShape() {
    for (PixelAtom pix : cluster) {
      pix.tooglePixelShape();
    }
  }
  
  void savePosition() {
    for (PixelAtom pix : cluster) {
      pix.saveStaticPosition();
    }
  }

  ArrayList<PixelAtom> getPixels() {
    return cluster;
  }
}
