boolean gamepadEnabled = false;
Game game;
KeyTracker keyTracker;
FancyInput gamepad;
SoundEvent music;

public void setup()
{
  size(400, 640);
  
  game = new Game(400, 600);
  game.setupLevel("level1.xml");
  music = new SoundEvent(this);
  //setup gamepad if needed
  if (gamepadEnabled)
  {
    gamepad = new FancyInput("controls.xml", this);
  }
  else
  {
    keyTracker = KeyTracker.getInstance();
  }
}


public void draw()
{ 
  background(0);
  
  if (gamepadEnabled)
  {
    gamepad.update();
  }
   
  game.render();
}


public void keyPressed(KeyEvent e)
{
  if (!gamepadEnabled)
  {
    keyTracker.addKey(keyCode);
  }
}


public void keyReleased(KeyEvent e)
{
  if (!gamepadEnabled)
  {
    keyTracker.removeKey(keyCode); 
  }  
}

public void stop() {
  music.minim.stop();
}

