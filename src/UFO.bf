using System;
using System.Diagnostics;
using System.Collections;
using SDL2;
using Math;

namespace AsteroidsTutor
{
	class UFO : Sprite
	{
		public Shot shot;
		public GameApp.UFOType type;
		Timer fireTimer;
		Timer vectorTimer;
		float speed = 0;
		float shotSpeed = 16.666f;

		public this ()
		{
			shot = new Shot();
			fireTimer = new Timer(2.75f);
			vectorTimer = new Timer(3.15f);
		}

		public ~this ()
		{
		}

		public void Initialize()
		{
			TheImage = Images.UFO;
		}

		public override void Update()
		{
			base.Update();

			CollisionCheck();
			CheckXEdge();
			WrapEdge();

			if (vectorTimer.Elapsed)
				ChangeVector();
		}

		public override void Draw()
		{
			base.Draw();
			
		}

		public override void Spawn(Vector2 position)
		{
			base.Spawn(position);

			switch (type)
			{
				case GameApp.UFOType.Large:
					speed = 45.666f;
					break;
				case GameApp.UFOType.Small:
					speed = 60.666f;
					break;
				default:
			}

			if (X < gameInstance.screenWidth / 2)
			{
				velocity.X = speed;
			}
			else
			{
				velocity.X = -speed;
			}

			fireTimer.Reset();
			vectorTimer.Reset();
		}

		public void Reset()
		{
			gameInstance.ufoManager.ResetTimer();
			enabled = false;
		}

		void CheckXEdge()
		{
			if (X > gameInstance.screenWidth || X < 0)
				Reset();
		}

		void CollisionCheck()
		{
			for(Shot shot in gameInstance.player.shotsList)
			{
				if (boundingBox.Contains(shot.X, shot.Y) && shot.enabled)
				{
					enabled = false;
					shot.enabled = false;
					gameInstance.ufoManager.ResetTimer();
					PlayerScored();
				}
			}

			if (CirclesIntercect(gameInstance.player) && gameInstance.player.enabled)
			{
				enabled = false;
				PlayerScored();
			}
		}

		void ChangeVector()
		{
			vectorTimer.Reset();

			if (gameInstance.RandomMinMax(1, 10) < 5)
			{
				if ((int)(velocity.Y) == 0)
				{
					if (gameInstance.RandomMinMax(1, 10) < 5)
					{
						velocity.Y = speed;
					}
					else
					{
						velocity.Y = -speed;
					}
				}
				else
				{
					velocity.Y = 0;
				}
			}
		}

		void Fire()
		{
			fireTimer.Reset();
		}

		float AimedFire()
		{
			float percentChance = 0.25f - (gameInstance.Score * 0.00001f);

			if (percentChance < 0)
			{
				percentChance = 0;
			}

			return AngleFromTargetPosition(gameInstance.player) +
				gameInstance.RandomMinMax(-percentChance, percentChance);
		}

		void PlayerScored()
		{
			uint32 points = 0;

			switch(type)
			{
				case GameApp.UFOType.Large:
					points = 200;
					break;
				case GameApp.UFOType.Small:
					points = 1000;
					break;
			}

			gameInstance.Score += points;
		}
	}
}
