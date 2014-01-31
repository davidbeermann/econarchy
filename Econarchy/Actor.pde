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
  boolean alive = true, collisionInProgress = false;
  float acceleration = 0.5;
  PVector currVelocity;
  PVector gravityAcc;
  PVector chuteDrag;
  float jumpHeight;
  boolean doubleJumpEnabled = true;
  float speedMax = 15;
  float lowerBoundary; //lower end of level
  boolean chuteActive = true;
  int levelWidth;
  KeyTracker keyTracker; // keypress storage
  PImage[] run, jump, idle, die;
  boolean flagRaised = false;
  
  
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
    levelWidth = levelData.levelWidth;
    lowerBoundary = levelData.levelHeight;

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
    
    
    currVelocity = new PVector(0.0, 0.0);
    gravityAcc = new PVector(0.0, 10.0);
    
    walkingSpeed = 10;
    jumpHeight = 10;

    // set initial state of avatar
    sprite.setImages("run", run);
    sprite.setFlipH(true);

    alive = true;
    doubleJumpEnabled = true;
    chuteActive = false;
    collisionInProgress = false;
    flagRaised = false;
  }


  public PImage playerRender()
  {
    if(alive)
    {
      if(keyTracker.upPressed() && (keyTracker.leftPressed() || keyTracker.recentHorizontalKeyId() == KeyTracker.LEFT_ID || keyTracker.recentHorizontalKeyId() == null))
      {
        sprite.setImages("jump", jump, false);
        sprite.setFlipH(true);
      }
      else if(keyTracker.upPressed() && (keyTracker.rightPressed() || keyTracker.recentHorizontalKeyId() == KeyTracker.RIGHT_ID))
      {
        sprite.setImages("jump", jump, false);
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
        
        sprite.setImages("idle", idle, 15);
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
    if ( doubleJumpEnabled && !chuteActive) {
      //println("JUMP");
      if ( currVelocity.y <= 0.1 && currVelocity.y > -0.1 ) //enable jumping only if player is not moving in y direction(already jumping or falling)
      { 
        currVelocity.y = -jumpHeight; //FIXME: optimize double jump here
        music.sound("jump");
        //println("CAN DOUBLEJUMP: " + doubleJumpEnabled);
        doubleJumpEnabled = !doubleJumpEnabled;
      }
    }
  }
  
  
  public void updatePosition()
  {
    if (alive)
    {
      PVector tmpPos = PVector.add(position,currVelocity);
      if ( tmpPos.x > 0 && tmpPos.x < levelWidth-30) //only move if velocity doesn't push player out of level
        position.x = tmpPos.x;
      if ( tmpPos.y < lowerBoundary || tmpPos.y > 0)
        position.y = tmpPos.y;
    }
  }
  
  
  public void updateVelocity()
  {
    updateVelocity(0,0);
  }
  
  
  public void updateVelocity(float x, float y)
  {
    speedMax = 10;
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
        if ( currVelocity.x >= walkingSpeed*-1)
          currVelocity.x += -acceleration;
        if (chuteActive) 
          speedMax = 21;
      }
      if(keyTracker.rightPressed())
      {
        if (currVelocity.x <= walkingSpeed)
          currVelocity.x += acceleration;
        if (chuteActive) 
          speedMax = 21;
      }
      if(keyTracker.upPressed()) //enable double jump here, to disable set to 0
      {
        jump();
      }
    }
    // if neither gamepad is moved nor keypresses are detected - slow down player
    else
    {
      currVelocity.x *= 0;
    }
       
    //calculate gravity vector
    PVector tmpAccel = PVector.mult(gravityAcc, 1.0/30.0); //calculate gravitational Acceleration, assuming 30fps/can later be adjusted to use realtime for better simulation
       
     //apply gravity
     if (position.y < lowerBoundary-100)
       currVelocity.add(tmpAccel);  
  
      if ( chuteActive && currVelocity.y > speedMax )
        currVelocity.y = speedMax;
     
     // println(currVelocity.y);
  }
  
  
  public void handleCollision(Collision c)
  {
    //doubleJumpEnabled = true;
    if (collisionInProgress == false)
    {
      //println("COLLISION");
      collisionInProgress = true;
    
      doubleJumpEnabled = true;
      if ( c.direction == 1 || c.direction == 5 ) //left/top-left/bottom-left
      {
        if ( currVelocity.x > 0 ) ///if player moves to the right 
          currVelocity.x *= -1;
      }
      
      if ( c.direction == 8 || c.direction == 12 ) //right/top-right/bottom-right
      {
        if ( currVelocity.x < 0 ) // player moves to the left
          currVelocity.x *= -1;
      }
      
      if ( c.direction != 1 || c.direction != 8 ) //left-top, top, right-top
      {
        if ( currVelocity.y > 0 ) //player is falling
        {
          if ( currVelocity.y <= 20)
          { 
            currVelocity.y = 0f;
            position.y = c.getCollider().getBounds().top - avatar.height;
          }
          else
          {
            alive = false;
          } 
        }
        else doubleJumpEnabled = false;
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

      print(c.getCollider() + " ");

      // check for flag
      if (c.getCollider().isFlag())
      {
        Flag flag = (Flag) c.getCollider();
        flag.setActive();

        flagRaised = true;
        chuteActive = true;
      }

      if (c.getCollider().isEnemy())
      {
        if (alive)
        {
          alive = false;
          music.sound("dead");
         // println(this + " ENEMY COLLISION _ YOU'RE DEAD");
        }
      }
       
      /*if (c.getCollider().isParachute())
      {
        chuteActive = true;
      }*/

      collisionInProgress = false;
    }
  }
}



