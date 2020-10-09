using System;
using System.Diagnostics;
using System.Collections;
using SDL2;
using Math;

namespace AsteroidsTutor
{
	class Shot : Sprite
	{
		Timer life;

		public this ()
		{
			life = new Timer();
		}

		public ~this ()
		{
		}

		public override void Update()
		{
			base.Update();

			if (life.Elapsed)
			{
				enabled = false;
			}

			WrapEdge();
		}

		public override void Draw()
		{
			base.Draw();
		}

		public new void Spawn(Vector2 position, Vector2 velocity, float timer)
		{
		    Spawn(position, velocity);
		    life.Reset(timer);
		}
	}
}
