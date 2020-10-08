using System;
using System.Diagnostics;
using System.Collections;
using SDL2;
using Math;

namespace AsteroidsTutor
{
	class Rock : Sprite
	{
		public this ()
		{
			rotationVelocity = gameInstance.RandomMinMax(-30f, 30f);
		}

		public ~this ()
		{
		}

		public void Initialize()
		{
			image = Images.rockOne;
		}

		public override void Update()
		{
			base.Update();

			WrapEdge();
		}

		public override void Draw()
		{
			base.Draw();

		}

		public void Spawn()
		{
			Spawn(gameInstance.RandomSideEdge());
			RandomVelocity(50);
		}
	}
}
