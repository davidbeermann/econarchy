public class Level
{
  LevelData data;
  PGraphics renderedImage;
  Platform[] platforms;
  // gradient variables - TO BE DELETED
  int Y_AXIS = 1;
  int X_AXIS = 2;
  
  // define global level settings in xml driven data class
  public Level(LevelData data)
  {
    this.data = data;
    
    // setup main level graphic
    renderedImage = createGraphics((int) data.size.x, (int) data.size.y);
    
    // setup platforms
    platforms = new Platform[data.getPlatformSpecs().length];
    PlatformSpec platformSpec;
    for(int i = 0; i < data.getPlatformSpecs().length; i++)
    {
      platformSpec = data.getPlatformSpecs()[i];
      if(platformSpec != null)
      {
        platforms[i] = new Platform(platformSpec.getType(), platformSpec.getPosition(), data.getImageResource(platformSpec.getType().toString()));
      }
    }
  }


  public void render()
  {
    renderedImage.beginDraw();
    renderedImage.clear();
    
    setGradient(0, 0, renderedImage.width, renderedImage.height, color(30), color(220), Y_AXIS);
    
    for(Platform platform : platforms)
    {
      platform.render(renderedImage);
    }
    
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

