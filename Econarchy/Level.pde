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
    LevelBoundary top =  new LevelBoundary(-50.0, -50.0, (float) data.levelWidth + 100.0, 50.0);
    LevelBoundary bottom = new LevelBoundary(-50.0,(float) data.levelHeight,(float)data.levelWidth+100.0, 50.0);
    LevelBoundary left = new LevelBoundary(-data.levelWidth/2,-50,data.levelWidth/2, (float) data.levelHeight+200);
    LevelBoundary right = new LevelBoundary((float) data.levelWidth, -50.0, data.levelWidth/2, (float) data.levelHeight+100);

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



