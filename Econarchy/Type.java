public class Type
{
  public enum Platform
  {
    REGULAR("regular"),
    DISSOLVABLE("dissolvable"),
    SLIPPERY("slippery");
    
    private final String name;
    
    private Platform(String name)
    {
      this.name = name;
    }
    
    @Override
    public String toString()
    {
      return name;
    }
  }
}
