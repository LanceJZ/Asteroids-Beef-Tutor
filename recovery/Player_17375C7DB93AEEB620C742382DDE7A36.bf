using System;
using System.Diagnostics;
using System.Collections;
using SDL2;
using Math;

namespace AsteroidsTutor
{
	class Player : Sprite
	{
		public List<Shot> shotsList = new List<Shot>();// ~ DeleteContainerAndItems!(_);

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

			for (int i < 4)
			{
				shotsList.Add(new Shot());
				shotsList.Back.Initialize();
				gameInstance.entities.Add(shotsList.Back);
			}
		}

		public override void Update()
		{
			base.Update();
			HandleInputs();
			WrapEdge();
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
			}
			else
			{
				acceleration = (velocity * -1) * 0.2666f;
			}
		}
	}
}
