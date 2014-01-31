public class GUI
{
	PFont pixelFont;
	int frame, size, points, meterToGo, levelHeight, overlayPosY;
	float playerpos;
	Player player;
	boolean sawInfoScreen;
	PImage gameoverOverlay;


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
		winner();
		storyCounter();
	}


	void storyCounter()
	{
		if (!game.gameOver && !player.isWinner)
		{
			//TODO remove static substraction
			meterToGo = levelHeight - int((playerpos - player.position.y)/player.jumpHeight) - 8;
			
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
  sawInfoScreen = true;
				game.startGame();
	//sawInfoScreen = true;
			}
		}
	}


	void gameOver()
	{
		if (!player.alive) 
		{
			if(gameoverOverlay == null)
			{
				gameoverOverlay = loadImage("resources/screens/gameoverOverlay.png");
			}

			if(!game.gameOver)
			{
				game.gameOver = true;
				overlayPosY = -gameoverOverlay.height;
			}

			PImage main = loadImage("resources/screens/gameover.png");
			image(main, 0, 0);

			if(overlayPosY < 0) overlayPosY += 6;
			image(gameoverOverlay, 0, overlayPosY);

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


	void winner()
	{
		if(player.isWinner)
		{
			PImage main = loadImage("resources/screens/winscreen.png");
			image(main, 0, 0);

			if (keyPressed && key == ' ')
			{
				sawInfoScreen = false;
				game.gameOver = true;
				player.isWinner = false;
			}	
		}
		
	}
}
