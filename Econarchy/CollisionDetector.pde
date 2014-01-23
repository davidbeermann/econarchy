public class CollisionDetector{
  BoundingBox[] static_colliders;
  
  public CollisionDetector(Platform[] platforms) {
    static_colliders = new BoundingBox[platforms.length];
    
    //fill checklist with bounding boxes of platforms
    for (int i = 0; i < platforms.length; i++) {
      static_colliders[i] = new BoundingBox(platforms[i].getPosition(), platforms[i].getSize());
      println(static_colliders[i].width);
    }
  }
  
  // inspired by http://stackoverflow.com/questions/4354591/intersection-algorithm
  private boolean intersects(BoundingBox a, BoundingBox b) {
    BoundingBox tempBox = BoundingBox.getBoundingBox(a,b);
    if ( (tempBox.width < a.width+b.width) && (tempBox.height < a.height+b.height))
      return true;
    else
      return false;
  }
  
  public void checkCollisions(Actor a) {
    println("COLLISION DETECTION IN PROGRESS");
    BoundingBox commonBound;
    BoundingBox tmpBounding = a.getBounds();
    for (int i=0; i<static_colliders.length; i++){
      if ( intersects(a.getBounds(), static_colliders[i])) { 
        println("COLLISION DETECTED");
       a.handleCollision(new Collision(static_colliders[i]));}
    }
  }
}


//preliminary Collision class, needs to be enhanced and extended
public class Collision {
  BoundingBox collidedWith;
  
  public Collision(BoundingBox b) {
      collidedWith = b;
  }

  public BoundingBox getCollider() {
    return collidedWith;
  }
}
  
  
// boundingbox of object 
public static class BoundingBox {
  float x, y;
  float width;
  float height;
  
  public BoundingBox(float x, float y, float w, float h) {
    x = x;
    y = y;
    width = w;
    height = h;
  }
  
 
  // wrapper constructor for direct support of sizes supplied as vectors
  public BoundingBox(PVector xy, PVector wh) {
    x = xy.x;
    y = xy.y;
    width = wh.x;
    height = wh.y;
  }
  
  // get the resulting bounding box of the supplied boxes
  public static BoundingBox getBoundingBox(BoundingBox box1, BoundingBox box2) {
    return new BoundingBox(min(box1.x, box2.x), min(box1.y, box2.y), max(box1.x+box1.width, box2.x+box2.width), max(box1.y+box1.height, box2.y+box2.height));
  }
}
