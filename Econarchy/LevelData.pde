import java.util.Map;


public class LevelData
{
  String id;
  PVector size;
  int levelWidth;
  int levelHeight;
  private HashMap<String, PImage> imageResources;
  private PlatformSpec[] platformSpecs;
  private EnemySpec[] enemySpecs;
  private String[] backgroundIds;


  public LevelData(XML data)
  {
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
      image = loadImage(xml.getString("url"));
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
        println("ERROR: Unknown platform type defined in XML: " + platformXML.getString("type"));
      }
      else
      {
        platformSpecs[i] = new PlatformSpec(platformXML.getString("id"), platformType, platformXML.getInt("x"), platformXML.getInt("y"));
      }
    }
    
    // parse enemies
    XML[] enemiesXML = data.getChild("specification").getChild("enemies").getChildren("enemy");
    enemySpecs = new EnemySpec[enemiesXML.length];
    
    XML enemyXML;
    for(int i = 0; i < enemiesXML.length; i++)
    {
      enemyXML = enemiesXML[i];
      enemySpecs[i] = new EnemySpec(enemyXML.getString("platformId"), enemyXML.getFloat("walkingSpeed"), enemyXML.getFloat("runningSpeed"), enemyXML.getFloat("startPosition"));
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
  
  
  public String[] getBackgroundIds()
  {
    return backgroundIds;
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


  public EnemySpec[] getEnemySpecs()
  {
    return enemySpecs;
  }
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

public class EnemySpec
{
  private String platformId;
  private float walkingSpeed;
  private float runningSpeed;
  private float startPosition;
  
  public EnemySpec(String platformId, float walkingSpeed, float runningSpeed, float startPosition)
  {
    this.platformId = platformId;
    this.walkingSpeed = walkingSpeed;
    this.runningSpeed = runningSpeed;
    this.startPosition = startPosition;
  }
  
  public String getPlatformId()
  {
    return this.platformId;
  }
  
  public float getWalkingSpeed()
  {
    return this.walkingSpeed;
  }
  
  public float getRunningSpeed()
  {
    return this.runningSpeed;
  }
  
  public float getStartPosition()
  {
    return this.startPosition;
  }
}

