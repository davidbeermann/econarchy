import ddf.minim.*;

public class SoundEvent
{
	boolean enabled = true;
	Minim minim;
	AudioPlayer theme;	
	HashMap<String, AudioSample> fxSounds;	
	

	public  SoundEvent(PApplet applet)
    {
		minim = new Minim(applet);
		
		fxSounds = new HashMap<String, AudioSample>();	
		
		// Put some fancy theme music here
		theme = minim.loadFile("resources/sounds/theme.wav");	
		if(enabled)
		{
			theme.play();
			theme.loop();
		}
	}


	public void sound(String event)
	{	
		AudioSample effect = null;
		String filename = "resources/sounds/" + event + ".wav";
		File f = new File(dataPath(filename));

		if (fxSounds.containsKey(event))
		{
			effect = fxSounds.get(event);
		}
		else if (f.exists())
		{
			effect= minim.loadSample(filename,512);
			fxSounds.put(event, effect);
		}

		if (enabled && effect != null)
		{
			effect.trigger();
		}
	}
}
