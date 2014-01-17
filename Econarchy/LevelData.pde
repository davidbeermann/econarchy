import java.util.Map;


public class LevelData
{
  String id;
  PVector size;
  int levelWidth;
  int levelHeight;
  private HashMap<String, PImage> imageResources;
  private PlatformSpec[] platformSpecs;

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

    println(imageResources);
    println(imageResources.values());

    // ----- PARSE SPECIFICATIONS -----
    // --------------------------------

    // parse platforms
    XML[] platformsXML = data.getChild("specification").getChild("platforms").getChildren("platform");
    platformSpecs = new PlatformSpec[platformsXML.length];

    XML platformXML;
    for (int i = 0; i < platformsXML.length; i++)
    {
      platformXML = platformsXML[i];
      platformSpecs[i] = new PlatformSpec(platformXML.getString("id"), platformXML.getInt("x"), platformXML.getInt("y"));
    }
  }
}


public class PlatformSpec
{
  private String id;
  private PVector position;

  public PlatformSpec(String id, int xPos, int yPos)
  {
    this.id = id;
    this.position = new PVector(xPos, yPos);
  }

  public String getId()
  {
    return this.id;
  }

  public PVector getPosition()
  {
    return this.position;
  }
}

