class PixelAtom {
  
  int identifier,
      w,
      h;
      
  float life,
        damage,
        maxSpeed,
        maxForce,
        wanderTheta;
        
  PVector position,
          velocity,
          acceleration,
          originalPosition;
  
  boolean squarePixel,
          isDebugging,
          isLiving;
          
  color skin,
        originalSkin;
  
  ////////////////////// CONSTRUCTORES ////////////////////
  PixelAtom() {
    initPixel();
  }
  
  PixelAtom(int x, int y, int ancho, int alto) {
    initPixel();
    position = new PVector(x,y);
    originalPosition = position.copy();
    w = ancho;
    h = alto;
  }
  
  PixelAtom(int x, int y, int ancho, int alto, color col) {
    initPixel();
    position = new PVector(x,y);
    originalPosition = position.copy();
    w = ancho;
    h = alto;
    skin = col;
    originalSkin = skin;
  }
  
  void initPixel() {
    w = 10;
    h = 10;
    identifier = floor(random(1,100000));
    skin = color(random(100,255));
    originalSkin = skin;
    position = new PVector(floor(random(width)),floor(random(height)));
    originalPosition = position.copy();
    //velocity = new PVector(random(-5, 5), random(-5, 5)).limit(4);
    velocity = new PVector(random(-5, 5), random(-5, 5)).normalize();
    acceleration = new PVector(0,0);
    wanderTheta = 0;
    life = 100;
    damage = .1;
    maxSpeed = 4;
    maxForce = 0.1;
    squarePixel = true;
    isDebugging = false;
    isLiving = false;
  } 
  
  ///////////////////  API  ////////////////////////

  void seguirTarget(PVector target, String typeBoundaries) {
    seek(target);
    actualizar();
    checkLimits(typeBoundaries);
    if (isLiving)  {
      living();
    }
    drawPixel();
  }

  void arrivarTarget(PVector target, float targetRadius, String typeBoundaries) {
    arrive(target, targetRadius);
    actualizar();
    checkLimits(typeBoundaries);
    if (isLiving)  {
      living();
    }
    drawPixel();
  }

  void pasear(String typeBoundaries) {
    wander();
    actualizar();
    checkLimits(typeBoundaries);
    if (isLiving)  {
      living();
    }
    drawPixel();
  }

  void seguirCampo(FlowField campo, String typeBoundaries) {
    followField(campo);
    actualizar();
    checkLimits(typeBoundaries);
    if (isLiving)  {
      living();
    }
    drawPixel();
  }

  void manadaSensor(ArrayList<PixelAtom> bolitas, String typeBoundaries) {
    flock(bolitas);
    actualizar();
    checkLimits(typeBoundaries);
    if (isLiving)  {
      living();
    }
    drawPixel();
  }
  
  ////////////////////// DIBUJO ////////////////////
  void drawPixel() {
    pushMatrix();
    fill(skin);
    noStroke();
    if(squarePixel) {
      rect(position.x,position.y,w,h);
    } else {
      ellipse(position.x,position.y,w,h);
    }
    popMatrix();
  }
  
  void drawWander(PVector position, PVector circle, PVector target, float rad) {
    pushMatrix();
    stroke(0);
    fill(255);
    ellipseMode(CENTER);
    ellipse(circle.x, circle.y, rad*2, rad*2);
    ellipse(target.x, target.y, 4, 4);
    line(position.x, position.y, circle.x, circle.y);
    line(circle.x, circle.y, target.x, target.y);
    popMatrix();
  }
  
  void mapLifeToColor() {
    float r = red(originalSkin);
    float g = green(originalSkin);
    float b = blue(originalSkin);

    float newR = map(life, 0, 100, 0, r);
    float newG = map(life, 0, 100, 0, g);
    float newB = map(life, 0, 100, 0, b);

    setColor(color(newR, newG, newB));
  }

  void mapLifeToAlpha() {
    float a = alpha(originalSkin);
    float r = red(originalSkin);
    float g = green(originalSkin);
    float b = blue(originalSkin);
    float newAlpha = map(life, 0, 100, 0, a);
    setColor(color(r, g, b, newAlpha));
  }
  
  /////////////////  VIDA  /////////////////    
  void living() {
    lessLife();
    mapLifeToAlpha();
  }

  void lessLife() {
    life -= damage;
  }

  void moreLife(float health) {
    life += health;
  }
  boolean isDead() {
    if (life < 0.0) {
      //String logOut = String.format("La bolita %d ha muerto\n", id);
      //print(logOut);
      return true;
    } else {
      return false;
    }
  }
  
  //////////////// Getters && Setters ////////////////
  void setSize(int wx, int hy) {
    w = wx;
    h = hy;
  }

