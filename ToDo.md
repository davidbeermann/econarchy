## Game Logic

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

### class LevelGoals
+ raise a flag etc. approach a position on top trigger something
+  (timer?)

---
### class Soundmanager
+  play backgroundmusic
+  effectsounds on certain events
---
## Graphics

### Player
+ sprites of the staates (walking jumping etc.)

### Obstacles / Plattforms
+ pattern that works for different sizes / length
+ visual difference between the different types of plattforms

### Levelenvironment / -background
+ a large background for the whole level fitting the level topic

### Enemies
+ sprites of the staates (walking jumping etc.)
+ visual difference between the different types of enemies

### Pickups / goals etc
+ Raising the flag
+ a parachute to pick up

---
## Sound

+ Backgroundtheme
+ player actions like jumping
+ Events effects like breaking plattforms or picking up a parachute 