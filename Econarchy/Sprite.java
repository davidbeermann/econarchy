import processing.core.PGraphics;
import processing.core.PImage;
import processing.core.PVector;

class Sprite
{
  public static String STATE_JUMP_LEFT = "jump_left";
  public static String STATE_JUMP_RIGHT = "jump_right";
  public static String STATE_WALK_LEFT = "walk_left";
  public static String STATE_WALK_RIGHT = "walk_right";
  public static String STATE_DEAD = "dead";
  
  private int defaultUpdateSpeed = 5;
  
  private PGraphics graphic;
  private PImage[] images;
  private int frame, updateSpeed, updateIndex;
  private String state;
  
  
  public Sprite(PGraphics graphic)
  {
    this.graphic = graphic;
    this.updateSpeed = defaultUpdateSpeed;
  }
  
  
  public Sprite(PGraphics graphic, int updateSpeed)
  {
    this.graphic = graphic;
    this.updateSpeed = updateSpeed;
  }
  
  
  public void setImages(String state, PImage[] images)
  {
    if(this.state != state)
    {
      this.state = state;
      this.images = images;
      
      frame = 0;
      updateIndex = 0; 
    }
  }
  
  
  public void render()
  {
    render(false);
  }
  
  
  public void render(boolean reset)
  {
    if(reset)
    {
      frame = 0;
      updateIndex = 0; 
    }
    else
    {
      if(images.length != 1)
      {
        if(++updateIndex >= updateSpeed)
        {
          updateIndex = 0;
          frame = (frame + 1) % images.length;
        }
      }
    }
    
    graphic.beginDraw();
    graphic.clear();
    graphic.image(images[frame], 0, 0);
    graphic.endDraw();
  }
}
