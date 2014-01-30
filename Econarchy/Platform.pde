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
    if(broken && alphaValue < 0.5)
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
    else if(alphaValue > 0.5)
    {
      alphaValue -= alphaValue * 0.1;
      
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

