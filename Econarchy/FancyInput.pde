import procontroll.*;
import net.java.games.input.*; //enable these imports for gamepad support

public class FancyInput {
//AWESOME FEATURE (needs procontroll library)
ControllIO controll;
ControllDevice pad;
ControllSlider horizontalSlider;
String controller_id;
boolean rumbleEnabled = false;

// Setup inputs 
public FancyInput(String path, Econarchy that) {
    XML controller_xml = loadXML(path);
    
    //setup joystick/gamepad
    controll = ControllIO.getInstance(that);
    controller_id = controller_xml.getString("id");
    println("Using the following controller: " + controller_id);
    
    pad = controll.getDevice(controller_id);
    
    XML[] buttons = controller_xml.getChild("inputs").getChild("buttons").getChildren("button");
    
    // iterate through button definitions from config
    for(int i=0; i<buttons.length;i++) 
      pad.plug(game.level.hans, buttons[i].getString("map_to"), ControllIO.ON_PRESS, buttons[i].getInt("id"));
      
    // setup slider for left/right movement
    XML[] sliderXML = controller_xml.getChild("inputs").getChild("sliders").getChildren("slider");
    
    // iterates over sliders if multiples are defined, currently useless
    for (int i=0; i<sliderXML.length; i++) {
      horizontalSlider = pad.getSlider(sliderXML[i].getInt("id"));
      horizontalSlider.setTolerance(sliderXML[i].getChild("tolerance").getFloat("value"));
  }
  
  // setup controller special properties
  XML[] metaXML = controller_xml.getChild("meta-data").getChildren("meta-entry");
  
  for (int i=0; i<metaXML.length; i++) {
    String metaEntry = metaXML[i].getString("type");
   if (metaEntry == "rumble_enabled") 
    rumbleEnabled = new Boolean(metaXML[i].getString("value"));
   else
    println("INVALID CONTROLLER XML OR FEATURE NOT YET IMPLEMENTED");
  }
}
  
  //update everything not caught with button presses here(analoq sticks etc)
  public void update() {
  //   for x in y do stuff;
    game.level.hans.move(horizontalSlider.getValue(),0);
  }
}
