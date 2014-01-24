public class CollisionDetector{
  BoundingBox[] static_colliders;
  
  public CollisionDetector(Platform[] platforms) {
    static_colliders = new BoundingBox[platforms.length];
    
    //fill checklist with bounding boxes of platforms
    for (int i = 0; i < platforms.length; i++) {
      static_colliders[i] = new BoundingBox(platforms[i].getPosition(), platforms[i].getSize());
//      println("x:" + static_colliders[i].x + "    y:" + static_colliders[i].y + "      w:" + static_colliders[i].width + "     h:" + static_colliders[i].height);
    }
  }
  
  // inspired by http://stackoverflow.com/questions/4354591/intersection-algorithm
  private boolean intersects(BoundingBox a, BoundingBox b) {
    BoundingBox tempBox = BoundingBox.getBoundingBox(a,b);
//     println("tmpBox.x: " + tempBox.x + "a.x: " + a.x + "b.x: " + b.x);
//     println("tmpBox.y: " + tempBox.y + "a.y: " + a.y + "b.y: " + b.y);
//     println("tmpBox.w: " + tempBox.width + "a.w: " + a.width + "b.w: " + b.width);
    if ( (tempBox.width < a.width+b.width) && (tempBox.height < a.height+b.height)) {
      return true;}
    else
      return false;
  }
  
  public void checkCollisions(Actor a) {
//    println("COLLISION DETECTION IN PROGRESS");
    BoundingBox commonBound;
    BoundingBox tmpBounding = a.getBounds();
    //println("x:" + tmpBounding.x + "    y:" + tmpBounding.y + "      w:" + tmpBounding.width + "     h:" + tmpBounding.height);
    for (int i=0; i<static_colliders.length; i++){
      if ( intersects(tmpBounding, static_colliders[i])) { 
//        println("COLLISION DETECTED");
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
  public BoundingBox(PVector xy, PVector wh) {
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
