import ddf.minim.*;

public class SoundEvent {
	Minim minim;
	AudioPlayer theme;
	
	HashMap<String, AudioSample> fxSounds;
	
	

	public  SoundEvent(PApplet applet) {
		
		minim = new Minim(applet);
		
		
		theme = minim.loadFile("badTetrisRemix.mp3");
		fxSounds = new HashMap<String, AudioSample>();	
		theme.loop();
		theme.play();
		
	}
	public void sound(String event)
	{	
		AudioSample efect = null;
		String filename = event+".wav";
		File f = new File(dataPath(filename));
		if (fxSounds.containsKey(event)) {
			efect = fxSounds.get(event);
		} else if (f.exists()){
			efect= minim.loadSample(filename,512);
			fxSounds.put(event, efect);

		}

		if (efect != null) {
			efect.trigger();
		}


	}
	public void backagroundTheme() {

		
	}

}