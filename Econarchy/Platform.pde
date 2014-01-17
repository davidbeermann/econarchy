public class Platform
{
  private Type.Platform type;
  private PVector position;
  private PVector size;
//  private int x;
//  private int y;
//  private int width;
//  private int height;


  public Platform(Type.Platform type, int posX, int posY, int sizeW, int sizeH)
  {
    this.type = type;
    this.position = new PVector(posX, posY);
    this.size = new PVector(sizeW, sizeH);
//    this.x = x;
//    this.y = y;
//    this.width = width;
//    this.height = height;
  }


  public void render(PGraphics output)//int startY)
  {
    println("render! " + type + " " + position + " " + size);
    
    output.colorMode(RGB);
    output.noStroke();
    
    if (type == Type.Platform.REGULAR)
    {
      output.fill(30, 30, 30);
      output.rect(position.x, position.y, size.x, size.y);
    }
    else if (type == Type.Platform.DISSOLVABLE)
    {
      output.fill(255, 30, 30);
      output.rect(position.x, position.y, size.x, size.y);
    }
    else if (type == Type.Platform.SLIPPERY)
    {
      output.fill(30, 255, 30);
      output.rect(position.x, position.y, size.x, size.y);
    }
    else
    {
      println("Unknown platform type: " + type);
    }
  }
}
