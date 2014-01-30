public class Actor extends Collidable
{
  PVector startPosition, position;
  float walkingSpeed, runningSpeed;
  PGraphics avatar;
  Sprite sprite;
  
  
  public Actor()
  {
    walkingSpeed = 0;
    runningSpeed = 0;
  }

  public void reset()
  {
    walkingSpeed = 0;
    runningSpeed = 0;
  }

  public void walk()
  {
    position.add(walkingSpeed, 0, 0);
  }

  public void run()
  {
    position.add(runningSpeed, 0, 0);
  }

  public void handleCollision(Collision c)
  {
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
  boolean doubleJumpEnabled = true;
  float speedMax = 50;
  float lowerBoundary; //lower end of level
  
  KeyTracker keyTracker; // keypress storage
  PImage[] run, jump, idle, die;
  
  
  public Player(LevelData.PlayerSpriteVO spriteVO)
  {
    super();

    // get instance of global key tracker
    keyTracker = KeyTracker.getInstance();

    // retrieve sprite images
    LevelData levelData = LevelData.getInstance();
    run = levelData.getImageResources(spriteVO.runIds);
    jump = levelData.getImageResources(spriteVO.jumpIds);
    idle = levelData.getImageResources(spriteVO.idleIds);
    die = levelData.getImageResources(spriteVO.dieIds);

    // setup sprite
    avatar = createGraphics(run[0].width, run[0].height);
    sprite = new Sprite(avatar);
  }


  public void init(PVector startPosition)
  {
    this.startPosition = startPosition;

    // set correct initial values
    reset();
  }


  @Override
  public void reset()
  {
    position = new PVector(startPosition.x, startPosition.y);
    lowerBoundary = startPosition.y;
    
    currVelocity = new PVector(0.0, 0.0);
    gravityAcc = new PVector(0.0, 10.0);
    walkingSpeed = 10;
    jumpHeight = 10;

    // set initial state of avatar
    sprite.setImages("run", run);
    sprite.setFlipH(true);

    alive = true;
    doubleJumpEnabled = true;
  }


  public PImage playerRender()
  {
    if(alive)
    {
      if(keyTracker.upPressed() && (keyTracker.leftPressed() || keyTracker.recentHorizontalKeyId() == KeyTracker.LEFT_ID))
      {
        sprite.setImages("jump", jump);
        sprite.setFlipH(true);
      }
      else if(keyTracker.upPressed() && (keyTracker.rightPressed() || keyTracker.recentHorizontalKeyId() == KeyTracker.RIGHT_ID))
      {
        sprite.setImages("jump", jump);
        sprite.setFlipH(false);
      }
      else if(keyTracker.leftPressed() && !keyTracker.rightPressed())
      {
        sprite.setImages("run", run);
        sprite.setFlipH(true);
      }
      else if(keyTracker.rightPressed() && !keyTracker.leftPressed())
      {
        sprite.setImages("run", run);
        sprite.setFlipH(false);
      }
      
      if(keyTracker.noKeyPressed())
      {
        /*if(keyTracker.recentHorizontalKeyId() == KeyTracker.LEFT_ID)
        {
          sprite.setImages("run", run);
        }
        else if(keyTracker.recentHorizontalKeyId() == KeyTracker.RIGHT_ID)
        {
          sprite.setImages("run", run);
        }
        */
        
        sprite.setImages("idle", idle);
        //sprite.render(true);
      }
      //else
      //{
        sprite.render();
      //}
    }
    else
    {
      sprite.setImages("die", die);
      //sprite.setImages(Sprite.STATE_DEAD, dead);
      //sprite.render(true);
    }
    
    return avatar;
  }
  
  
  @Override
  public BoundingBox getBounds()
  {
    return new BoundingBox(position, new PVector(avatar.width, avatar.height));
  }


  public void jump()
  {
    if ( doubleJumpEnabled) {
      if ( currVelocity.y <= 0.1 && currVelocity.y > -0.1 ) //enable jumping only if player is not moving in y direction(already jumping or falling)
      { 
        currVelocity.y = -jumpHeight; //FIXME: optimize double jump here
        music.sound("jump");
        println("CAN DOUBLEJUMP: " + doubleJumpEnabled);
        doubleJumpEnabled = !doubleJumpEnabled;
      }
    }
  }
  
  
  public void updatePosition()
  {
    if (alive)
    {
      position.add(currVelocity);
      //println("player_position.x: " + position.x + "   .y: " + position.y);
      //println ("UPWARD FORCE: " + currVelocity.y);
    }
  }
  
  
  public void updateVelocity()
  {
    updateVelocity(0,0);
  }
  
  
  public void updateVelocity(float x, float y)
  {
    // gamepad is enabled if this happens
    if ( x != 0 || y != 0)
    {
      if ( x != 0 )
      {
        currVelocity.x = x*10;
      }
      if ( y != 0 )
      {
        currVelocity.y = y*10;
      }
    }
    //this should only happen if keyboard input is enabled - ensure this by removing the keypress events if gamepad is true
    else if(keyTracker.anyKeyPressed())
    {
      if(keyTracker.leftPressed())
      {
        currVelocity.x += -acceleration;
      }
      if(keyTracker.rightPressed())
      {
        currVelocity.x += acceleration;
      }
      if(keyTracker.upPressed()) //enable double jump here, to disable set to 0
      {
        jump();
      }
      if(keyTracker.downPressed())
      {
        currVelocity.y = 0;
      }
    }
    // if neither gamepad is moved nor keypresses are detected - slow down player
    else
    {
      currVelocity.x *= 0.8;
    }
       
    //calculate gravity vector
    PVector tmpAccel = PVector.mult(gravityAcc, 1.0/30.0); //calculate gravitational Acceleration, assuming 30fps/can later be adjusted to use realtime for better simulation
       
     //apply gravity if player is inside level bounds - could later be removed when physics completely takes over calculation
     // TODO: replace with level bounding boxes 
     if( position.y < lowerBoundary )
       currVelocity.add(tmpAccel);  
    // else if (currVelocity.y > 1)
    //   currVelocity.y = 0.0; //reset vertical velocity if player hits rock bottom
       
    // rest of calculations
    // reflect player if he hits a wall //replace with collision system, as soon as physics can distinguish between ver and hor collisions
   // if ( currVelocity.x != 0 && (position.x > 400-avatar.width || position.x < 0 )) {
   //   currVelocity.x *= -1;
   //}   
    //limit player speed
//    if ( currVelocity.mag() >= speedMax ) 
//         currVelocity.setMag(speedMax);
    
  }
  
  
  public void handleCollision(Collision c)
  {
    if ( (c.direction == 1 || c.direction == 8)  && !c.getCollider().isEnemy())
    {
        println("COLLIDED WITH LEVEL BOUNDS");
        currVelocity.x *= -1;
    }
    
    if (c.direction == 2 || c.direction == 3 || c.direction == 10) 
    {
        if ( currVelocity.y <= 20) { 
        currVelocity.y = 0f;
        position.y = c.getCollider().getBounds().top - avatar.height;
        }
        else 
          alive = false;
        doubleJumpEnabled = true;
    }
    
    if (c.direction == 12 ||c.direction == 4 || c.direction == 5) {
      println("COLLISION FROM BELOW");
      }
    
    // check for breakable platforms
    if (c.getCollider().isPlatform() && currVelocity.y == 0)
    {
      Platform platform = (Platform) c.getCollider();
      if(platform.getType() == Type.Platform.BREAKABLE)
      {
        platform.setBroken();
      }
    }

    if (c.getCollider().isEnemy())
    {
      if (alive)
      {
        alive = false;
        music.sound("dead");

        println(this + " ENEMY COLLISION _ YOU'RE DEAD");
      }
    }
  }
}



public class Enemy extends Actor
{
  float leftBoundary, rightBoundary;
  PImage[] sprites;
  PVector size;
  
  
  public Enemy(PImage[] sprites, PVector position, float leftBoundary, float rightBoundary, float walkingSpeed, float runningSpeed)
  {
    this.sprites = sprites;
    this.startPosition = position;
    this.leftBoundary = leftBoundary;
    this.rightBoundary = rightBoundary;
    this.walkingSpeed = walkingSpeed;
    this.runningSpeed = runningSpeed;
    
    size = new PVector(sprites[0].width, sprites[0].height);
    avatar = createGraphics(sprites[0].width, sprites[0].height);
    sprite = new Sprite(avatar);
    sprite.setImages("walk", sprites);

    reset();
  }
  
  
  @Override
  public BoundingBox getBounds()
  {
    return new BoundingBox(position, size);
  }


  @Override
  public void reset()
  {
    this.position = new PVector(startPosition.x, startPosition.y);
  }
    
    
  public boolean isEnemy()
  {
    return true;
  }


  public PImage enemyRender()
  {
    //println(this + " render() : walkingSpeed: " + walkingSpeed);

    // flip sprite images according to direction
    if (walkingSpeed > 0)
    {
      sprite.setFlipH(false);
    } 
    else if (walkingSpeed < 0)
    {
      sprite.setFlipH(true);
    }

    sprite.render();

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
        //runningSpeed = runningSpeed*-1;
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
    if (position.x<= leftBoundary && walkingSpeed < 0 || position.x>= rightBoundary && walkingSpeed > 0 )
    {
      return true;
    }
    return false;
  }

  public boolean isInViewport(PVector playerpos)
  {
    if (dist(playerpos.x, playerpos.y, position.x, position.y) < height )
    {
      return true;
    }
    else
    {
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

