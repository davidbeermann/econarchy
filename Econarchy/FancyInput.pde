import procontroll.*;
import net.java.games.input.*; //enable these imports for gamepad support

public class FancyInput {
//AWESOME FEATURE (needs procontroll library)
ControllIO controll;
ControllDevice pad;
String controller_id;

public FancyInput(XML mappings) {
    //setup joystick/gamepad
    controll = ControllIO.getInstance(this);
    controller_id = mappings.getString("id");
    
    pad = controll.getDevice(controller_id);
    
    
    pad.plug(game.level.hans, "jump", ControllIO.ON_PRESS, 0);
    pad.plug(game.level.hans, "move", ControllIO.WHILE_PRESS, 10);
    pad.getSlider(1).setTolerance(0.2);
  }
  
  
  // public void update() {
  //   for x in y do stuff;
  }
