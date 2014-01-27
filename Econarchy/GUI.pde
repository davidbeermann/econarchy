public class GUI
{
	PFont pixelFont;
	int frame;
	int size;
	int points;
	float playerpos;

	public GUI (Player p)
	{
		frame=0;
		size=0;
		points=0;
		playerpos = p.position.y;
		pixelFont = loadFont("LCDDot-48.vlw");
	}

	void update(Player p)
	{
		gameOver(p);
		storyCounter(p);
	}

	void storyCounter(Player p)
	{
		if ((playerpos - p.position.y)/p.jumpHeight>points) {
			points = int((playerpos - p.position.y)/p.jumpHeight);	
		}
		
		fill(0);
		textAlign(LEFT,BOTTOM);
		textFont(pixelFont, 20);
		text(points, 20, height-50);
	}

	void gameOver(Player p)
	{
		if (!p.alive) 
		{
			fill(0, 200);
			if (frame*20< height) 
			{
				rect(0, 0, width, size);
				if (frame%2==0) 
				{
					size+=20;	
				}
				frame++;
			}
			else 
			{
				rect(0, 0, width, height);
				textAlign(CENTER,CENTER);
				fill(255);
				textFont(pixelFont, 48);
				text("GAME\nOVER", width/2, height/2);	
			}
		}
	}
}
