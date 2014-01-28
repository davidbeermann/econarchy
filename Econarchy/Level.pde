public class Level
{
  LevelData data;
  PGraphics renderedImage;
  Platform[] platforms;
  Player hans;
  Enemy[] enemies;
  CollisionDetector collider;
  

  // gradient variables - TO BE DELETED
  int Y_AXIS = 1;
  int X_AXIS = 2;

  // define global level settings in xml driven data class
  public Level(LevelData data)
  {
    this.data = data;
    //divided and moved the level and actor loading into these methods
    createLevel();
    createActors();
  }


  public void createLevel()
  {
    //setupLevelBoundaries();
     LevelBoundary top =  new LevelBoundary(-50.0, -50.0, (float) data.levelWidth + 100.0, 50.0);
     LevelBoundary bottom = new LevelBoundary(-50.0,(float) data.levelHeight,(float)data.levelWidth+100.0, 50.0);
     LevelBoundary left = new LevelBoundary(-50.0,0.0,50.0, (float) data.levelHeight);
     LevelBoundary right = new LevelBoundary((float) data.levelWidth, 0.0, 50.0, (float) data.levelHeight);
     LevelBoundary[] levelBounds = new LevelBoundary[]{top, bottom,left,right};
                                                  
    //setup CollisionDetection with level boundaries
    collider = new CollisionDetector(levelBounds);

    // setup main level graphic
    renderedImage = createGraphics((int) data.size.x, (int) data.size.y);

    // setup platforms
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

    collider = new CollisionDetector(platforms);
  }


  public void createActors()
  {
    collider = new CollisionDetector(platforms);

    collider.addCollidables(platforms);

    // setup enemies
    enemies = new Enemy[data.getEnemyVOs().length];
    for(int i = 0; i < data.getEnemyVOs().length; i++)
    {
      LevelData.EnemyVO enemyVO = data.getEnemyVOs()[i];
      LevelData.EnemySpriteVO spriteVO = data.getEnemySpriteVO(enemyVO.spriteId);
      PImage[] sprites = data.getImageResources(spriteVO.imageIds);
      Platform platform = getPlatformById(enemyVO.platformId);
      //System.out.println(sprites);
      //System.out.println(sprites.length);
      
      float leftBoundary = platform.getPosition().x;
      float rightBoundary = platform.getPosition().x + platform.getSize().x - sprites[0].width;
      PVector position = new PVector(leftBoundary + rightBoundary * enemyVO.startPosition, platform.getPosition().y - sprites[0].height);
      
      enemies[i] = new Enemy(sprites, position, leftBoundary, rightBoundary, enemyVO.walkingSpeed, enemyVO.runningSpeed);
    }
    collider.addCollidables(enemies);

    //playerAvatar size is currently 30 x 30 therefore x-15 and y-30
    hans = new Player(new PVector(renderedImage.width/2 -15, renderedImage.height-30, 0));
  }


  public void render()
  {
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
        //handing over hans position to determine if the enemy is seeing hans
        enemies[i].patroling(hans);
        
        renderedImage.image( enemies[i].enemyRender(), enemies[i].position.x, enemies[i].position.y);
      } 
    }
    
    // render player last to be on top of everything else
    renderedImage.image(hans.playerRender(), hans.position.x, hans.position.y);

    renderedImage.endDraw();
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



