
Player hans;
Enemy[] enemies;
Game game;

public void setup()
{
  size(400, 640);
  
  game = new Game(400, 600);
  game.setupLevel("level1.xml");
  
//  hans = new Player();
//  enemies = new Enemy[3];
//  for (int i=0; i < 3; i++)
//  {
//    enemies[i] = new Enemy(new PVector(random(width),random(height),0));
//  }
}

public void draw()
{
  game.render();
  
//  hans.drawPlayer();
//  hans.controlPlayer();
// for (int i=0; i < enemies.length; i++)
//  {
//    enemies[i].drawEnemy();
//    enemies[i].patroling();
//  }
}
