import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import processing.core.PApplet;
import processing.core.PImage;
import processing.core.PVector;
import processing.data.XML;


public class LevelData
{
  private static LevelData instance = null;
  PApplet applet;
  String id;
  PVector size;
  int levelWidth;
  int levelHeight;
  private HashMap<String, PImage> imageResources;
  private HashMap<String, EnemySpriteVO> enemySpriteVos;
  private PlatformSpec[] platformSpecs;
  private PlayerSpriteVO playerSpriteVO;
  private EnemyVO[] enemyVOs;
  private String[] backgroundIds;
  private String[] foregroundIds;
  
  
  public static LevelData instantiate(PApplet applet, XML data)
  {
    if(instance == null)
    {
      instance = new LevelData(applet, data);
    }
    return instance;
  }
  
  
  public static LevelData getInstance()
  {
    return instance;
  }


  private LevelData(PApplet applet, XML data)
  {
    this.applet = applet;
    
    id = data.getString("id");
    size = new PVector(data.getInt("width"), data.getInt("height"));

    // ----- PARSE RESOURCES -----
    // ---------------------------

    // parse and load image resources
    XML[] imagesXML = data.getChild("resources").getChild("images").getChildren("image");
    imageResources = new HashMap<String, PImage>(); 

    PImage image;
    for (XML xml : imagesXML)
    {
      image = applet.loadImage(xml.getString("url"));
      imageResources.put(xml.getString("id"), image);
    }

    // ----- PARSE SPECIFICATIONS -----
    // --------------------------------
    
    // parse background ids
    XML[] backgroundsXML = data.getChild("specification").getChild("backgrounds").getChildren("background");
    backgroundIds = new String[backgroundsXML.length];
    
    for(int i = 0; i < backgroundsXML.length; i++)
    {
      backgroundIds[i] = backgroundsXML[i].getString("id");
    }
    
    // parse foreground ids
    XML[] foregroundsXML = data.getChild("specification").getChild("foregrounds").getChildren("foreground");
    foregroundIds = new String[foregroundsXML.length];
    
    for(int i = 0; i < foregroundsXML.length; i++)
    {
      foregroundIds[i] = foregroundsXML[i].getString("id");
    }

    // parse platforms
    XML[] platformsXML = data.getChild("specification").getChild("platforms").getChildren("platform");
    platformSpecs = new PlatformSpec[platformsXML.length];

    XML platformXML;
    Type.Platform platformType = null;
    for (int i = 0; i < platformsXML.length; i++)
    {
      platformXML = platformsXML[i];

      // convert string value into enum type
      // http://stackoverflow.com/questions/604424/java-convert-string-to-enum
      try
      {
        platformType = Type.Platform.valueOf(platformXML.getString("type").toUpperCase());
      }
      catch(IllegalArgumentException e)
      {
      }

      if (platformType == null)
      {
        applet.println("ERROR: Unknown platform type defined in XML: " + platformXML.getString("type"));
      }
      else
      {
        platformSpecs[i] = new PlatformSpec(platformXML.getString("id"), platformType, platformXML.getInt("x"), platformXML.getInt("y"));
      }
    }

    // parse player sprites
    XML playerSprite = data.getChild("specification").getChild("player_sprite");
    playerSpriteVO = new PlayerSpriteVO(
      playerSprite.getChild("runFrames").getString("imageIds").split(","),
      playerSprite.getChild("jumpFrames").getString("imageIds").split(","),
      playerSprite.getChild("idleFrames").getString("imageIds").split(","),
      playerSprite.getChild("dieFrames").getString("imageIds").split(",")
    );

    // parse enemy sprites
    enemySpriteVos = new HashMap<String, EnemySpriteVO>();
    XML[] enemySprites = data.getChild("specification").getChild("enemy_sprites").getChildren("enemy_sprite");
    for(XML enemySprite : enemySprites)
    {
      String id = enemySprite.getString("id");
      String[] imageIds = enemySprite.getString("imageIds").split(",");
      //System.out.println(imageIds);
      //System.out.println(imageIds.length);
      enemySpriteVos.put(id, new EnemySpriteVO(id, imageIds));
    }
    
    // parse enemies
    XML[] enemiesXML = data.getChild("specification").getChild("enemies").getChildren("enemy");
    enemyVOs = new EnemyVO[enemiesXML.length];
    
    XML enemyXML;
    for(int i = 0; i < enemiesXML.length; i++)
    {
      enemyXML = enemiesXML[i];
      enemyVOs[i] = new EnemyVO(
        enemyXML.getString("spriteId"),
        enemyXML.getString("platformId"),
        enemyXML.getFloat("walkingSpeed"),
        enemyXML.getFloat("runningSpeed"),
        enemyXML.getFloat("startPosition")
      );
    }
  }


