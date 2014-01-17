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
    float percent = max(0.0, min(1.0, (float) (mouseY - viewportPosition.y) / viewport.height));
    float posX = (viewport.width - level.renderedImage.width) / 2;
    float posY = (viewport.height - level.renderedImage.height) * percent;
    println("percent: " + percent + " / posY: " + posY);
    
    viewport.beginDraw();
    viewport.clear();
    viewport.image(level.renderedImage, posX, posY);
    viewport.endDraw();
    
    // draw viewport to frame - actually display rendered result to player
    image(viewport, viewportPosition.x, viewportPosition.y);
  }
}
