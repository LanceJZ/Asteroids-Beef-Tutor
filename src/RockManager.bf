using System;
using System.Diagnostics;
using System.Collections;
using SDL2;
using Math;

namespace AsteroidsTutor
{
	class RockManager
	{
		public List<Rock> rocksList = new List<Rock>() ~ DeleteContainerAndItems!(_);
		int largeRockAmount = 2;

		public this ()
		{

		}

		public ~this ()
		{
		}

		public void Initialize()
		{
			NewWaveSpawn();
		}

		public void Update()
		{


		}

		public void RockDistroyed(Rock rockHit)
		{
			switch (rockHit.size)
			{
				case GameApp.RockSize.Large:
					SpawnRocks(rockHit.position, GameApp.RockSize.Medium, 2);
					break;
				case GameApp.RockSize.Medium:
					SpawnRocks(rockHit.position, GameApp.RockSize.Small, 2);
					break;
				case GameApp.RockSize.Small:
					bool spawnWave = true;
	
					for (Rock rock in rocksList)
					{
						if (rock.enabled)
						{
							spawnWave = false;
						}
					}
	
					if (spawnWave)
					{
						NewWaveSpawn();
					}
					break;
	
				default:
			}
		}

		public void Reset()
		{
			for (Rock rock in rocksList)
			{
				rock.enabled = false;
			}

			largeRockAmount = 2;
			NewWaveSpawn();
		}

		void SpawnRocks(Vector2 position, GameApp.RockSize size, int count)
		{
			for (int numberOfRocks < count)
			{
				bool spawnNewRock = true;
				int rock = rocksList.Count;

				for (int i < rock)
				{
					if (!rocksList[i].enabled)
					{
						spawnNewRock = false;
						rock = i;
						break;
					}
				}

				if (spawnNewRock)
				{
					rocksList.Add(new Rock());
				}

				float maxSpeed = 150;

				switch (size)
				{
					case GameApp.RockSize.Large:
						SpawnRock(rock, 1, gameInstance.RandomSideEdge(), maxSpeed / 3,
						GameApp.RockSize.Large);
						break;
					case GameApp.RockSize.Medium:
						SpawnRock(rock, 0.5f, position,
						maxSpeed / 2,
						GameApp.RockSize.Medium);
						break;
					case GameApp.RockSize.Small:
						SpawnRock(rock, 0.25f, position,
						maxSpeed,
						GameApp.RockSize.Small);
						break;

					default:
				}
			}
		}

		void SpawnRock(int rock, float scale, Vector2 position, float speed, GameApp.RockSize size)
		{
			rocksList[rock].Initialize();
			rocksList[rock].Scale = scale;
			rocksList[rock].size = size;
			rocksList[rock].Spawn(position + Vector2(rocksList[rock].radius * scale,
				 rocksList[rock].radius * scale));
			rocksList[rock].rotationVelocity = gameInstance.RandomMinMax(-10, 10);
			rocksList[rock].RandomVelocity(speed);
		}

		void NewWaveSpawn()
		{
			if (largeRockAmount < 12)
			{
				largeRockAmount += 2;
			}

			SpawnRocks(Vector2.Zero, GameApp.RockSize.Large, largeRockAmount);
		}
	}
}
