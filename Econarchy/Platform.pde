public class Platform
{
  private Type.Platform type;
  private int x;
  private int y;
  private int width;
  private int height;


  public Platform(Type.Platform type, int x, int y, int width, int height)
  {
    this.type = type;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }


  public void draw(int startY)
  {
    colorMode(HSB, 360, 1.0, 1.0, 1.0);
    noStroke();
    
    if (type == Type.Platform.REGULAR)
    {
      fill(color(0, 1.0, 0.0, 1.0));
      rect(x, y + startY, width, height);
    }
    else if (type == Type.Platform.DISSOLVABLE)
    {
      fill(color(0, 1.0, 1.0, 1.0));
      rect(x, y + startY, width, height);
    }
    else if (type == Type.Platform.SLIPPERY)
    {
      fill(color(180, 1.0, 1.0, 1.0));
      rect(x, y + startY, width, height);
    }
    else
    {
      println("Unknown platform type: " + type);
    }
  }
}
