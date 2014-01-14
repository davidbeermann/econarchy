Level level;

public void setup()
{
  size(400, 640);
  
  level = new Level();
}

public void draw()
{
  level.update();
}
