import processing.core.PGraphics;
import processing.core.PImage;
import processing.core.PVector;

class Sprite
{ 
  private int defaultUpdateSpeed = 5;
  
  private PGraphics graphic;
  private PImage[] images = null;
  private int frame, updateSpeed, updateIndex;
  private String state;
  private boolean flipH;
  
  
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


  public void setFlipH(boolean value)
  {
    flipH = value;
  }
  
  
  public void render()
  {
    render(false);
  }
  
  
  public void render(boolean reset)
  {
    if(images == null)
    {
      System.out.println(this + " ERROR : execute setImages() method at least once before calling render() method!");
      return;
    }

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

    if(flipH)
    {
      graphic.pushMatrix();
      graphic.scale(-1, 1);
      graphic.image(images[frame], -images[frame].width, 0);
      graphic.popMatrix();
    }
    else
    {
      graphic.image(images[frame], 0, 0);  
    }

    graphic.endDraw();
  }
}
