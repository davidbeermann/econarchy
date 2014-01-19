

boolean gamePadEnabled = false;
Game game;
FancyInput gamepad;
  
public void setup()
{
  size(400, 640);
  
  game = new Game(400, 600);
  game.setupLevel("level1.xml");
  //setup gamepad if needed
  //if (gamepadEnabled) {
 //   gamepad = new FancyInput("controls.xml");
  //}

}


public void draw()
{	
	background(0);
 gamepad.update();
 // if (gamePadEnabled) game.level.hans.move(pad.getSlider(1).getValue(),0);
  game.render();
}