  public PImage getImageResource(String id)
  {
    if (imageResources.containsKey(id))
    {
      return imageResources.get(id);
    }
    else
    {
      return null;
    }
  }


  public PImage[] getImageResources(String[] ids)
  {
    ArrayList<PImage> tmp = new ArrayList<PImage>();
    for(String id : ids)
    {
      if (imageResources.containsKey(id))
      {
        tmp.add(imageResources.get(id));
      }
      else
      {
        System.out.println("WARNING : image with id " + id + " is not a valid resource.");
      }
    }

    PImage[] output = new PImage[tmp.size()];
    return tmp.toArray(output);
  }
  
  
  public String[] getBackgroundIds()
  {
    return backgroundIds;
  }
  
  
  public String[] getForegroundIds()
  {
    return foregroundIds;
  }


  public PlatformSpec[] getPlatformSpecs()
  {
    return platformSpecs;
  }


  public PlatformSpec getPlatformSpecById(String id)
  {
    PlatformSpec platformSpec = null;
    for(PlatformSpec spec : platformSpecs)
    {
      if(spec.getId() == id)
      {
        platformSpec = spec;
        break;
      }
    }
    return platformSpec;
  }


  public PlayerSpriteVO getPlayerSpriteVO()
  {
    return playerSpriteVO;
  }


  public EnemySpriteVO getEnemySpriteVO(String id)
  {
    return enemySpriteVos.get(id);
  }


  public EnemyVO[] getEnemyVOs()
  {
    return enemyVOs;
  }
  
  
  public class PlatformSpec
  {
    private String id;
    private Type.Platform type;
    private PVector position;
  
    public PlatformSpec(String id, Type.Platform type, int xPos, int yPos)
    {
      this.id = id;
      this.type = type;
      this.position = new PVector(xPos, yPos);
    }
    
    public String getId()
    {
      return this.id;
    }
  
    public Type.Platform getType()
    {
      return this.type;
    }
  
    public PVector getPosition()
    {
      return this.position;
    }
  }

  public class PlayerSpriteVO
  {
    public String[] runIds;
    public String[] jumpIds;
    public String[] idleIds;
    public String[] dieIds;

    public PlayerSpriteVO(String[] runIds, String[] jumpIds, String[] idleIds, String[] dieIds)
    {
      this.runIds = runIds;
      this.jumpIds = jumpIds;
      this.idleIds = idleIds;
      this.dieIds = dieIds;
    }
  }

  public class EnemySpriteVO
  {
    public String id;
    public String[] imageIds;

    public EnemySpriteVO(String id, String[] imageIds)
    {
      this.id = id;
      this.imageIds = imageIds;
    }
  }
  
  public class EnemyVO
  {
    public String spriteId, platformId;
    public float walkingSpeed, runningSpeed, startPosition;
    
    public EnemyVO(String spriteId, String platformId, float walkingSpeed, float runningSpeed, float startPosition)
    {
      this.spriteId = spriteId;
      this.platformId = platformId;
      this.walkingSpeed = walkingSpeed;
      this.runningSpeed = runningSpeed;
      this.startPosition = startPosition;
    }
  }
}

