//import procontroll.*;
//import net.java.games.input.*; //enable these imports for gamepad support

boolean gamePadEnabled = false;
Game game;
  
    //AWESOME FEATURE (needs procontroll library)
    //ControllIO controll;
    //ControllDevice pad;
 
  
public void setup()
{
  size(400, 640);
  
  game = new Game(400, 600);
  game.setupLevel("level1.xml"); 
 /*  if(gamePadEnabled) {
    //setup awesome feature - only xbox currently
    controll = ControllIO.getInstance(this);
    controll.printDevices(); 
    pad = controll.getDevice("Controller (Xbox 360 Wireless Receiver for Windows)");
    pad.plug(game.level.hans, "jump", ControllIO.ON_PRESS, 0);
    pad.plug(game.level.hans, "move", ControllIO.WHILE_PRESS, 10);
    pad.getSlider(1).setTolerance(0.2);
  }*/
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
 // if (gamePadEnabled) game.level.hans.move(pad.getSlider(1).getValue(),0);
  game.render();
}

