public class Level
{
  PGraphics renderedImage;
//  int levelWidth;
//  int levelHeight;
  Platform[] platforms;
  // gradient variables - TO BE DELETED
  int Y_AXIS = 1;
  int X_AXIS = 2;
  
  // define global level settings in xml driven data class
  public Level()//LevelData data)
  {
    renderedImage = createGraphics(width, 2000);
    
    platforms = new Platform[3];
    platforms[0] = new Platform(Type.Platform.REGULAR, 20, 1900, 120, 20);
    platforms[1] = new Platform(Type.Platform.DISSOLVABLE, 140, 1800, 120, 20);
    platforms[2] = new Platform(Type.Platform.SLIPPERY, 260, 1700, 120, 20);
  }


  public void render()
  {
    renderedImage.beginDraw();
    renderedImage.clear();
    
    setGradient(0, 0, renderedImage.width, renderedImage.height, color(30), color(220), Y_AXIS);
    
    for(Platform platform : platforms)
    {
      platform.render(renderedImage);//(int) startY);
    }
    
    renderedImage.colorMode(RGB);
    renderedImage.fill(255, 0, 0);
    renderedImage.rect(360, 1960, 40, 40);
    
    renderedImage.endDraw();
  }

  
  // gradient helper method - TO BE DELETED
  private void setGradient(int x, int y, float w, float h, color c1, color c2, int axis )
  {
    renderedImage.noFill();

    if (axis == Y_AXIS)  // Top to bottom gradient
    {
      for (int i = y; i <= y+h; i++)
      {
        float inter = map(i, y, y+h, 0, 1);
        color c = lerpColor(c1, c2, inter);
        renderedImage.stroke(c);
        renderedImage.line(x, i, x+w, i);
      }
    }  
    else if (axis == X_AXIS)  // Left to right gradient
    {
      for (int i = x; i <= x+w; i++)
      {
        float inter = map(i, x, x+w, 0, 1);
        color c = lerpColor(c1, c2, inter);
        renderedImage.stroke(c);
        renderedImage.line(i, y, i, y+h);
      }
    }
  }
}

