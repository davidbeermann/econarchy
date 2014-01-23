public class Actor
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
  
  public BoundingBox getBounds() {
    return new BoundingBox(position, new PVector(avatar.width, avatar.height));
  }
  
  public void handleCollision(Collision c) {
    return;
  }
}



public class Player extends Actor
{
  PVector currVelocity;
  PVector gravityAcc;
  float jumpHeight;
  float speedMax = 10.0;
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

  public void jump() {
     if ( currVelocity.y <= 0.5 ) //enable jumping only if player is not moving in y direction(already jumping or falling)
          currVelocity.y = -jumpHeight;
  }
  
  public void move(float x, float y) {
    currVelocity.x = x*10;
    println(x);
  }
  
  public void controlPlayer() {
      // check if any keypresses happened and actions need to be performed
     if ( leftPressed||rightPressed||upPressed||downPressed ) {
     if ( leftPressed ) {
      currVelocity.x += -0.1; }
     if ( rightPressed ) {
      currVelocity.x += 0.1; }
     if ( upPressed && currVelocity.y <= 0.1 )
       currVelocity.y = -jumpHeight;
     if ( downPressed )
       currVelocity.y = 0;
     }
     else // if not slowly stop player movement
       currVelocity.x *= 0.8;
    
    //limit speed
    if ( currVelocity.mag() >= speedMax ) 
       currVelocity.setMag(speedMax);
    
    position.add(currVelocity); //apply velocity to player
    
    PVector tmpAccel = PVector.mult(gravityAcc, 1.0/30.0); //calculate gravitational Acceleration, assuming 30fps/can later be adjusted to use realtime for better simulation
    println("TMPACCEL IS " +  tmpAccel.x + "     " + tmpAccel.y);
    
    
    if( position.y < lowerBoundary) //only apply gravity if player is inside of level bounds
       currVelocity.add(tmpAccel);  
    else
       currVelocity.y = 0.0; //reset vertical velocity if player hits rock bottom
   println("CURRVELOCITY: " + currVelocity.x + "   " + currVelocity.y);
   println("playerpos x: " + position.x + " y: " + position.y);
  }
  
  public void handleCollision(Collision c) {
    println("TEST");
    if ( currVelocity.y > 0)
        currVelocity.y = 0f;
        position.y = c.getCollider().y + c.getCollider().height; 
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
    if (spottedThePlayer(player)) 
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
    if (position.x<= 0 || position.x>= width) {
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

// public boolean doEnemyAndPlayerColide()
// {
//   for (int i = 0; i < enemies.length; ++i)
//   {
//     if (enemies[i].isInViewport())
//     {


//       if (dist(enemies[i].position.x, enemies[i].position.y, hans.position.x, hans.position.y) <= enemies[i].runningSpeed)
//       {
//         //precise detection
//         return true;
//       }
//     }
//     else
//     {
//       return false;
//     }
//   }
//   return false;
// }

public boolean standOnPlattform()
{
//  for (int i = 0; i < level.platforms.length; ++i) {
//    //    if (platforms[i].isInViewport())
//    //    {
//    if (hans.position.x >= level.platforms[i].x && 
//      hans.position.x <= level.platforms[i].x + level.platforms[i].width &&
//      hans.position.y >= level.platforms[i].y &&
//      hans.position.y <= level.platforms[i].y + level.platforms[i].height)
//      //hier noch spielerhöhe mit einbeziehen
//    {
//      return true;
//    } 
//    else {
//      return false;
//    } 
//    //    } else {
//    //      return false;
//    //      
//    //    }
//  }
return false;
}

