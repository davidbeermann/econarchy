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
		pixelFont = loadFont("resources/fonts/LCDDot-48.vlw");
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
			//println(this + " state: infoScreen");
			
			//fill(255);
			PImage startscreen = loadImage("resources/startscreen.png");
			image(startscreen, 0, 0);
			text(
				"Welcome X,\nToday the consumegood inc. annouced the construction of three more oil rigs in the north sea. They will be placed in a biologically very sensible area and as we know from the past the consumegood inc. tend to build their oil rigs on low budget and not very leakproof.\nPeacufull demonstrations are no longer a sufficient measure. We have to act and set signs.\nSome might call it acts of terrorism. We understand them as acts of non-violent resistance. And tonight we will start by announcing the existence of our organization.\nWe hit them were they feel save. You will have to climb the consumegood inc. headquarter and play our banner on the very top of the building. Be cautious don't get caught by any security guards or employees and take care of the plattforms you are climbing. They might behave against expectation. Place the banner and grab you parachute to sail down. Avoid the plattforms on your way down.\nYou can move using the arrowkeys.\n\nGood luck!\n\nPRESS S TO CONTINUE"
				, 45, 220, width-90, height - 220);
		// maybe put this into the keytracker
		if (keyPressed && key == 's' || key == 'S')
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
			//println(this + " state: GAME OVER");
			rect(0, 0, width, height);
			textAlign(CENTER,CENTER);
			fill(255);
			textFont(pixelFont, 48);
			text("GAME\nOVER", width/2, height/2);
			textFont(pixelFont, 20);
			text("CONTINUE Y / N", width/2, height/2+100);

				// maybe put this into the keytracker
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
}
