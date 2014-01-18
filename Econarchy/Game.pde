public class Game
{
  private PGraphics viewport;
  private PVector viewportPosition;
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
    if (posY < (viewport.height - level.renderedImage.height)+viewport.height/2)
    {
      viewport.image(level.renderedImage, posX, viewport.height-level.renderedImage.height);  
    }
    else if (posY > viewport.height/2)
    {
      viewport.image(level.renderedImage, posX, 0);  
    }
    else
    {
      viewport.image(level.renderedImage, posX, posY-viewport.height/2+30);   
    }
  
    viewport.endDraw();
    
    // draw viewport to frame - actually display rendered result to player
    image(viewport, viewportPosition.x, viewportPosition.y);
  }
}
