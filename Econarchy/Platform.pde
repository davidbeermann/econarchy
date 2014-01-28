public class Platform extends Collidable
{
  private String id;
  private Type.Platform type;
  private PVector position, size;
  private PImage image;
  private BoundingBox box;
  private int breakCount = 0;
 

  public Platform(String id, Type.Platform type, PVector position, PImage image)
  {
    this.id = id;
    this.type = type;
    this.position = position;
    this.image = image;
    
    size = new PVector(image.width, image.height);
    box = new BoundingBox(position.x, position.y, position.x + image.width, position.y + image.height);
  }


  public void render(PGraphics output)
  {
    if(size.x != 0)
    {
      output.image(image, position.x, position.y);
    }
    else
    {
      //TODO add animation for disappearing platform
    }
  }
  
  
  public void setBroken()
  {
    if(++breakCount > 10)
    {
      size.x = size.y = 0;
      box.updateDimensions(position, size);
    }
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

