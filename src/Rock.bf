using System;
using System.Diagnostics;
using System.Collections;
using SDL2;
using Math;

namespace AsteroidsTutor
{
	class Rock : Sprite
	{
		public GameApp.RockSize size;

		public this ()
		{
			rotationVelocity = gameInstance.RandomMinMax(-30f, 30f);
		}

		public ~this ()
		{
		}

		public void Initialize()
		{
			TheImage = Images.rockOne;
		}

		public override void Update()
		{
			base.Update();

			WrapEdge();
			CollisionCheck();
		}

		public override void Draw()
		{
			base.Draw();
		}

		void CollisionCheck()
		{
			for(Shot shot in gameInstance.player.shotsList)
			{
				if (CirclesIntercect(shot))
				{
					enabled = false;
					shot.enabled = false;
				}
			}
		}
	}
}
