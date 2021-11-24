import java.util.Iterator;

class PixelCluster{
  ArrayList<PixelAtom> cluster;
  int numElementos;
  
  PixelCluster(ArrayList<PixelAtom> pics) {
    for(PixelAtom pixy : pics) {
      pixy.drawPixel();
      cluster.add(pixy);
    }
    noLoop();
  }
  
  void staticDraw() {
     Iterator<PixelAtom> it = cluster.iterator();
     while (it.hasNext()) {
      PixelAtom b = it.next();
      b.drawPixel();
      if (b.isDead()) {
         it.remove();
         String logOut = String.format("Bolitas en el cluster: %d\n", cluster.size());
         print(logOut);
      }
    }
  }
  
  void seguirMouse() {
    PVector mousePosition = new PVector(mouseX,mouseY); 
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
    PVector mousePosition = new PVector(mouseX,mouseY); 
    Iterator<PixelAtom> it = cluster.iterator();
    //Using an Iterator object instead of counting with int i
    while (it.hasNext()) {
      PixelAtom b = it.next();
      //b.buscarTarget(mousePosition);
      b.arrivarTarget(mousePosition,50.0,"OTHERSIDE");
 
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
      b.seguirCampo(campo,typeBoundaries);
      
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
      b.manadaSensor(otras,typeBoundaries);
      
      if (b.isDead()) {
         it.remove();
         String logOut = String.format("Bolitas en el cluster: %d\n", cluster.size());
         print(logOut);
      }
    }
  }
  
  void crecer() {
    cluster.add(new PixelAtom());
    String logOut = String.format("Bolitas en el cluster: %d\n", cluster.size());
    print(logOut);
  }
  
  void debugDeambular() {
    for(int i = 0; i < cluster.size(); i++) {
      PixelAtom b = cluster.get(i);
      b.toogleDebug();    
    }  
  }
  
  void cambiarLifeMode() {
    for(int i = 0; i < cluster.size(); i++) {
      PixelAtom b = cluster.get(i);
      b.toogleLife();    
    }  
  }
  
  ArrayList<PixelAtom> getBolitas() {
    return cluster;
  }
  
  
}
