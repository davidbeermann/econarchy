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
    
    // setup main level graphic
    renderedImage = createGraphics((int) data.size.x, (int) data.size.y);

    // setup platforms
    platforms = new Platform[data.getPlatformSpecs().length];
    PlatformSpec platformSpec;
    for (int i = 0; i < data.getPlatformSpecs().length; i++)
    {
      platformSpec = data.getPlatformSpecs()[i];
      if (platformSpec != null)
      {
        platforms[i] = new Platform(platformSpec.getId(), platformSpec.getType(), platformSpec.getPosition(), data.getImageResource(platformSpec.getType().toString()));
      }
    }
    collider = new CollisionDetector(platforms);
      
    // setup enemies
    PImage enemyImage = loadImage("devEnemy.png");
    enemies = new Enemy[data.getEnemySpecs().length];
    for(int i = 0; i < data.getEnemySpecs().length; i++)
    {
      EnemySpec enemySpec = data.getEnemySpecs()[i];
      Platform platform = getPlatformById(enemySpec.getPlatformId());
      println(enemySpec);
      println(platform);
      
      float leftBoundary = platform.getPosition().x;
      float rightBoundary = platform.getPosition().x + platform.getSize().x - enemyImage.width;
      PVector position = new PVector(leftBoundary + rightBoundary * enemySpec.getStartPosition(), platform.getPosition().y - enemyImage.height);
      
      enemies[i] = new Enemy(position, leftBoundary, rightBoundary, enemySpec.getWalkingSpeed(), enemySpec.getRunningSpeed(), enemyImage);
    }
    collider.addCollidables(enemies);

    //playerAvatar size is currently 30 x 30 therefore x-15 and y-30
    hans = new Player(new PVector(renderedImage.width/2 -15, renderedImage.height-30, 0));
    
    /*
    enemies = new Enemy[3];
    for (int i=0; i < 3; i++)
    {
      enemies[i] = new Enemy(new PVector(random(renderedImage.width), random(renderedImage.height-30, renderedImage.height-300), 0));
    }
    */
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

    renderedImage.image(hans.playerRender(), hans.position.x, hans.position.y);

    for (int i=0; i < enemies.length; i++)
     {
        
       if (enemies[i].isInViewport(hans.position)) {
        //handing over hans position to determine if the enemy is seeing hans
         enemies[i].patroling(hans);
       
       renderedImage.image( enemies[i].enemyRender(), enemies[i].position.x, enemies[i].position.y);
       }
       
       
     }

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



