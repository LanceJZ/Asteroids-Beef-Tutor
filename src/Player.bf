using System;
using System.Diagnostics;
using System.Collections;
using SDL2;
using Math;

namespace AsteroidsTutor
{
	class Player : Sprite
	{
		Sprite flame = new Sprite();
		Timer flameTimer = new Timer(0.001666f);
		public List<Shot> shotsList = new List<Shot>() ~ DeleteContainerAndItems!(_);

		public this ()
		{
			position.X = gameInstance.mWidth / 2;
			position.Y = gameInstance.mHeight / 2;
			enabled = true;
		}

		public ~this ()
		{
		}

		public void Initialize()
		{
			image = Images.player;
			flame.image = Images.playerFlame;

			for (int i < 4)
			{
				shotsList.Add(new Shot());
				shotsList.Back.Initialize();
			}
		}

		public override void Update()
		{
			base.Update();
			HandleInputs();
			WrapEdge();

			flame.position = VelocityFromAngle(-30) + position;
			flame.rotation = rotation;

			for(Shot shot in shotsList)
			{
				shot.UpdateElapsed();

				if (shot.enabled)
					shot.Update();
			}
		}

		public override void Draw()
		{
			base.Draw();
		}

		public void Fire()
		{
			for(Shot shot in shotsList)
			{
				if (!shot.enabled)
				{
					shot.enabled = true;
					Vector2 vfa = VelocityFromAngle(800);
					shot.Spawn(position + VelocityFromAngle(30), vfa, 1.5f);
					break;
				}
			}

			Debug.WriteLine("Fire");
		}

		public void Hyperspace()
		{

			Debug.WriteLine("Hyperspace");
		}

		void HandleInputs()
		{
			if(gameInstance.IsKeyDown(.Right))
			{
				rotationVelocity = 200;
			}
			else if(gameInstance.IsKeyDown(.Left))
			{
				rotationVelocity = -200;
			}
			else
			{
				rotationVelocity = 0;
			}

			if (gameInstance.IsKeyDown(.Up))
			{
				acceleration = VelocityFromAngle(100);

				flame.UpdateElapsed();

				if (flameTimer.Elapsed)
				{
					flameTimer.Reset();
					flame.enabled = true;
				}
				else
				{
					flame.enabled = false;
				}
			}
			else
			{
				acceleration = (velocity * -1) * 0.2666f;

				flame.enabled = false;
			}
		}
	}
}
