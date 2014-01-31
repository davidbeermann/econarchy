public class CollisionDetector
{
 ArrayList<Collidable> static_colliders;
  

  public CollisionDetector()
  {
    static_colliders = new ArrayList<Collidable>();
  }
  

  public void addCollidables(Collidable[] collidables)
  {
    for (int i = 0; i < collidables.length; i++)
    {
      if(static_colliders.contains(collidables[i]))
      {
        println(this + " WARNING: tried to add instance " + collidables[i] + " twice");
      }
      else
      {
       //println( "ADDING COLLIDER: " + collidables[i].getBounds().x);
        static_colliders.add(collidables[i]);
      }
    }
  }
    
  
  // inspired by http://stackoverflow.com/questions/4354591/intersection-algorithm
  private boolean intersects(BoundingBox a, BoundingBox b) {
    BoundingBox tempBox = BoundingBox.getBoundingBox(a,b);
    //println("BOX B:" + a);
    if ( (tempBox.width < a.width+b.width) && (tempBox.height < a.height+b.height)) {
      //println("TEST");
      return true;}
    else
      return false;
  }
  
  // inspired by http://stackoverflow.com/questions/4354591/intersection-algorithm
  /* Returns directions as follows:
     coll from left - 1;
     coll from top  - 2;
     coll from bottom - 4;
     coll from right - 8; bottom right: 12, bottom left:5, bottom 4
     other directions sum of directions */
  private int intersectsDirectional(BoundingBox source, BoundingBox target) {
    int direction = 0;
    BoundingBox tempBox = BoundingBox.getBoundingBox(source,target);
    //println("BOX B:" + a);
    if ( (tempBox.width < source.width+target.width) && (tempBox.height < source.height+target.height)) {
      //determine direction
      if ( source.left < target.right && source.right > target.right ) //right
        direction += 8;
      if ( source.top < target.top && source.bottom > target.top ) //top
        direction += 2;
      if ( source.top < target.bottom && source.bottom > target.bottom ) // bottom
        direction += 4;
      if ( source.left < target.left && source.right > target.left ) //left
        direction += 1;
      }
      return direction;
  }
  
  public void checkCollisions(Collidable a) {
    BoundingBox commonBound;
    BoundingBox tmpBounding = a.getBounds();
    for (int i=0; i<static_colliders.size(); i++){
      //println("ITERATING");
      //if ( intersects(tmpBounding, static_colliders.get(i).getBounds())) {
      int dir = intersectsDirectional(tmpBounding, static_colliders.get(i).getBounds());
      if ( dir != 0 ) 
         a.handleCollision(new Collision(static_colliders.get(i), dir));
     //}
    }
  }
}


//preliminary Collision class, needs to be enhanced and extended
public class Collision {
  Collidable collidedWith;
  int direction;
  
  public Collision(Collidable b) {
      collidedWith = b;
  }
  
  public Collision(Collidable b, int dir) {
     collidedWith = b;
     direction = dir;
  } 

  public Collidable getCollider() {
    return collidedWith;
  }
}


//super uber class to enable collision detection
public class Collidable
{  
  public Collidable()
  {}
  
  public boolean isEnemy()
  {
    return false;
  }
  
  public boolean isPlatform()
  {
    return false;
  }
  
  public boolean isFlag() 
  {
    return false;
  }
  
  public boolean isGoal() 
  {
    return false;
  }
  
  public boolean isParachute() 
  {
    return false;
  }
  
  //return empty bounding box
  public BoundingBox getBounds()
  {
    return new BoundingBox(0,0,0,0);
  }
  
  public void handleCollision(Collision c)
  {}
}
  
  
// boundingbox of object 
public static class BoundingBox
{
  float left=0, top=0, bottom=0, right=0,x,y;
  float width=0;
  float height=0;

  
  public BoundingBox(float lcor, float tcor, float rcor, float bcor) {
    x = left = lcor;
    right = rcor;
    y = top = tcor;
    bottom = bcor;
    width = right-left;
    height = bottom-top;
  }

  // wrapper constructor for direct support of sizes supplied as vectors
  public BoundingBox(PVector xy, PVector wh)
  {
    updateDimensions(xy, wh);
  }
  
  public void updateDimensions(PVector xy, PVector wh)
  {
    x = left = xy.x;
    y = top = xy.y;
    width = wh.x;
    height = wh.y;
    right = left+width;
    bottom = top+height;
  }
  
  // get the resulting bounding box of the supplied boxes
  public static BoundingBox getBoundingBox(BoundingBox box1, BoundingBox box2) {
//    println("Box1.x: " + box1.x + " Box1.y: " + box1.y + " box1.width: " + box1.width + " box1.height: " + box1.height); 
//    println("Box2.x: " + box2.x + " Box2.y: " + box2.y + " box2.width: " + box2.width + " box2.height: " + box2.height); 
//    println("MIN.x: " + min(box1.x, box2.x) + " MIN.y: " + min(box1.y, box2.y));
    return new BoundingBox(min(box1.left, box2.left), min(box1.top, box2.top), max(box1.width+box1.left, box2.left+box2.width), max(box1.height+box1.top, box2.height+box2.top));
  }
  
}

