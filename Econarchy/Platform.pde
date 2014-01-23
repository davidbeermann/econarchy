public class Platform
{
  private String id;
  private Type.Platform type;
  private PVector position;
  private PImage image;


  public Platform(String id, Type.Platform type, PVector position, PImage image)
  {
    this.id = id;
    this.type = type;
    this.position = position;
    this.image = image;
  }


  public void render(PGraphics output)
  {
    output.image(image, position.x, position.y);
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
    return new PVector(image.width, image.height);
  }
}

