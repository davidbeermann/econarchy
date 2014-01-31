import java.util.ArrayList;
import java.util.HashMap;


class KeyTracker
{
  public static String LEFT_ID = "left";
  public static String RIGHT_ID = "right";
  public static String UP_ID = "up";
  public static String DOWN_ID = "down";

  private static int[] LEFT_KEYS = new int[] {37, 65}; // 'left' and 'a' key
  private static int[] RIGHT_KEYS = new int[] {39, 68}; // 'right' and 'd' key
  private static int[] UP_KEYS = new int[] {38, 87}; // 'up' and 'w' key
  private static int[] DOWN_KEYS = new int[] {40, 83}; // 'down' and 's' key

  private static KeyTracker instance;

  private HashMap<String, int[]> mapping;
  private ArrayList keys;
  private String recentHorizontalKeyId = null;


  public static KeyTracker getInstance()
  {
    if (instance == null)
    {
      instance = new KeyTracker();
    }
    return instance;
  } 


  private KeyTracker()
  {
    keys = new ArrayList();

    mapping = new HashMap<String, int[]>();
    mapping.put(LEFT_ID, LEFT_KEYS);
    mapping.put(RIGHT_ID, RIGHT_KEYS);
    mapping.put(UP_ID, UP_KEYS);
    mapping.put(DOWN_ID, DOWN_KEYS);
  }


  public void addKey(int code)
  {
    if (keys.indexOf(code) == -1)
    {
      keys.add(code);
      //System.out.println(code);

      evalRecentHorizontalKeyId();
    }
  }


  public void removeKey(int code)
  {
    if (keys.indexOf(code) != -1)
    {
      keys.remove(keys.indexOf(code));
      //System.out.println(code);
      
      evalRecentHorizontalKeyId();
    }
  }


  public String recentHorizontalKeyId()
  {
    return recentHorizontalKeyId;
  }


  public boolean noKeyPressed()
  {
    return keys.size() == 0;
  }


  public boolean anyKeyPressed()
  {
    return keys.size() > 0;
  }


  public boolean leftPressed()
  {
    return checkPressed(LEFT_KEYS);
  }


  public boolean rightPressed()
  {
    return checkPressed(RIGHT_KEYS);
  }


  public boolean upPressed()
  {
    return checkPressed(UP_KEYS);
  }


  public boolean downPressed()
  {
    return checkPressed(DOWN_KEYS);
  }


  private void evalRecentHorizontalKeyId()
  {
    for (int i = 0; i < keys.size(); i++)
    {
      Object k = keys.get(i);
      for (int l : LEFT_KEYS)
      {
        if (k.equals(l))
        {
          recentHorizontalKeyId = LEFT_ID;
          return;
        }
      }
      for (int r : RIGHT_KEYS)
      {
        if (k.equals(r))
        {
          recentHorizontalKeyId =  RIGHT_ID;
          return;
        }
      }
    }
  }


  private boolean checkPressed(int[] toCheck)
  {
    for (int val : toCheck)
    {
      if (keys.indexOf(val) != -1)
      {
        return true;
      }
    }
    return false;
  }
}

