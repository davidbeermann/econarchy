public class Physical extends Actor {
//  boolean upPressed = false;
//  boolean downPressed = false;
//  boolean leftPressed = false;
//  boolean rightPressed = false;
//  //PVector currVelocity, gravityAcc; //velocity and gravity values
//  float lowerBoundary;
//  float speed_max = 10.0;
//  float jumpingForce = 10;
//  
  public Physical(PVector pos)
  {
    ///currVelocity = new PVector(0.0,0.0);
    //gravityAcc = new PVector(0.0,10.0);
    // position = new PVector(width/2, height-20, 0);
    position = pos;
    //lowerBoundary = position.y;
    stateGraphic = loadImage("devAvatar.png");

  }

//    public void keyPressed(KeyEvent e) {
//    if ( key == CODED ){
//      if (keyCode == UP)
//        upPressed = true;
//      else if (keyCode == DOWN)
//        downPressed = true;
//      else if (keyCode == LEFT)
//        leftPressed = true;
//      else if (keyCode == RIGHT)
//        rightPressed = true;
//    }
//  }
//  
//  public void keyReleased(KeyEvent e) {
//    if ( key == CODED ) {
//      if ( keyCode == UP )
//        upPressed = false;
//      else if ( keyCode == DOWN )
//        downPressed = false;
//      else if ( keyCode == LEFT )
//        leftPressed = false;
//      else if ( keyCode == RIGHT )
//        rightPressed = false;
//    }
//  }


  public PImage playerRender()
  {
    avatar.beginDraw();
    avatar.image(stateGraphic,0, 0);
    avatar.endDraw();
    return avatar;
  }
  
//  public void jump() {
//     if ( currVelocity.y <= 0.5 ) //enable jumping only if player is not moving in y direction(already jumping or falling)
//          currVelocity.y = -jumpingForce;
//  }
//  
//  public void move(float x, float y) {
//    currVelocity.x = x*10;
//    println(x);
//  }
    
  public void controlPlayer() {
    
//     if ( leftPressed||rightPressed||upPressed||downPressed ) {
//     if ( leftPressed ) {
//      println("LEFT PRESSED");
//      currVelocity.x += -0.1; }
//     if ( rightPressed ) {
//     println("RIGHT PRESSED");
//      currVelocity.x += 0.1; }
//     if ( upPressed && currVelocity.y <= 0.1 )
//       currVelocity.y = -jumpingForce;
//     if ( downPressed )
//       currVelocity.y = 0;
//     }
//     else 
//       currVelocity.x *= 0.8;
//    
//    //limit speed
//    if ( currVelocity.mag() >= speed_max ) 
//       currVelocity.setMag(speed_max);
//    
//    position.add(currVelocity); //apply velocity to player
//    
//    PVector tmpAccel = PVector.mult(gravityAcc, 1.0/30.0); //calculate gravitational Acceleration, assuming 30fps/can later be adjusted to use realtime for better simulation
//    println("TMPACCEL IS " +  tmpAccel.x + "     " + tmpAccel.y);
//    
//    
//    if( position.y < lowerBoundary) //only apply gravity if player is inside of level bounds
//       currVelocity.add(tmpAccel);  
//    else
//       currVelocity.y = 0.0; //reset vertical velocity if player hits rock bottom
//   println("CURRVELOCITY: " + currVelocity.x + "   " + currVelocity.y);

  }
}