public class Enemy extends Actor
{
  float speed;
  float leftBoundary, rightBoundary;
  PImage[] sprites;
  PVector size, direction;
  boolean playerSpotted;
  
  
  public Enemy(PImage[] sprites, PVector position, float leftBoundary, float rightBoundary, float walkingSpeed, float runningSpeed)
  {
    this.sprites = sprites;
    this.startPosition = position;
    this.leftBoundary = leftBoundary;
    this.rightBoundary = rightBoundary;
    this.walkingSpeed = walkingSpeed;
    this.runningSpeed = runningSpeed;

    // direction normals vector - used for multiplication of speed
    direction = new PVector(0, 0);
    
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

    direction.x = 1;
    speed = walkingSpeed;
    playerSpotted = false;
  }
    
    
  public boolean isEnemy()
  {
    return true;
  }


  public PImage enemyRender()
  {
    //println(this + " render() : walkingSpeed: " + walkingSpeed);

    // flip sprite images according to direction
    if (direction.x > 0)
    {
      sprite.setFlipH(false);
    } 
    else if (direction.x < 0)
    {
      sprite.setFlipH(true);
    }
    sprite.render();

    return avatar;
  }


  public void patroling(Player player)
  {
    // does the enemy see the player
    if(spottedThePlayer(player))
    {
      playerSpotted = true;
      speed = runningSpeed;
    }
    else
    {
      playerSpotted = false;

      // add random enemy movement
      int r = int(random(100));
      switch(r)
      {
        // with chance of 1/100 the enemy will turn around and walk
        // in the other direction before reaching the end of the plattform
        case 0:
          direction.x *= -1;
          speed = walkingSpeed;
          break;
        //with chance of 1/100 the enemy will stand still
        case 1: 
          speed = 0;
          break;
        //with chance of 98/100 the enemy will continue walking
        // in the same direction he was walking before.
        default:
          speed = walkingSpeed;
          break;
      }
    }

    // turn around at the end of platform
    if (reachedEndOfPlattform())
    {
      direction.x *= -1;
    }

    position.add(direction.x * speed, 0, 0);
  }


  private boolean reachedEndOfPlattform()
  {
    //if (position.x <= leftBoundary && walkingSpeed < 0 || position.x >= rightBoundary && walkingSpeed > 0)
    if (position.x <= leftBoundary && direction.x < 0 || position.x >= rightBoundary && direction.x > 0)
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


  private boolean spottedThePlayer(Player player)
  {
    // is player avatar within horizontal boudaries of enemy?
    boolean inHBounds = player.position.x + player.avatar.width >= leftBoundary && player.position.x <= rightBoundary + size.x;
    // is player avatar within vertical boudaries of enemy?
    boolean inVBounds = player.position.y < position.y + size.y && player.position.y + player.avatar.height > position.y;
    // is enemy facing the player?
    boolean facingPlayer = abs((position.x + direction.x * speed) - player.position.x) < abs(position.x - player.position.x);

    return inHBounds && inVBounds && facingPlayer;
  }
}

