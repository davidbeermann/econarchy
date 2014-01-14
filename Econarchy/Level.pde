public class Level
{
  int levelWidth;
  int levelHeight;
  Platform[] platforms;
  // gradient variables - TO BE DELETED
  int Y_AXIS = 1;
  int X_AXIS = 2;
  

  public Level()
  {
    this.levelWidth = width;
    this.levelHeight = 2000;
    
    platforms = new Platform[3];
    platforms[0] = new Platform(Type.Platform.REGULAR, 20, 1900, 120, 20);
    platforms[1] = new Platform(Type.Platform.DISSOLVABLE, 140, 1800, 120, 20);
    platforms[2] = new Platform(Type.Platform.SLIPPERY, 260, 1700, 120, 20);
  }


  public void update()
  {
    float startY = ((float) mouseY / height) * (height - levelHeight);
    setGradient(0, (int) startY, levelWidth, levelHeight, color(30), color(220), Y_AXIS);
    
    for(Platform platform : platforms)
    {
      platform.draw((int) startY);
    }
  }

  
  // gradient helper method - TO BE DELETED
  private void setGradient(int x, int y, float w, float h, color c1, color c2, int axis )
  {
    noFill();

    if (axis == Y_AXIS)  // Top to bottom gradient
    {
      for (int i = y; i <= y+h; i++)
      {
        float inter = map(i, y, y+h, 0, 1);
        color c = lerpColor(c1, c2, inter);
        stroke(c);
        line(x, i, x+w, i);
      }
    }  
    else if (axis == X_AXIS)  // Left to right gradient
    {
      for (int i = x; i <= x+w; i++)
      {
        float inter = map(i, x, x+w, 0, 1);
        color c = lerpColor(c1, c2, inter);
        stroke(c);
        line(i, y, i, y+h);
      }
    }
  }
}

