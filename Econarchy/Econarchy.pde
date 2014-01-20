boolean gamepadEnabled = false;
Game game;
FancyInput gamepad;
  
public void setup()
{
  size(400, 640);
  
  game = new Game(400, 600);
  game.setupLevel("level1.xml");
  //setup gamepad if needed
  if (gamepadEnabled) {
    gamepad = new FancyInput("controls.xml", this);
  }
}

public void keyPressed(KeyEvent e) {
  game.level.hans.keyPressed(e);
}

public void keyReleased(KeyEvent e) {
  game.level.hans.keyReleased(e);
}

public void draw()
{	
	background(0);
 if (gamepadEnabled) gamepad.update();
 game.render();
}

