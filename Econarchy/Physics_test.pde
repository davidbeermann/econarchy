public class Physical extends Actor {
  
  boolean upPressed = false;
  boolean downPressed = false;
  boolean leftPressed = false;
  boolean rightPressed = false;
  PVector currVelocity, gravityAcc; //velocity and gravity values
  float lowerBoundary;
  
  public Physical(PVector pos)
  {
    currVelocity = new PVector(0.0,0.0);
    gravityAcc = new PVector(0.0,10.0);
    // position = new PVector(width/2, height-20, 0);
    position = pos;
    lowerBoundary = position.y;
    stateGraphic = loadImage("devAvatar.png");

  }

  public void drawPlayer()
  {
    fill(255);
    ellipse(position.x, position.y, 20, 20);
  }

  public PImage playerRender()
  {
    avatar.beginDraw();
    avatar.image(stateGraphic,0, 0);
    avatar.endDraw();
    return avatar;
  }
  
  public void jump() {
     if ( currVelocity.y == 0.0 ) //enable jumping only if player is not moving in y direction(already jumping or falling)
          currVelocity.y = -10;
  }

  public void controlPlayer() {
    
    if (keyPressed && key == CODED) {
      switch(keyCode) {
      case LEFT: 
        currVelocity.x += -0.1; //accelerate character to the left, TODO: limit acceleration to prevent uncontrollable behaviour
        break;
      case RIGHT: 
        currVelocity.x += 0.1; ////accelerate character to the right, TODO: limit acceleration to prevent uncontrollable behaviour
        break;
      case UP:     
        if ( currVelocity.y == 0.0 ) //enable jumping only if player is not moving in y direction(already jumping or falling)
          currVelocity.y = -10;
        break;
      }
      
      println("playerpos x: " + position.x + " y: " + position.y);
    }
    else
      currVelocity.x = 0.0;
    
    
    position.add(currVelocity); //apply velocity to player
    
    PVector tmpAccel = PVector.mult(gravityAcc, 1.0/30.0); //calculate gravitational Acceleration, assuming 30fps/can later be adjusted to use realtime for better simulation
    println("TMPACCEL IS " +  tmpAccel.x + "     " + tmpAccel.y);
    
    
    if( position.y < lowerBoundary) //only apply gravity if player is inside of level bounds
       currVelocity.add(tmpAccel);  
    else
       currVelocity.y = 0.0; //reset vertical velocity if player hits rock bottom
   println("CURRVELOCITY: " + currVelocity.x + "   " + currVelocity.y);

  }
}
