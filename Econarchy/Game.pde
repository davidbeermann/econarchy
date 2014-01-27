public class Game
{
  private PGraphics viewport;
  private PVector viewportPosition;
  ParallaxBackground background;
  private Level level;
  
  
  
  public Game(int viewportWidth, int viewportHeight)
  {
    viewport = createGraphics(viewportWidth, viewportHeight);
    viewport.beginDraw();
    viewport.noStroke();
    viewport.fill(255);
    viewport.rect(0, 0, viewportWidth, viewportHeight);
    viewport.endDraw();
    
    viewportPosition = new PVector((width - viewport.width) / 2, (height - viewport.height) / 2);
   
  }
  
  
  public void setupLevel(String xmlPath)
  {
    XML levelXML = loadXML(xmlPath);
    LevelData levelData = new LevelData(levelXML);
    
    background = new ParallaxBackground(levelData);
    
    level = new Level(levelData);
  }
  
  
  public void render()
  {
    // render all level updates
    level.render();
    
    // draw rendered level onto viewport
    float posX = (viewport.width - level.renderedImage.width) / 2;
    float posY = (viewport.height - level.hans.position.y);
    // println("percent: " + percent + " / posY: " + posY);
    
    viewport.beginDraw();
    viewport.clear();
    
    // draw background onto viewport
    background.render(viewport, level);
    
    // draw level at correct position onto viewport
    if (posY < (viewport.height - level.renderedImage.height) + viewport.height / 2 - level.hans.avatar.height)
    {
      viewport.image(level.renderedImage, posX, viewport.height - level.renderedImage.height);  
    }
    else if (posY > viewport.height / 2 - level.hans.avatar.height)
    {
      viewport.image(level.renderedImage, posX, 0);  
    }
    else
    {
      viewport.image(level.renderedImage, posX, posY-viewport.height/2+level.hans.avatar.height);   
    }
  
    viewport.endDraw();
    
    // draw viewport to frame - actually display rendered result to player
    image(viewport, viewportPosition.x, viewportPosition.y);
  }
}


private class ParallaxBackground
{
  LevelData data;


  public ParallaxBackground(LevelData data)
  {
    this.data = data;
  }


  public void render(PGraphics viewport, Level level)
  {
    PImage bgImage;
    float percent;
    PVector diff = new PVector();
    for (String id : data.getBackgroundIds())
    {
      bgImage = data.getImageResource(id);
      percent = 1 - (level.hans.position.y + level.hans.avatar.height / 2) / level.renderedImage.height;
      diff.x = viewport.width - bgImage.width;
      diff.y = viewport.height - bgImage.height;
      // println("percent: " + percent + " - diff: " + diff);
      
      viewport.image(bgImage, diff.x / 2, diff.y - percent * diff.y);
    }
  }
}
