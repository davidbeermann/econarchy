//super uber class to enable collision detection
public class Collidable {
  
  public Collidable() {
  }
  
  public boolean isEnemy() {
    return false;
  }
  
  //return empty bounding box
  public BoundingBox getBounds() {
    return new BoundingBox(0,0,0,0);
  }
  
  public void handleCollision(Collision c) {}
}
  


public class Actor extends Collidable
{
  PVector position;
  float walkingSpeed;
  float runningSpeed;
  PGraphics avatar;
  PImage stateGraphic;
  public Actor()
  {
    walkingSpeed=1;
    runningSpeed=5;
    avatar = createGraphics(30, 30);

  }

  public void walk()
  {
    position.add(walkingSpeed, 0, 0);
  }

  public void run()
  {
    position.add(runningSpeed, 0, 0);
  }
  
  public void handleCollision(Collision c) {
    return;
  }
}



public class Player extends Actor
{
  boolean alive = true;
  float acceleration = 0.1;
  PVector currVelocity;
  PVector gravityAcc;
  float jumpHeight;
  float speedMax = 50;
  float lowerBoundary; //lower end of level
  // keypress storage
  boolean upPressed;
  boolean downPressed;
  boolean leftPressed;
  boolean rightPressed;
  
  public Player(PVector pos)
  {
    currVelocity = new PVector(0.0,0.0);
    gravityAcc = new PVector(0.0,10.0);
    walkingSpeed = 10;
    jumpHeight = 10;
    // position = new PVector(width/2, height-20, 0);
    lowerBoundary = pos.y;
    position = pos;
    stateGraphic = loadImage("devAvatar.png");

  }
  
  public void keyPressed(KeyEvent e) {
    if ( key == CODED ){
      if (keyCode == UP)
        upPressed = true;
      else if (keyCode == DOWN)
        downPressed = true;
      else if (keyCode == LEFT)
        leftPressed = true;
      else if (keyCode == RIGHT)
        rightPressed = true;
    }
  }
  
  public void keyReleased(KeyEvent e) {
    if ( key == CODED ) {
      if ( keyCode == UP )
        upPressed = false;
      else if ( keyCode == DOWN )
        downPressed = false;
      else if ( keyCode == LEFT )
        leftPressed = false;
      else if ( keyCode == RIGHT )
        rightPressed = false;
    }
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
  
  @Override
  public BoundingBox getBounds() {
    return new BoundingBox(position, new PVector(avatar.width, avatar.height));
  }

  public void jump() {
     
     if ( currVelocity.y <= 0.7 ) { //enable jumping only if player is not moving in y direction(already jumping or falling)
          currVelocity.y = -jumpHeight;
     println("JUMP");}
  }
  
  public void updatePosition() {
    if (alive)
      position.add(currVelocity);
      //println ("UPWARD FORCE: " + currVelocity.y);
  }
  public void updateVelocity() {
    updateVelocity(0,0);
  }
  
  public void updateVelocity(float x, float y) {
    // gamepad is enabled if this happens
    if ( x != 0 || y != 0) {
      if ( x != 0 )
        currVelocity.x = x*10;
      if ( y != 0 )
        currVelocity.y = y*10;
    } //this should only happen if keyboard input is enabled - ensure this by removing the keypress events if gamepad is true
    else if ( leftPressed||rightPressed||upPressed||downPressed ) {
     if ( leftPressed ) 
      currVelocity.x += -acceleration; 
     if ( rightPressed ) 
      currVelocity.x += acceleration; 
     if ( upPressed && currVelocity.y <= 0.1 ) { //enable double jump here, to disable set to 0
       currVelocity.y = -jumpHeight;
       upPressed = false; }
     if ( downPressed )
       currVelocity.y = 0;
     }
     else // if neither gamepad is moved nor keypresses are detected - slow down player
       currVelocity.x *= 0.8;
       
     //calculate gravity vector
     PVector tmpAccel = PVector.mult(gravityAcc, 1.0/30.0); //calculate gravitational Acceleration, assuming 30fps/can later be adjusted to use realtime for better simulation
       
     //apply gravity if player is inside level bounds - could later be removed when physics completely takes over calculation
     // TODO: replace with level bounding boxes 
     if( position.y < lowerBoundary )
       currVelocity.add(tmpAccel);  
     else if (currVelocity.y > 1)
       currVelocity.y = 0.0; //reset vertical velocity if player hits rock bottom
       
    // rest of calculations
    // reflect player if he hits a wall //replace with collision system, as soon as physics can distinguish between ver and hor collisions
    if ( currVelocity.x != 0 && (position.x > 400-avatar.width || position.x < 0 )) {
      currVelocity.x *= -1;
       
    //limit player speed
    if ( currVelocity.mag() >= speedMax ) 
         currVelocity.setMag(speedMax);
    }
  }
  
  public void handleCollision(Collision c) {
    //println("TEST");
    if ( (c.direction == 1 || c.direction == 8)  && !c.getCollider().isEnemy()) {
        currVelocity.x *= -1;
    }
    
    if ( (c.direction == 2 || c.direction == 3 || c.direction == 10) && !c.getCollider().isEnemy()) {
        currVelocity.y = 0f;
        position.y = c.getCollider().getBounds().top - avatar.height;
    }
    
    if (c.getCollider().isEnemy()) {
       println("ENEMY COLLISION _ YOU'RE DEAD");
       alive = false;
       stateGraphic = loadImage("devAvatar_dead.png");
    }
     
 }
 
}



public class Enemy extends Actor
{
  float leftBoundary;
  float rightBoundary;
  
  
  public Enemy(PVector pos)
  {
    position = pos;
    stateGraphic = loadImage("devEnemy.png");
  }
  
  
  public Enemy(PVector position, float leftBoundary, float rightBoundary, float walkingSpeed, float runningSpeed, PImage stateGraphic)
  {
    this.position = position;
    this.leftBoundary = leftBoundary;
    this.rightBoundary = rightBoundary;
    this.walkingSpeed = walkingSpeed;
    this.runningSpeed = runningSpeed;
    this.stateGraphic = stateGraphic; 
  }
  
