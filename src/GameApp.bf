using System;
using System.Diagnostics;
using System.Collections;
using System.IO;
using SDL2;
using Math;

namespace AsteroidsTutor
{
	static
	{
		public static GameApp gameInstance;
	}

	class GameApp : SDLApp
	{
		public Random random = new Random() ~ delete _;
		public List<Entity> entities = new List<Entity>() ~ DeleteContainerAndItems!(_);
		public List<Timer> timers = new List<Timer>() ~ DeleteContainerAndItems!(_);
		Font fontLarge ~ delete _;
		Font fontSmall ~ delete _;
		public Player player;
		public RockManager rockManager ~ delete _;
		uint32 score;
		bool fireButtonUp = true;
		bool hyperButtonUp = true;

		public enum RockSize
		{
		    Small,
		    Medium,
		    Large
		};

		public enum UFOType
		{
		    Small,
		    Large
		}

		public this()
		{
			gameInstance = this;
			mWidth = 1280;
			mHeight = 960;
			mTitle.Replace("Beef Sample", "Asteroids Deluxe");
			player = new Player();
			rockManager = new RockManager();
		}

		public ~this()
		{
			Images.Dispose();
			
		}

		public void Initilize()
		{
			base.Init();
			Images.Load();
			fontLarge = new Font();
			fontLarge.Load("Hyperspace.ttf", 30);
			fontSmall = new Font();
			fontSmall.Load("Hyperspace.ttf", 15);
			player.Initialize();
			rockManager.Initialize();
			UpdateScore(100);
		}

		public override void Update()
		{
			base.Update();

			if (IsKeyDown(SDL.Scancode.Escape))
			{
				Debug.WriteLine("Escape used to exit.");
				Environment.Exit(0);
			}

			HandleInputs();

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
		}

		public override void Draw()
		{
			base.Draw();

			for (Entity entity in entities)
			{
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

		void HandleInputs()
		{

		}
	}
}
