public class Actor
{
  PVector position;
  float walkingSpeed;
  float runningSpeed;

  public Actor()
  {
    walkingSpeed=2;
    runningSpeed=5;
  }

  public void walk()
  {
    position.add(walkingSpeed, 0, 0);
  }

  public void run()
  {
    position.add(runningSpeed, 0, 0);
  }
}


public class Player extends Actor
{
  float jumpHeight;
  public Player()
  {
    walkingSpeed = 10;
    jumpHeight = 2;
    position = new PVector(width/2, height-20, 0);
  }

  public void drawPlayer()
  {
    fill(255);
    ellipse(position.x, position.y, 20, 20);
  }

  public void controlPlayer() {
    if (keyPressed && key == CODED) {
      switch(keyCode) {
      case LEFT: 
        position.sub(walkingSpeed, 0, 0);
        break;
      case RIGHT: 
        position.add(walkingSpeed, 0, 0);
        break;
      case UP: 
        position.sub(0, jumpHeight, 0);
        break;
      }
    }
  }
}


public class Enemy extends Actor
{
  public Enemy(PVector pos)
  {
    position = pos;
  }

  public void drawEnemy()
  {
    fill(255, 0, 0);
    stroke(255);
    //draw a direction indicator
    if (walkingSpeed>0) {
      line(position.x, position.y, position.x+20, position.y);
    } 
    else if (walkingSpeed<0) {
      line(position.x, position.y, position.x-20, position.y);
    }
    ellipse(position.x, position.y, 20, 20);
  }

  public void patroling()
  {
    if (spottedThePlayer(hans)) 
    {
      run();
    } 
    else
    {
      if (reachedEndOfPlattform()) {
        walkingSpeed = walkingSpeed*-1;
        runningSpeed = runningSpeed*-1;
        walk();
      }
      else {
        //extendable random behaviour
        int r = int(random(30));
        switch(r) {
        case 0:
          //with chance of 1/30 the enemy will turn around and walk in the other direction before reaching the end of the plattform
          walkingSpeed = walkingSpeed*-1;
          runningSpeed = runningSpeed*-1;
          walk();
          break;
        case 1: 
          //with chance of 1/30 the enemy will stand still
          break;
        default :
          //with chance of 28/10 the enemy will continue walking in the same direction he was walking before.
          walk();
          break;
        }
      }
    }
  }

  public boolean reachedEndOfPlattform()
  {
    //has to be changed to platform size instead of windowsize
    if (position.x<= 0 || position.x>= width) {
      return true;
    }
    return false;
  }

  public boolean isInViewport()
  {
    //has to be when the viewportparallax works
    return true;
  }

  public boolean spottedThePlayer(Player p)
  {
    if (walkingSpeed>0 && position.x< p.position.x && abs(p.position.y-position.y)<p.jumpHeight|| walkingSpeed<0 && position.x> p.position.x && abs(p.position.y-position.y)<p.jumpHeight) 
    {
      return true;
    }
    else {
      return false;
    }
  }
}

public boolean doEnemyAndPlayerColide()
{
  for (int i = 0; i < enemies.length; ++i)
  {
    if (enemies[i].isInViewport())
    {


      if (dist(enemies[i].position.x, enemies[i].position.y, hans.position.x, hans.position.y) <= enemies[i].runningSpeed)
      {
        //precise detection
        return true;
      }
    }
    else
    {
      return false;
    }
  }
  return false;
}

public boolean standOnPlattform()
{
//  for (int i = 0; i < level.platforms.length; ++i) {
//    //    if (platforms[i].isInViewport())
//    //    {
//    if (hans.position.x >= level.platforms[i].x && 
//      hans.position.x <= level.platforms[i].x + level.platforms[i].width &&
//      hans.position.y >= level.platforms[i].y &&
//      hans.position.y <= level.platforms[i].y + level.platforms[i].height)
//      //hier noch spielerhöhe mit einbeziehen
//    {
//      return true;
//    } 
//    else {
//      return false;
//    } 
//    //    } else {
//    //      return false;
//    //      
//    //    }
//  }
  return false;
}

