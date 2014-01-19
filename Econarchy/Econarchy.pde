//import procontroll.*;
//import net.java.games.input.*;

Game game;
  //AWESOME FEATURE (needs procontroll library)
  //ControllIO controll;
  //ControllDevice pad;

public void setup()
{
  size(400, 640);
  
  game = new Game(400, 600);
  game.setupLevel("level1.xml");
  
  //setup awesome feature
  //  controll = ControllIO.getInstance(this);
  //  pad = controll.getDevice(7);
  // pad.plug(game.level.hans, "jump", ControllIO.ON_PRESS, 0);
}


public void draw()
{	
	background(0);
  game.render();
}
