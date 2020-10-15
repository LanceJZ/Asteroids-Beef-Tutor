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
					enabled = false;
					shot.enabled = false;
					PlayerScored();
					gameInstance.rockManager.RockDistroyed(this);
				}
			}

			if (CirclesIntercect(gameInstance.player) && gameInstance.player.enabled)
			{
				enabled = false;
				PlayerScored();
				gameInstance.rockManager.RockDistroyed(this);
			}

			if (CirclesIntercect(gameInstance.ufoManager.theUFO) && gameInstance.ufoManager.theUFO.enabled)
			{
				gameInstance.ufoManager.theUFO.Reset();
				enabled = false;
				gameInstance.rockManager.RockDistroyed(this);
			}
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
