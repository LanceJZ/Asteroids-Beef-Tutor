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

		public this () : base()
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
				if (boundingBox.Contains(shot.X, shot.Y) && shot.enabled)
				{
					shot.enabled = false;
					PlayerScored();
					Hit();
				}
			}

			if (CirclesIntercect(gameInstance.player))
			{
				PlayerScored();
				gameInstance.PlayerHit();
				Hit();
			}

			if (CirclesIntercect(gameInstance.ufoManager.theUFO))
			{
				gameInstance.ufoManager.Reset();
				Hit();
			}

			if (boundingBox.Contains(gameInstance.ufoManager.theUFO.shot.X,
				 gameInstance.ufoManager.theUFO.shot.Y) && gameInstance.ufoManager.theUFO.shot.enabled)
			{
				gameInstance.ufoManager.theUFO.shot.enabled = false;
				Hit();
			}
		}

		void Hit()
		{
			enabled = false;
			gameInstance.rockManager.RockDistroyed(this);
		}

        void PlayerScored()
        {
            uint32 points = 0;

            switch(size)
            {
                case GameApp.RockSize.Large:
                    points = 20;
                    break;
                case GameApp.RockSize.Medium:
                    points = 50;
                    break;
                case GameApp.RockSize.Small:
                    points = 100;
                    break;
            }

            gameInstance.Score += points;
        }
	}
}
