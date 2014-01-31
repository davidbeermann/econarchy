
                           .-" l                       
                          .'   /                        
           _.------------'    :                         
      .-"""                    "-.                      
    .'                            "-.                   
 _.-'    __                          "-.                
(---"""  "        _                     "-.             
 """"""""-----.-"" `.                      `.           
               \ `.__;________               `.         
                `.:           """"---...       `.       
                  `                     """--..  \--""-.
                                              :   `.   :
                                               \    .-" 
                                                "-._l   
                                    _           
                                    | |          
  ___  ___ ___  _ __   __ _ _ __ ___| |__  _   _ 
 / _ \/ __/ _ \| '_ \ / _` | '__/ __| '_ \| | | |
|  __/ (_| (_) | | | | (_| | | | (__| | | | |_| |
 \___|\___\___/|_| |_|\__,_|_|  \___|_| |_|\__, |
                                            __/ |
                                           |___/ 

version // 1.0  
released // 31/01/2010
platform // Windows, Mac OSX

---

CREDIT // Julian Hespenheide, Jonas Otto, David Beermann, Peter Buczkowski, Sammy Jobbins Wells, Florian Lütkebohmert

---

INSTRUCTIONS // 

Save the world + the whales once and for all from the megalomanic clutches of Consumegood Inc. ! 

Make your way to the top of the corporation's headquarters and secure the econarchy flag of righteousness.. You can scale the building by jumping onto the platforms but be wary to avoid rousing the attention of the Consumegood henchmen who will bring your covert operation to a pre-mature end. Once you have secured the econarchy flag, launch your parachute and float back to Mother Earth being careful to avoid the jutting platforms upon your descent.

CONTROLS:

a = move left
w = jump up
d = move right

OR

arrows

arrow keys up, down, right, left to jump up, right and left.
---

HOW TO RUN THE PROTOTYPE:
- Start the "econarchy" executable
- No further installations required

---

HOW TO COMPILE THE SOURCES:
- Download Processing (http://processing.org)
- Copy libraries from source folder into main Processing libraries folder
- Click Econarchy.pde in order to open project in Processing

---

STRUCTURE


---

INDIVIDUAL REPORTS //

Jonas Otto:
- basic wireframe for the classes
- player and enemy classes + enemy "ai" implementation
- level xml design
- gui class (startscreen + text, meters to go, game over screen and reset procedure)
- sound manager
- co-developing viewport shifting for the position of the player
- some render methods
- initial idea for eco-terrorism
- game name suggestion winner (in a democratic voting)

Julian Hespenheide:
- overall color scheme, look & feel
- foreground/background layers
- platforms
- player animations (states: idle, walking, jumping, dropping, cheering for the flag, death)
- startscreen design

David Beermann:
- xml data structure and parsing
- overall game viewport setup and rendering "pipeline"
- key tracking for player control
- level setup incl. platform and enemy positioning based on xml data
- background parallax effect
- player and enemy sprite behavior
- added collision logic for breakable platforms incl. animation
- optimization of enemy ai incl. graphical player spotted display
- game reset logic
- gui optimizations with new graphics, fonts and animations

Peter Buczkowski:
- sound design
- initial idea for gameplay / based on groupwork with Jonas
- optimizing level design (xml)
- additional graphics (e.g. parachute)

Sammy Jobbins Wells:
- enemy concept, design and animation
- flag design and animation
- general design support
- project management
- text (description, in-game, ...)

Florian Lütkebohmert:
- custom CollisionDetectionSystem(Collidable, CollisionDetector, etc.) (Pita)
- Physics
- Input-Support Gamepad (not enabled by default because of lovely little bugs)
 * uses and requires proControll library - http://creativecomputing.cc/p5libs/procontroll/
- Gamepad-Configuration parsing (XML)
- optimization of physics and collision detection (aka. bugfixing)
- initial idea for up/down mechanic