using System;
using System.Diagnostics;
using System.Collections;
using System.IO;
using SDL2;
using Math;

namespace AsteroidsTutor
{
	public struct HighScore
	{
	    public uint32 score;
	    public String name;
	}
	
	static
	{
		public static GameApp gameInstance;
	}

	class GameApp : SDLApp
	{
		public enum GameState
		{
		    PlayerHit,
		    Over,
		    InPlay,
		    Pause,
		    HighScore,
		    MainMenu
		}
		
		public enum RockSize
		{
		    Small,
		    Medium,
		    Large
		}
		
		public enum UFOType
		{
		    Small,
		    Large
		}
		
		public Random random = new Random() ~ delete _;
		public List<Entity> entities = new List<Entity>() ~ DeleteContainerAndItems!(_);
		public List<Timer> timers = new List<Timer>() ~ DeleteContainerAndItems!(_);
		public Player player;
		public RockManager rockManager ~ delete _;
		public UFOManager ufoManager ~ delete _;
		Font fontLarge ~ delete _;
		Font fontSmall ~ delete _;
		uint32 score;
		uint32 highScore;
		GameState gameMode = GameState.Over;
		int wave;
		int lives;
		bool fireButtonUp = true;
		bool hyperButtonUp = true;

        public GameState CurrentMode { get => gameMode; set mut => gameMode = value; }

		public uint32 Score { get => score; set mut => score = value; }

		public int Wave { get => wave; }

		public int32 screenWidth { get => mWidth; set mut => mWidth = value; }

		public int32 screenHeight { get => mHeight; set mut => mHeight = value; }

		public this()
		{
			gameInstance = this;
			mWidth = 1280;
			mHeight = 960;

			mTitle.Clear();
			mTitle.Append("Asteroids Deluxe");

			player = new Player();
			rockManager = new RockManager();
			ufoManager = new UFOManager();
		}

		public ~this()
		{
			Images.Dispose();
		}

		public void Initialize()
		{
			base.Init();
			Images.Load();
			fontLarge = new Font();
			fontLarge.Load("Hyperspace.ttf", 30);
			fontSmall = new Font();
			fontSmall.Load("Hyperspace.ttf", 15);
			player.Initialize();
			rockManager.Initialize();
			ufoManager.Initialize();
		}

		public override void Update()
		{
			base.Update();

			if (IsKeyDown(SDL.Scancode.Escape))
			{
				Debug.WriteLine("Escape used to exit.");
				Environment.Exit(0);
			}

			if (gameMode == GameState.Over && IsKeyDown(SDL.Scancode.Return))
			{
				NewGame();
			}

			switch(gameMode)
			{
				case GameState.InPlay:
					HandleInputs();
					break;
				case GameState.PlayerHit:
					CheckPlayerClear();
					break;
				default:
			}

			for (Entity entity in entities)
			{
				entity.UpdateElapsed();

				if (entity.enabled)
					entity.Update();
			}

			for (Timer timer in timers)
			{
				if (timer.enabled)
					timer.Update();
			}

			rockManager.Update();
			ufoManager.Update();
		}

		public override void Draw()
		{
			base.Draw();

			for (Entity entity in entities)
			{
				if (entity.visable && entity.enabled)
					entity.Draw();
			}

			UpdateScore(score);
		}

		public override void KeyDown(SDL.KeyboardEvent evt)
		{
			base.KeyDown(evt);

			if (evt.keysym.scancode == .LCtrl && fireButtonUp)
			{
				fireButtonUp = false;
				player.Fire();
			}

			if (evt.keysym.scancode == .Down && hyperButtonUp)
			{
				hyperButtonUp = false;
				player.Hyperspace();
			}	
		}

		public override void KeyUp(SDL.KeyboardEvent evt)
		{
			base.KeyUp(evt);

			if (evt.keysym.scancode == .LCtrl)
			{
				fireButtonUp = true;
			}

			if (evt.keysym.scancode == .Down)
			{
				hyperButtonUp = true;
			}
		}

		public void DrawString(Font font, String text, ref Vector2 position,
			bool centerX = false, bool rightX = false)
		{
			SDL.Surface *surface = SDLTTF.RenderUTF8_Blended(font.mFont, text,
				 SDL.Color(255, 255, 255, 255));
			SDL.Texture *texture = SDL.CreateTextureFromSurface(mRenderer, surface);
			SDL.Rect srcRect = .(0, 0, surface.w, surface.h);

			if (centerX)
				position.X -= surface.w / 2;
			else if (rightX)
				position.X -= surface.w;

			SDL.Rect destRect = .((int32)position.X, (int32)position.Y, surface.w, surface.h);
			SDL.RenderCopy(mRenderer, texture, &srcRect, &destRect);
			SDL.FreeSurface(surface);
			SDL.DestroyTexture(texture);
		}

		public void UpdateScore(uint32 points)
		{
			String scoreString = scope String();
			NumberToString(points, scoreString);

			if (points == 0)
			{
				scoreString = "00";
			}

			DrawString(fontLarge, scoreString, ref Vector2(300, 1), false, true);
		}

		public void NumberToString(uint32 number, String string)
		{
			//String passed by reference, not a copy, so it changes it by reference.
			string.AppendF("{}", number);
		}
        /// <summary>
        /// Get a random int between min and max
        /// </summary>
        /// <param name="min">the minimum random value</param>
        /// <param name="max">the maximum random value</param>
        /// <returns>int</returns>
		public int RandomMinMax(int min, int max)
		{
			return min + (int)(random.NextDouble() * ((max + 1) - min));
		}
        /// <summary>
        /// Get a random float between min and max
        /// </summary>
        /// <param name="min">the minimum random value</param>
        /// <param name="max">the maximum random value</param>
        /// <returns>float</returns>
		public float RandomMinMax(float min, float max)
		{
			return min + (float)random.NextDouble() * (max - min);
		}

		public Vector2 RandomSideEdge()
		{
			return Vector2(0, RandomMinMax(0, mHeight));
		}

		public float RandomDegree()
		{
			return RandomMinMax(0f, 360f);
		}

		public void PlayerHit()
		{
		    player.Hit();
		    lives--;

		    if (lives < 0)
		    {
		        gameMode = GameState.Over;

		        if (score > highScore)
		        {
		            highScore = score;
		            //HighScoreChanged();
		            //SaveHighScore();
		        }

		        //CheckForNewHighScore();

		        return;
		    }

		    //PlayerShipDesplay();
		    gameMode = GameState.PlayerHit;
		}

		void NewGame()
		{
			lives = 4;
			score = 0;
			player.Spawn();
			ufoManager.Reset();
			rockManager.Reset();
		}

		void CheckPlayerClear()
		{
			Entity clearCircle = new Entity();
			clearCircle.radius = screenHeight * 0.125f;
			clearCircle.enabled = true;
			ufoManager.Reset();

			for (Rock rock in rockManager.rocksList)
			{
				if (clearCircle.CirclesIntercect(rock))
				{
					gameMode = GameState.InPlay;
					player.Spawn();
				}
			}
		}

		void HandleInputs()
		{

		}
	}
}
