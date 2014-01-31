import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import procontroll.*; 
import net.java.games.input.*; 
import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Econarchy extends PApplet {

boolean gamepadEnabled = false;
Game game;
KeyTracker keyTracker;
FancyInput gamepad;
SoundEvent music;


public void setup()
{
  size(400, 740);

  XML levelXML = loadXML("level1.xml");
  LevelData levelData = LevelData.instantiate(this, levelXML);

  PVector gameSize = new PVector(400, 700);
  PVector gamePosition = new PVector(0, height - gameSize.y);

  game = new Game(gameSize, gamePosition);
  game.init();

  music = new SoundEvent(this);

  //setup gamepad if needed
  if (gamepadEnabled)
  {
    gamepad = new FancyInput("controls.xml", this);
  }
  else
  {
    keyTracker = KeyTracker.getInstance();
  }
}


public void draw()
{ 
  //println(this + " frameRate: " + frameRate);

  background(0);

  if (gamepadEnabled)
  {
    gamepad.update();
  }

  game.render();
}


public void stop()
{
  music.minim.stop();
}


public void keyPressed(KeyEvent e)
{
  if (!gamepadEnabled)
  {
    keyTracker.addKey(keyCode);
  }
}


public void keyReleased(KeyEvent e)
{
  if (!gamepadEnabled)
  {
    keyTracker.removeKey(keyCode);
  }
}

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
  float acceleration = 0.5f;
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
    
    
    currVelocity = new PVector(0.0f, 0.0f);
    gravityAcc = new PVector(0.0f, 10.0f);
    
    walkingSpeed = 10;
    jumpHeight = 10;

    // set initial state of avatar
    sprite.setImages("run", run);
    sprite.setFlipH(true);

    alive = true;
    doubleJumpEnabled = true;
    chuteActive = false;
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
      if ( currVelocity.y <= 0.1f && currVelocity.y > -0.1f ) //enable jumping only if player is not moving in y direction(already jumping or falling)
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
      PVector tmpPos = PVector.add(position,currVelocity);
      if ( tmpPos.x > 1 && tmpPos.x < levelWidth) //only move if velocity doesn't push player out of level
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
      currVelocity.x *= 0.8f;
    }
       
    //calculate gravity vector
    PVector tmpAccel = PVector.mult(gravityAcc, 1.0f/30.0f); //calculate gravitational Acceleration, assuming 30fps/can later be adjusted to use realtime for better simulation
       
     //apply gravity
    // if (position.y < lowerBoundary)
       currVelocity.add(tmpAccel);  
  
      if ( chuteActive && currVelocity.y > speedMax )
        currVelocity.y = speedMax;
     
      println(currVelocity.y);
  }
  
  
  public void handleCollision(Collision c)
  {
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
      if ( currVelocity.y > 0 ) { //player is falling
        if ( currVelocity.y <= 20) { 
          currVelocity.y = 0f;
          position.y = c.getCollider().getBounds().top - avatar.height;
        }
        else 
          alive = false;
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

    if (c.getCollider().isEnemy())
    {
      if (alive)
      {
        alive = false;
        music.sound("dead");
       // println(this + " ENEMY COLLISION _ YOU'RE DEAD");
      }
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
      speed = walkingSpeed;
      
      // add random enemy movement
      /*int r = int(random(100));
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
      }*/
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
    boolean inVBounds = player.position.y < position.y + size.y && player.position.y + player.avatar.height > position.y;
    // is enemy facing the player?
    boolean facingPlayer = abs((position.x + direction.x * speed) - player.position.x) < abs(position.x - player.position.x);

    return inHBounds && inVBounds && facingPlayer;
  }
}

public class CollisionDetector
{
 ArrayList<Collidable> static_colliders;
  

  public CollisionDetector()
  {
    static_colliders = new ArrayList<Collidable>();
  }
  

  public void addCollidables(Collidable[] collidables)
  {
    for (int i = 0; i < collidables.length; i++)
    {
      if(static_colliders.contains(collidables[i]))
      {
        println(this + " WARNING: tried to add instance " + collidables[i] + " twice");
      }
      else
      {
       //println( "ADDING COLLIDER: " + collidables[i].getBounds().x);
        static_colliders.add(collidables[i]);
      }
    }
  }
    
  
  // inspired by http://stackoverflow.com/questions/4354591/intersection-algorithm
  private boolean intersects(BoundingBox a, BoundingBox b) {
    BoundingBox tempBox = BoundingBox.getBoundingBox(a,b);
    //println("BOX B:" + a);
    if ( (tempBox.width < a.width+b.width) && (tempBox.height < a.height+b.height)) {
      //println("TEST");
      return true;}
    else
      return false;
  }
  
  // inspired by http://stackoverflow.com/questions/4354591/intersection-algorithm
  /* Returns directions as follows:
     coll from left - 1;
     coll from top  - 2;
     coll from bottom - 4;
     coll from right - 8; bottom right: 12, bottom left:5, bottom 4
     other directions sum of directions */
  private int intersectsDirectional(BoundingBox source, BoundingBox target) {
    int direction = 0;
    BoundingBox tempBox = BoundingBox.getBoundingBox(source,target);
    //println("BOX B:" + a);
    if ( (tempBox.width < source.width+target.width) && (tempBox.height < source.height+target.height)) {
      //determine direction
      if ( source.left < target.right && source.right > target.right ) //right
        direction += 8;
      if ( source.top < target.top && source.bottom > target.top ) //top
        direction += 2;
      if ( source.top < target.bottom && source.bottom > target.bottom ) // bottom
        direction += 4;
      if ( source.left < target.left && source.right > target.left ) //left
        direction += 1;
      }
      return direction;
  }
  
  public void checkCollisions(Collidable a) {
    BoundingBox commonBound;
    BoundingBox tmpBounding = a.getBounds();
    for (int i=0; i<static_colliders.size(); i++){
      //println("ITERATING");
      //if ( intersects(tmpBounding, static_colliders.get(i).getBounds())) {
      int dir = intersectsDirectional(tmpBounding, static_colliders.get(i).getBounds());
      if ( dir != 0 ) 
         a.handleCollision(new Collision(static_colliders.get(i), dir));
     //}
    }
  }
}


//preliminary Collision class, needs to be enhanced and extended
public class Collision {
  Collidable collidedWith;
  int direction;
  
  public Collision(Collidable b) {
      collidedWith = b;
  }
  
  public Collision(Collidable b, int dir) {
     collidedWith = b;
     direction = dir;
  } 

  public Collidable getCollider() {
    return collidedWith;
  }
}


//super uber class to enable collision detection
public class Collidable
{  
  public Collidable()
  {}
  
  public boolean isEnemy()
  {
    return false;
  }
  
  public boolean isPlatform()
  {
    return false;
  }
  
  //return empty bounding box
  public BoundingBox getBounds()
  {
    return new BoundingBox(0,0,0,0);
  }
  
  public void handleCollision(Collision c)
  {}
}
  
  
// boundingbox of object 
public static class BoundingBox
{
  float left=0, top=0, bottom=0, right=0,x,y;
  float width=0;
  float height=0;

  
  public BoundingBox(float lcor, float tcor, float rcor, float bcor) {
    x = left = lcor;
    right = rcor;
    y = top = tcor;
    bottom = bcor;
    width = right-left;
    height = bottom-top;
  }

  // wrapper constructor for direct support of sizes supplied as vectors
  public BoundingBox(PVector xy, PVector wh)
  {
    updateDimensions(xy, wh);
  }
  
  public void updateDimensions(PVector xy, PVector wh)
  {
    x = left = xy.x;
    y = top = xy.y;
    width = wh.x;
    height = wh.y;
    right = left+width;
    bottom = top+height;
  }
  
  // get the resulting bounding box of the supplied boxes
  public static BoundingBox getBoundingBox(BoundingBox box1, BoundingBox box2) {
//    println("Box1.x: " + box1.x + " Box1.y: " + box1.y + " box1.width: " + box1.width + " box1.height: " + box1.height); 
//    println("Box2.x: " + box2.x + " Box2.y: " + box2.y + " box2.width: " + box2.width + " box2.height: " + box2.height); 
//    println("MIN.x: " + min(box1.x, box2.x) + " MIN.y: " + min(box1.y, box2.y));
    return new BoundingBox(min(box1.left, box2.left), min(box1.top, box2.top), max(box1.width+box1.left, box2.left+box2.width), max(box1.height+box1.top, box2.height+box2.top));
  }
  
}

 //enable these imports for gamepad support

public class FancyInput {
//AWESOME FEATURE (needs procontroll library)
ControllIO controll;
ControllDevice pad;
ControllSlider horizontalSlider;
String controller_id;
boolean rumbleEnabled = false;

// Setup inputs 
public FancyInput(String path, Econarchy that) {
    XML controller_xml = loadXML(path);
    
    //setup joystick/gamepad
    controll = ControllIO.getInstance(that);
    controller_id = controller_xml.getString("id");
    println("Using the following controller: " + controller_id);
    
    pad = controll.getDevice(controller_id);
    
    XML[] buttons = controller_xml.getChild("inputs").getChild("buttons").getChildren("button");
    
    // iterate through button definitions from config
    for(int i=0; i<buttons.length;i++) 
      pad.plug(game.level.hans, buttons[i].getString("map_to"), ControllIO.ON_PRESS, buttons[i].getInt("id"));
      
    // setup slider for left/right movement
    XML[] sliderXML = controller_xml.getChild("inputs").getChild("sliders").getChildren("slider");
    
    // iterates over sliders if multiples are defined, currently useless
    for (int i=0; i<sliderXML.length; i++) {
      horizontalSlider = pad.getSlider(sliderXML[i].getInt("id"));
      horizontalSlider.setTolerance(sliderXML[i].getChild("tolerance").getFloat("value"));
  }
  
  // setup controller special properties
  XML[] metaXML = controller_xml.getChild("meta-data").getChildren("meta-entry");
  
  for (int i=0; i<metaXML.length; i++) {
    String metaEntry = metaXML[i].getString("type");
   if (metaEntry == "rumble_enabled") 
    rumbleEnabled = new Boolean(metaXML[i].getString("value"));
   else
    println("INVALID CONTROLLER XML OR FEATURE NOT YET IMPLEMENTED");
  }
}
  
  //update everything not caught with button presses here(analoq sticks etc)
  public void update() {
  //   for x in y do stuff;
    game.level.hans.updateVelocity(horizontalSlider.getValue(),0);
  }
}
public class GUI
{
	PFont pixelFont;
	int frame, size, points, meterToGo, levelHeight, overlayPosY;
	float playerpos;
	Player player;
	boolean sawInfoScreen;
	PImage gameoverOverlay;


	public GUI (Player p)
	{
		player = p;
		frame=0;
		size=0;
		points= 0;
		meterToGo = 0;
		levelHeight = PApplet.parseInt(player.position.y / player.jumpHeight); 
		playerpos = player.position.y;
		pixelFont = loadFont("resources/fonts/Unibody8Pro-RegularItalic-20.vlw");
		sawInfoScreen = false;
	}


	public void update()
	{
		introScreen();
		gameOver();
		storyCounter();
	}


	public void storyCounter()
	{
		if (!game.gameOver)
		{
			meterToGo = levelHeight - PApplet.parseInt((playerpos - player.position.y)/player.jumpHeight);
			
			noStroke();
			fill(216, 18, 63);
			rect(0, 0, width, 40);
			
			fill(255);
			textAlign(LEFT,TOP);
			textFont(pixelFont, 20);
			text(meterToGo+" m to go", 10, 10);
		}
	}


	public void introScreen()
	{
		if (game.gameOver && !sawInfoScreen)
		{
			PImage startscreen = loadImage("resources/screens/startscreen.png");
			image(startscreen, 0, 0);

			if (keyPressed && key == ' ')
			{
				game.startGame();
				sawInfoScreen = true;
			}
		}
	}


	public void gameOver()
	{
		if (!player.alive) 
		{
			if(gameoverOverlay == null)
			{
				gameoverOverlay = loadImage("resources/screens/gameoverOverlay.png");
			}

			if(!game.gameOver)
			{
				game.gameOver = true;
				overlayPosY = -gameoverOverlay.height;
			}

			PImage main = loadImage("resources/screens/gameover.png");
			image(main, 0, 0);

			if(overlayPosY < 0) overlayPosY += 6;
			image(gameoverOverlay, 0, overlayPosY);

			if (keyPressed)
			{
				if (key == 'y' || key == 'Y')
				{
					game.startGame();
				}
				else if (key == 'n' || key == 'N')
				{
					exit();
				}
			}
		}
	}
}
public class Game
{
  private PGraphics viewport;
  private PVector viewportPosition;
  Parallax background, foreground;
  private Level level;
  GUI guiStuff;
  boolean gameOver = true;
  
  
  public Game(PVector viewportSize, PVector viewportPosition)
  {
    viewport = createGraphics((int) viewportSize.x, (int) viewportSize.y);
    viewport.beginDraw();
    viewport.noStroke();
    viewport.fill(0);
    viewport.rect(0, 0, viewportSize.x, viewportSize.y);
    viewport.endDraw();
    
    this.viewportPosition = viewportPosition;
  }
  
  
  public void init()
  {
    LevelData levelData = LevelData.getInstance();

    background = new Parallax(levelData.getBackgroundIds());
    foreground = new Parallax(levelData.getForegroundIds());
    
    level = new Level();

    if (guiStuff==null)
    {
      guiStuff = new GUI(level.hans);  
    }
    else
    {
      guiStuff.player=level.hans;
    }
  }
  
  
  public void render()
  {
    // render all level updates
    if (!gameOver)
    {
      level.render();
    }

    if (guiStuff.sawInfoScreen)
    {
      // draw rendered level onto viewport
      float posX = (viewport.width - level.renderedImage.width) / 2;
      float posY = (viewport.height - level.hans.position.y);
      // println("percent: " + percent + " / posY: " + posY);
      
      viewport.beginDraw();
      viewport.clear();
      
      // draw background onto viewport
      background.render(viewport, level);
      
      // draw level at correct position onto viewport
      if (posY < (viewport.height - level.renderedImage.height) + viewport.height / 2 - level.hans.avatar.height)
      {
        viewport.image(level.renderedImage, posX, viewport.height - level.renderedImage.height);  
      }
      else if (posY > viewport.height / 2 - level.hans.avatar.height)
      {
        viewport.image(level.renderedImage, posX, 0);  
      }
      else
      {
        viewport.image(level.renderedImage, posX, posY-viewport.height/2+level.hans.avatar.height);   
      }

      foreground.render(viewport, level);
    
      viewport.endDraw();
      
      // draw viewport to frame - actually display rendered result to player
      image(viewport, viewportPosition.x, viewportPosition.y);
    }

    guiStuff.update();
  }


  public void startGame()
  {
    if (guiStuff.sawInfoScreen)
    {
      level.reset();

      //setting the reference in the gui class to new player if the game gets restarted
      guiStuff.player = level.hans;
    }

    gameOver=false;
    level.hans.alive=true;
  }
}


private class Parallax
{
  String[] ids;
  
  public Parallax(String[] ids)
  {
    this.ids = ids;
  }

  public void render(PGraphics viewport, Level level)
  {
    PImage bgImage;
    float percent;
    PVector diff = new PVector();
    for (String id : ids)
    {
      bgImage = LevelData.getInstance().getImageResource(id);
      percent = 1 - (level.hans.position.y + level.hans.avatar.height / 2) / level.renderedImage.height;
      diff.x = viewport.width - bgImage.width;
      diff.y = viewport.height - bgImage.height;

      // println("percent: " + percent + " - diff: " + diff);
      
      viewport.image(bgImage, diff.x / 2, diff.y - percent * diff.y);
    }
  }
}
public class Level
{
  CollisionDetector collider;
  PGraphics renderedImage;
  Platform[] platforms;
  Enemy[] enemies;
  Player hans;


  public Level()
  {
    // initiate CollisionDetection
    collider = new CollisionDetector();

    // setup main level graphic
    LevelData data = LevelData.getInstance();
    renderedImage = createGraphics((int) data.size.x, (int) data.size.y);

    addLevelBoundaries();
    addPlatforms();
    addEnemies();
    addPlayer();
  }


  public void reset()
  {
    for(Platform platform : platforms)
    {
      platform.reset();
    }

    for(Enemy enemy : enemies)
    {
      enemy.reset();
    }

    hans.reset();
  }


  public void render()
  {
    if(!hans.alive)
    {
      return;
    }

    //calculate new velocity for player
    hans.updateVelocity();

    //do collision detection for this frame
    
    //update player position
    hans.updatePosition();
    collider.checkCollisions(hans);

    renderedImage.beginDraw();
    renderedImage.clear();

    for (Platform platform : platforms)
    {
      platform.render(renderedImage);//(int) startY);
    }

    for (int i=0; i < enemies.length; i++)
    {
      if (enemies[i].isInViewport(hans.position))
      {
        // handing over hans position to determine if the enemy is seeing hans
        enemies[i].patroling(hans);
        
        renderedImage.image( enemies[i].enemyRender(), enemies[i].position.x, enemies[i].position.y);

        if(enemies[i].playerSpotted)
        {
          PImage tmp = LevelData.getInstance().getImageResource("spotted");
          int tmpX = PApplet.parseInt(enemies[i].position.x - ((enemies[i].size.x - tmp.width) / 2));
          int tmpY = PApplet.parseInt(enemies[i].position.y - tmp.height);
          renderedImage.image(tmp, tmpX, tmpY);
        }
      } 
    }
    
    // render player last to be on top of everything else
    renderedImage.image(hans.playerRender(), hans.position.x, hans.position.y);

    renderedImage.endDraw();
  }


  private void addLevelBoundaries()
  {
    LevelData data = LevelData.getInstance();

    // calculate level boundaries to collision detection
    LevelBoundary top =  new LevelBoundary(-50.0f, -50.0f, (float) data.levelWidth + 100.0f, 50.0f);
    LevelBoundary bottom = new LevelBoundary(-50.0f,(float) data.levelHeight,(float)data.levelWidth+100.0f, 50.0f);
    LevelBoundary left = new LevelBoundary(-data.levelWidth/2,-50,data.levelWidth/2, (float) data.levelHeight+200);
    LevelBoundary right = new LevelBoundary((float) data.levelWidth, -50.0f, data.levelWidth/2, (float) data.levelHeight+100);

    LevelBoundary[] levelBounds = new LevelBoundary[]{top, bottom,left,right};
    collider.addCollidables(levelBounds);
  }


  private void addPlatforms()
  {
    LevelData data = LevelData.getInstance();

    platforms = new Platform[data.getPlatformSpecs().length];
    LevelData.PlatformSpec platformSpec;
    for (int i = 0; i < data.getPlatformSpecs().length; i++)
    {
      platformSpec = data.getPlatformSpecs()[i];
      if (platformSpec != null)
      {
        platforms[i] = new Platform(platformSpec.getId(), platformSpec.getType(), platformSpec.getPosition(), data.getImageResource(platformSpec.getType().toString()));
      }
    }

    collider.addCollidables(platforms);
  }


  private void addEnemies()
  {
    LevelData data = LevelData.getInstance();

    enemies = new Enemy[data.getEnemyVOs().length];
    for(int i = 0; i < data.getEnemyVOs().length; i++)
    {
      LevelData.EnemyVO enemyVO = data.getEnemyVOs()[i];
      LevelData.EnemySpriteVO spriteVO = data.getEnemySpriteVO(enemyVO.spriteId);
      PImage[] sprites = data.getImageResources(spriteVO.imageIds);
      Platform platform = getPlatformById(enemyVO.platformId);
      
      float leftBoundary = platform.getPosition().x;
      float rightBoundary = platform.getPosition().x + platform.getSize().x - sprites[0].width;
      PVector position = new PVector(leftBoundary + rightBoundary * enemyVO.startPosition, platform.getPosition().y - sprites[0].height);
      
      enemies[i] = new Enemy(sprites, position, leftBoundary, rightBoundary, enemyVO.walkingSpeed, enemyVO.runningSpeed);
    }

    collider.addCollidables(enemies);
  }


  private void addPlayer()
  {
    hans = new Player(LevelData.getInstance().getPlayerSpriteVO());

    PVector position = new PVector(renderedImage.width/2 - hans.avatar.width / 2, renderedImage.height - hans.avatar.height, 0);
    hans.init(position);
  }
  
  
  private Platform getPlatformById(String id)
  {
    Platform platform = null;
    for(Platform p : platforms)
    {
      if(p.getId().equals(id))
      {
        platform = p;
        break;
      }
    }
    return platform;
  }
}


public class LevelBoundary extends Collidable
{
  PVector position;
  PVector size;
  
  public LevelBoundary(float posx, float posy, float w, float h) {
    position = new PVector(posx, posy);
    size = new PVector(w,h);
  }
  
  public BoundingBox getBounds(){
    return new BoundingBox(position, size);
  }
}



//public class Physical extends Actor {
////  boolean upPressed = false;
////  boolean downPressed = false;
////  boolean leftPressed = false;
////  boolean rightPressed = false;
////  //PVector currVelocity, gravityAcc; //velocity and gravity values
////  float lowerBoundary;
////  float speed_max = 10.0;
////  float jumpingForce = 10;
////  
//  public Physical(PVector pos)
//  {
//    ///currVelocity = new PVector(0.0,0.0);
//    //gravityAcc = new PVector(0.0,10.0);
//    // position = new PVector(width/2, height-20, 0);
//    position = pos;
//    //lowerBoundary = position.y;
//    stateGraphic = loadImage("devAvatar.png");
//
//  }
//
////    public void keyPressed(KeyEvent e) {
////    if ( key == CODED ){
////      if (keyCode == UP)
////        upPressed = true;
////      else if (keyCode == DOWN)
////        downPressed = true;
////      else if (keyCode == LEFT)
////        leftPressed = true;
////      else if (keyCode == RIGHT)
////        rightPressed = true;
////    }
////  }
////  
////  public void keyReleased(KeyEvent e) {
////    if ( key == CODED ) {
////      if ( keyCode == UP )
////        upPressed = false;
////      else if ( keyCode == DOWN )
////        downPressed = false;
////      else if ( keyCode == LEFT )
////        leftPressed = false;
////      else if ( keyCode == RIGHT )
////        rightPressed = false;
////    }
////  }
//
//
//  public PImage playerRender()
//  {
//    avatar.beginDraw();
//    avatar.image(stateGraphic,0, 0);
//    avatar.endDraw();
//    return avatar;
//  }
//  
////  public void jump() {
////     if ( currVelocity.y <= 0.5 ) //enable jumping only if player is not moving in y direction(already jumping or falling)
////          currVelocity.y = -jumpingForce;
////  }
////  
////  public void move(float x, float y) {
////    currVelocity.x = x*10;
////    println(x);
////  }
//    
//  public void controlPlayer() {
//    
////     if ( leftPressed||rightPressed||upPressed||downPressed ) {
////     if ( leftPressed ) {
////      println("LEFT PRESSED");
////      currVelocity.x += -0.1; }
////     if ( rightPressed ) {
////     println("RIGHT PRESSED");
////      currVelocity.x += 0.1; }
////     if ( upPressed && currVelocity.y <= 0.1 )
////       currVelocity.y = -jumpingForce;
////     if ( downPressed )
////       currVelocity.y = 0;
////     }
////     else 
////       currVelocity.x *= 0.8;
////    
////    //limit speed
////    if ( currVelocity.mag() >= speed_max ) 
////       currVelocity.setMag(speed_max);
////    
////    position.add(currVelocity); //apply velocity to player
////    
////    PVector tmpAccel = PVector.mult(gravityAcc, 1.0/30.0); //calculate gravitational Acceleration, assuming 30fps/can later be adjusted to use realtime for better simulation
////    println("TMPACCEL IS " +  tmpAccel.x + "     " + tmpAccel.y);
////    
////    
////    if( position.y < lowerBoundary) //only apply gravity if player is inside of level bounds
////       currVelocity.add(tmpAccel);  
////    else
////       currVelocity.y = 0.0; //reset vertical velocity if player hits rock bottom
////   println("CURRVELOCITY: " + currVelocity.x + "   " + currVelocity.y);
//
//  }
//}
public class Platform extends Collidable
{
  private String id;
  private Type.Platform type;
  private PVector position, size;
  private PImage image;
  private BoundingBox box;
  private boolean broken;
  private int breakCount;
  private int alphaValue;
 

  public Platform(String id, Type.Platform type, PVector position, PImage image)
  {
    this.id = id;
    this.type = type;
    this.position = position;
    this.image = image;
    
    reset();
  }


  public void reset()
  {
    size = new PVector(image.width, image.height);
    box = new BoundingBox(position.x, position.y, position.x + image.width, position.y + image.height);

    broken = false;
    breakCount = 0;
    alphaValue = 255;
  }


  public void render(PGraphics output)
  {
    if(broken && alphaValue < 0.5f)
    {
      return;
    }

    if(broken && size.x != 0)
    {
      if(++breakCount > 10)
      {
        size.x = size.y = 0;
        box.updateDimensions(position, size);
      }
    }

    if(size.x != 0)
    {
      output.image(image, position.x, position.y);
    }
    else if(alphaValue > 0.5f)
    {
      alphaValue -= alphaValue * 0.1f;
      
      output.tint(255, alphaValue);
      output.image(image, position.x, position.y);
      output.tint(255, 255);
    }
    else
    { 
      // do nothing here :)
    }
  }
  
  
  public void setBroken()
  {
    broken = true;
  }
  
  
  public String getId()
  {
    return this.id;
  }
  
  
  public PVector getPosition()
  {
    return this.position;
  }
  
  
  public PVector getSize()
  {
    return size;
  }
  
  
  public Type.Platform getType()
  {
    return this.type;
  }
  
  
  @Override
  public boolean isPlatform()
  {
    return true;
  }
  
  
  @Override
  public BoundingBox getBounds()
  {
    return box;
  }
}



public class SoundEvent
{
	boolean enabled = true;
	Minim minim;
	AudioPlayer theme;	
	HashMap<String, AudioSample> fxSounds;	
	

	public  SoundEvent(PApplet applet)
    {
		minim = new Minim(applet);
		
		fxSounds = new HashMap<String, AudioSample>();	
		
		// Put some fancy theme music here
		theme = minim.loadFile("resources/sounds/theme.wav");	
		if(enabled)
		{
			theme.play();
			theme.loop();
		}
	}


	public void sound(String event)
	{	
		AudioSample effect = null;
		String filename = "resources/sounds/" + event + ".wav";
		File f = new File(dataPath(filename));

		if (fxSounds.containsKey(event))
		{
			effect = fxSounds.get(event);
		}
		else if (f.exists())
		{
			effect= minim.loadSample(filename,512);
			fxSounds.put(event, effect);
		}

		if (enabled && effect != null)
		{
			effect.trigger();
		}
	}
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Econarchy" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
