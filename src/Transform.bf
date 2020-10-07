using System;
using System.Diagnostics;
using Math;

namespace AsteroidsTutor
{
	class Transform
	{
		Stopwatch elapsedSW = new Stopwatch(true) ~ delete _;
		float elapsed;
		public Vector2 position;
		public Vector2 acceleration;
		public Vector2 velocity;
		public float rotation;
		public float rotationVelocity;
		public float rotationAcceleration;
		public float radius;
		public bool enabled;
		double prevSec = elapsedSW.Elapsed.TotalSeconds;

		public this()
		{
		}

		public ~this()
		{
		}

		public void UpdateElapsed()
		{
			double nowSec = elapsedSW.Elapsed.TotalSeconds;
			elapsed = (float)nowSec - (float)prevSec;
			prevSec = nowSec;
		}

		public virtual void Update()
		{
			velocity += acceleration * elapsed;
			position += velocity * elapsed;
			rotationVelocity += rotationAcceleration * elapsed;
			rotation += rotationVelocity * elapsed;

			if (rotation > 360)
				rotation -= 360;

			if (rotation < 0)
				rotation += 360;
		}
	}
}