  @Override
  public BoundingBox getBounds() {
    return new BoundingBox(position, new PVector(avatar.width, avatar.height));
  }
    
    
  public boolean isEnemy() {
    return true;
  }

  public PImage enemyRender()
  {
    avatar.beginDraw();
    if (walkingSpeed>0) {
     avatar.pushMatrix();
     avatar.scale(-1,1);
     avatar.image(stateGraphic,-stateGraphic.width, 0);
     avatar.popMatrix();
   } 
   else if (walkingSpeed<0) {
    avatar.image(stateGraphic,0, 0);
  }
  avatar.endDraw();
  return avatar;


}

public void patroling(Player player)
{
    if (spottedThePlayer(player) && !reachedEndOfPlattform()) 
    {
      run();
    } 
    else
    {
      if (reachedEndOfPlattform()) {
        walkingSpeed = walkingSpeed*-1;
        runningSpeed = runningSpeed*-1;
        walk();
      }
      else {
        //extendable random behaviour
        int r = int(random(30));
        switch(r) {
          case 0:
          //with chance of 1/30 the enemy will turn around and walk in the other direction before reaching the end of the plattform
          walkingSpeed = walkingSpeed*-1;
          runningSpeed = runningSpeed*-1;
          walk();
          break;
          case 1: 
          //with chance of 1/30 the enemy will stand still
          break;
          default :
          //with chance of 28/10 the enemy will continue walking in the same direction he was walking before.
          walk();
          break;
        }
      }
    }
  }

  public boolean reachedEndOfPlattform()
  {
    //has to be changed to platform size instead of windowsize
    if (position.x<= leftBoundary && walkingSpeed < 0 || position.x>= rightBoundary && walkingSpeed > 0 ) {
      return true;
    }
    return false;
  }

  public boolean isInViewport(PVector playerpos)
  {
    if (dist(playerpos.x, playerpos.y, position.x, position.y)<height ) {
    return true;
  }
  else {
    return false;
  }
  }

  public boolean spottedThePlayer(Player player)
  {
    if (walkingSpeed>0 && position.x< player.position.x && abs(player.position.y-position.y)<player.avatar.height|| walkingSpeed<0 && position.x> player.position.x && abs(player.position.y-position.y)<player.avatar.height) 
    {
      return true;
    }
    else {
      return false;
    }
  }
}
