import java.util.Map;


public class LevelData
{
  String id;
  PVector size;
  int levelWidth;
  int levelHeight;
  private HashMap<String, PImage> imageResources;
  private PlatformSpec[] platformSpecs;
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
        platformSpecs[i] = new PlatformSpec(platformType, platformXML.getInt("x"), platformXML.getInt("y"));
      }
    }
    
    // parse background ids
    XML[] backgroundsXML = data.getChild("specification").getChild("backgrounds").getChildren("background");
    backgroundIds = new String[backgroundsXML.length];
    
    for(int i = 0; i < backgroundsXML.length; i++)
    {
      backgroundIds[i] = backgroundsXML[i].getString("id");
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


  public PlatformSpec[] getPlatformSpecs()
  {
    return platformSpecs;
  }
  
  
  public String[] getBackgroundIds()
  {
    return backgroundIds;
  }
}


public class PlatformSpec
{
  private Type.Platform type;
  private PVector position;

  public PlatformSpec(Type.Platform type, int xPos, int yPos)
  {
    this.type = type;
    this.position = new PVector(xPos, yPos);
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

