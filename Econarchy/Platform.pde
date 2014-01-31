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

  public boolean isFlag() {
    return false;
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


public class Flag extends Collidable
{
  PVector position;
  PImage[] inactive, active;
  PGraphics graphic;
  BoundingBox bounds;
  Sprite sprite;


  public Flag(PVector position)
  {
    this.position = position;

    inactive = new PImage[1];
    inactive[0] = LevelData.getInstance().getImageResource("flag_inactive");

    active = new PImage[4];
    active[0] = LevelData.getInstance().getImageResource("flag_active1");
    active[1] = LevelData.getInstance().getImageResource("flag_active2");
    active[2] = LevelData.getInstance().getImageResource("flag_active3");
    active[3] = LevelData.getInstance().getImageResource("flag_active4");

    graphic = createGraphics(inactive[0].width, inactive[0].height);
    sprite = new Sprite(graphic);

    bounds = new BoundingBox(new PVector(position.x, position.y + graphic.height - 30), new PVector(position.x + 3, 30));

    reset();
  }

  public void render(PGraphics output)
  {
    sprite.render();
    output.image(graphic, position.x, position.y);
  }

  public void reset()
  {
    sprite.setImages("inactive", inactive);
  }

  public void setActive()
  {
    bounds.width = bounds.height = 0;
    sprite.setImages("active", active);
  }
  
  @Override  
  public boolean isFlag()
  {
    return true;
  }

  @Override
  public BoundingBox getBounds()
  {
    return bounds;
  }
}
