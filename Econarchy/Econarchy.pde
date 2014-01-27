boolean gamepadEnabled = false;
Game game;
FancyInput gamepad;
SoundEvent music;


public void setup()
{
  size(400, 640);
  
  game = new Game(400, 600);
  game.setupLevel("level1.xml");
  music = new SoundEvent(this);
  
  //setup gamepad if needed
  if (gamepadEnabled) {
    gamepad = new FancyInput("controls.xml", this);
  }

}

public void keyPressed(KeyEvent e) {
  if (!gamepadEnabled)
  game.level.hans.keyPressed(e); //forward keypress events to player object
}

public void keyReleased(KeyEvent e) {
  if (!gamepadEnabled)
  game.level.hans.keyReleased(e); //forward keyrelease events to player object
}

public void draw()
{ 
  background(0);
 if (gamepadEnabled) gamepad.update();
 game.render();
 
}

public void stop() {
  music.minim.stop();
}

