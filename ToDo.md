### class Environment
+ handle forces etc.
+ modifiers (parachute etc.)

### class Player
+ handle controls 
+ moving position
+ states : moving, jumping, alive dead etc.
+ collision detection: walls obstacles

### class BasePlattform
+ size
+ position
+  extends to 3(?) kinds: solid, breakable, sticky

### class BaseEnemy
+ position
+ states: walking, attacking...
+  "AI"
+  maybe extends to different kinds of enemies (different speeds)
+  you have to escape them or go around them. you can't kill them

### class Screen
+ change the viewport

### class Soundmanager
+  play backgroundmusic
+  effectsounds on certain events

### class LevelGoals
+ raise a flag etc. approach a position on top trigger something
+  (timer?)
