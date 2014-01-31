public class GUI
{
	PFont pixelFont;
	int frame;
	int size;
	int points, meterToGo, levelHeight;
	float playerpos;
	Player player;
	boolean sawInfoScreen;


	public GUI (Player p)
	{
		player = p;
		frame=0;
		size=0;
		points= 0;
		meterToGo = 0;
		levelHeight = int(player.position.y / player.jumpHeight); 
		playerpos = player.position.y;
		pixelFont = loadFont("resources/fonts/Unibody8Pro-RegularItalic-20.vlw");
		sawInfoScreen = false;
	}


	void update()
	{
		introScreen();
		gameOver();
		storyCounter();
	}


	void storyCounter()
	{
		if (!game.gameOver)
		{
			meterToGo = levelHeight - int((playerpos - player.position.y)/player.jumpHeight);
			
			noStroke();
			fill(216, 18, 63);
			rect(0, 0, width, 40);
			
			fill(255);
			textAlign(LEFT,TOP);
			textFont(pixelFont, 20);
			text(meterToGo+" m to go", 10, 10);
		}
	}


	void introScreen()
	{
		if (game.gameOver && !sawInfoScreen)
		{
			PImage startscreen = loadImage("resources/screens/startscreen.png");
			image(startscreen, 0, 0);

			if (keyPressed && key == ' ')
			{
				game.startGame();
				sawInfoScreen = true;
			}
		}
	}


	void gameOver()
	{
		if (!player.alive) 
		{
			game.gameOver=true;

			PImage startscreen = loadImage("resources/screens/gameover.png");
			image(startscreen, 0, 0);

			if (keyPressed)
			{
				if (key == 'y' || key == 'Y')
				{
					game.startGame();
				}
				else if (key == 'n' || key == 'N')
				{
					exit();
				}
			}
		}
	}
}
