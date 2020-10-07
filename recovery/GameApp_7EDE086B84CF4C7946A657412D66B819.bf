using System;
using System.Diagnostics;
using System.Collections;
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
		Font font ~ delete _;
		public Player player;
		bool fireButtonUp = true;
		bool hyperButtonUp = true;

		public this()
		{
			gameInstance = this;
			mWidth = 1280;
			mHeight = 960;

			player = new Player();
		}

		public ~this()
		{
			Images.Dispose();
		}

		public void Initilize()
		{
			base.Init();
			Images.Load();
			font = new Font();
			font.Load("Hyperspace.ttf", 24);
			player.Initialize();
		}

		public override void Update()
		{
			base.Update();

			if (IsKeyDown(SDL.Scancode.Escape))
			{
				Debug.WriteLine("Escape");
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
		}

		public override void Draw()
		{
			base.Draw();

			for (Entity entity in entities)
			{
				entity.Draw();
			}
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

		public void DrawString(ref Vector2 position, String text, SDL.Color color, bool centerX = false)
		{
			SDL.SetRenderDrawColor(mRenderer, 255, 255, 255, 255);
			let surface = SDLTTF.RenderUTF8_Blended(font.mFont, text, color);
			let texture = SDL.CreateTextureFromSurface(mRenderer, surface);
			SDL.Rect srcRect = .(0, 0, surface.w, surface.h);

			if (centerX)
				position.X -= surface.w / 2;

			SDL.Rect destRect = .((int32)position.X, (int32)position.Y, surface.w, surface.h);
			SDL.RenderCopy(mRenderer, texture, &srcRect, &destRect);
			SDL.FreeSurface(surface);
			SDL.DestroyTexture(texture);
		}

		void HandleInputs()
		{

		}
	}
}
