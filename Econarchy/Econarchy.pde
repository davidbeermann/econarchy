
Player hans;
Enemy[] enemies;
Game game;

public void setup()
{
  size(400, 640);
  
  game = new Game(400, 600);
  game.setupLevel("level1.xml");
}

public void draw()
{
  game.render();
}
