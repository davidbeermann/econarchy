## Game Logic

### class Environment
+ handle forces etc.
	+ falling down and maybe die
+ modifiers (parachute etc.)

### class Player
+ handle controls
	+ faster movement left right [DONE]
+ moving position
	+ falling down and maybe die [DONE]
+ ~~states : moving, jumping, alive dead etc.~~
+ collision detection: walls obstacles [DONE?]
	+ bounce from the bottom of the plattforms

### class BasePlattform
+ ~~size~~
+ ~~position~~
+  extends to 3(?) kinds: solid, breakable, sticky

### class BaseEnemy
+ ~~position~~
+ states: walking, attacking...
+  ~~"AI"~~
+  ~~maybe extends to different kinds of enemies (different speeds)~~
+  ~~you have to escape them or go around them. you can't kill them~~

### class Screen
+ ~~change the viewport~~

### class LevelGoals
+ raise a flag etc. approach a position on top trigger something
+  (timer?)

---
### class Soundmanager
+  ~~play backgroundmusic~~
+  ~~effectsounds on certain events~~

---