  void setDamage(float d) {
    damage = d;
  }

  void setColor(color c) {
    skin = c;
  }

  void setPosition(PVector p) {
    position = p.copy();
  }

  float getLife() {
    return life;
  }
  
  ///////////////// TOOGLE ///////////////// 
  
  void tooglePixelShape() {
    squarePixel = !squarePixel;
  }
  
  void toogleDebug() {
    isDebugging = !isDebugging;
  }

  void toogleLife() {
    isLiving = !isLiving;
  }
  
  //////////////////   MOVIMIENTO  ////////////////
  void applyForce(PVector fuerza) {
    acceleration.add(fuerza);
  }
  
  void actualizar() {
    velocity.add(acceleration).limit(maxSpeed);
    position.add(velocity);
    acceleration.mult(0);
  }
  
  void arrive(PVector objetivo, float distance) {
    PVector newPos = PVector.sub(objetivo, position);
    //The distance is the magnitude of the vector pointing from location to target.
    float d = newPos.mag();
    newPos.normalize();
    //If we are closer than 100 pixels...
    if (d < distance) {
      //...set the magnitude according to how close we are.
      float m = map(d, 0, distance, 0, maxSpeed);
      newPos.mult(m);
    } else {
      //Otherwise, proceed at maximum speed.
      newPos.mult(maxSpeed);
    }

    //The usual steering = desired - velocity
    PVector newDir = PVector.sub(newPos, velocity).limit(maxForce);
    applyForce(newDir);
  }
  
  void seek(PVector objetivo) {
    PVector newPos = PVector.sub(objetivo, position).normalize().mult(maxSpeed);
    PVector newDir = PVector.sub(newPos, velocity).limit(maxForce);
    applyForce(newDir);
  }
  
  PVector seekVector(PVector target) {
    // A vector pointing from the position to the target
    PVector desired = PVector.sub(target, position);  
    desired.normalize().mult(maxSpeed);
    PVector steer = PVector.sub(desired, velocity).limit(maxForce);  
    return steer;
  }
  
  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<PixelAtom> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }
  
  void wander() {
    float wanderR = 25;         // Radius for our "wander circle"
    float wanderD = 80;         // Distance for our "wander circle"
    float change = 0.3;
    wanderTheta += random(-change, change);     // Randomly change wander theta

    // Now we have to calculate the new position to steer towards on the wander circle
    PVector circlepos = velocity.copy();    // Start with velocity
    circlepos.normalize();            // Normalize to get heading
    circlepos.mult(wanderD);          // Multiply by distance
    circlepos.add(position);               // Make it relative to boid's position

    float h = velocity.heading();        // We need to know the heading to offset wandertheta

    PVector circleOffSet = new PVector(wanderR*cos(wanderTheta+h), wanderR*sin(wanderTheta+h));
    PVector target = PVector.add(circlepos, circleOffSet);
    seek(target);
    //print("\n&d is debugging?\n R: %x",id,isDebugging);
    if (isDebugging)
      drawWander(position, circlepos, target, wanderR);
  }
  
  void followField(FlowField campo) {
    PVector desired = campo.lookup(position);
    desired.mult(maxSpeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce); 
    applyForce(steer);
  }
  
  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<PixelAtom> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (PixelAtom other : boids) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxSpeed);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<PixelAtom> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (PixelAtom other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxSpeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxForce);
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<PixelAtom> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (PixelAtom other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seekVector(sum);  // Steer towards the position
    } else {
      return new PVector(0, 0);
    }
  }
  
  void checkLimits(String type) {
    type.toUpperCase();
    switch(type) {
    case "OTHERSIDE":
      if (position.x > width) {
        position.x = 0 + w/2;
      }
      if (position.x < 0) {
        position.x = width - w/2;
      }
      if (position.y > height) {
        position.y = 0 + h/2;
      }
      if (position.y < 0) {
        position.y = height - h/2;
      }
      break;
    case "REVERSE_X":
      if (position.x > width || position.x < 0) {
        velocity.x *= -1;
      }
      if (position.y > height) {
        position.y = 0 + h/2;
      }
      if (position.y < 0) {
        position.y = height - h/2;
      }
      break;
    case "REVERSE_Y":
      if (position.x > width) {
        position.x = 0 + w/2;
      }
      if (position.x < 0) {
        position.x = width - w/2;
      }
      if (position.y > width || position.y < 0) {
        velocity.y *= -1;
      }
      break;
    case "REVERSE_XY":
      if (position.x > width || position.x < 0) {
        velocity.x *= -1;
      }
      if (position.y > height || position.y < 0) {
        velocity.y *= -1;
      }
      break;

    default:
      print("No limits\n");
      break;
    }
  }
  
}
