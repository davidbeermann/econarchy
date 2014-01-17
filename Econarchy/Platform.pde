public class Platform
{
  private Type.Platform type;
  private PVector position;
  private PImage image;


  public Platform(Type.Platform type, PVector position, PImage image)
  {
    this.type = type;
    this.position = position;
    this.image = image;
  }


  public void render(PGraphics output)
  {
    output.image(image, position.x, position.y);
  }
}

