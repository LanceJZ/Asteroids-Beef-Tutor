using System;
using System.Diagnostics;
using System.Collections;
using SDL2;
using Math;

namespace AsteroidsTutor
{
	class UFOManager
	{
		public UFO theUFO;
		Timer spawnTimer;
		uint spawnCount;

		public this ()
		{
			theUFO = new UFO();
			spawnTimer = new Timer(12);
		}

		public ~this ()
		{
		}

		public void Initialize()
		{
			theUFO.Initialize();
			//ResetTimer();
		}

		public void Update()
		{
			if (spawnTimer.Elapsed)
			{
				ResetTimer();

				if (!theUFO.enabled)
				{
					Spawn();
				}
			}
		}

		public void ResetTimer()
		{
			spawnTimer.Reset(gameInstance.RandomMinMax(10.0f - gameInstance.Wave * 0.1f,
				10.15f + gameInstance.Wave * 0.1f));
		}

		public void Reset()
		{
			theUFO.enabled = false;
			ResetTimer();
		}

		void Spawn()
		{
			float spawnPercent = (float)(Math.Pow(0.915, spawnCount / (float)(gameInstance.Wave + 1)) * 100);
			Vector2 position = Vector2.Zero;

			if (gameInstance.RandomMinMax(0, 99) < spawnPercent - gameInstance.Score / 400)
			{
			    theUFO.type = GameApp.UFOType.Large;
			    theUFO.Scale = 1;
			}
			else
			{
			    theUFO.type = GameApp.UFOType.Small;
			    theUFO.Scale = 0.5f;
			}

			position.Y = gameInstance.RandomMinMax(gameInstance.screenHeight * 0.25f,
				 gameInstance.screenHeight * 0.75f);

			if (gameInstance.RandomMinMax(1, 10) > 5)
			{
			    position.X = 0;
			}
			else
			{
			    position.X = gameInstance.screenWidth;
			}

			theUFO.Spawn(position);
		}
	}
}
