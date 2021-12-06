// The Nature of Code

class FlowField {

  // A flow field is a two dimensional array of PVectors
  PVector[][] field;
  int cols, rows; // Columns and Rows
  int resolution; // How large is each "cell" of the flow field

  FlowField(int r) {
    resolution = r;
    // Determine the number of columns and rows based on sketch's width and height
    cols = width/resolution;
    rows = height/resolution;
    field = new PVector[cols][rows];
    initNoise();
  }

  FlowField(PImage picture, int r) {
    resolution = r;
    // Determine the number of columns and rows based on sketch's width and height
    cols = width/resolution;
    rows = height/resolution;
    field = new PVector[cols][rows];
    initImage(picture);
  }

  void initImage(PImage imagen) {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        field[i][j] = new PVector(width/2-i*resolution,height/2-j*resolution);
        field[i][j].normalize();
      }
    }

    // Reseed noise so we get a new flow field every time
    for (int i = 1; i < cols-1; i++) {
      for (int j = 1; j < rows-1; j++) {

        int x = i*resolution;
        int y = j*resolution;
        int c = imagen.pixels[x + y * imagen.width];

        // Map brightness to an angle
        float theta = map(brightness(c), 0, 255, 0, TWO_PI);
        // Polar to cartesian coordinate transformation to get x and y components of the vector
        field[i][j] = PVector.fromAngle(theta);
        field[i][j].normalize();
      }
    }
  }
  
  void initNoise() {
    // Reseed noise so we get a new flow field every time
    noiseSeed((int)random(10000));
    float xoff = 0;
    for (int i = 0; i < cols; i++) {
      float yoff = 0;
      for (int j = 0; j < rows; j++) {
        float theta = map(noise(xoff,yoff),0,1,0,TWO_PI);
        // Polar to cartesian coordinate transformation to get x and y components of the vector
        field[i][j] = new PVector(cos(theta),sin(theta));
        yoff += 0.1;
      }
      xoff += 0.1;
    }
  }

  // Draw every vector
  void mostrarCampo() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        drawVector(field[i][j], i*resolution+resolution/2, j*resolution+resolution/2, resolution);
      }
    }
  }

  // Renders a vector object 'v' as an arrow and a position 'x,y'
  void drawVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    // Translate to position to render vector
    translate(x, y);
    strokeWeight(1);
    stroke(255, 0, 0);
    // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
    rotate(v.heading());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    line(0, 0, len, 0);
    //line(len,0,len-arrowsize,+arrowsize/2);
    //line(len,0,len-arrowsize,-arrowsize/2);
    popMatrix();
  }

  PVector lookup(PVector lookup) {
    int column = int(constrain(lookup.x/resolution, 0, cols-1));
    int row = int(constrain(lookup.y/resolution, 0, rows-1));
    return field[column][row].copy();
  }
  
  PVector
}
