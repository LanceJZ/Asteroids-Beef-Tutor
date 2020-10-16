using System;
using Math;
using SDL2;

namespace AsteroidsTutor
{
	class Entity : Transform
	{
		public bool hit;
		public const float TWO_PI = Math.PI_f * 2;
		public float scale = 1;
		public SDL.Rect boundingBox;
		public Vector2 bbHalfSize;
		public bool enabled;
		public bool visable = true;

		public this()
		{
			gameInstance.entities.Add(this);
		}

		public ~this()
		{
		}

		public override void Update()
		{
			if (enabled)
				base.Update();

			boundingBox.x = X - (int32)(bbHalfSize.X * scale);
			boundingBox.y = Y - (int32)(bbHalfSize.Y * scale);
		}

		public virtual void Draw()
		{
		}

		public bool IsOffScreen(Vector2 margin)
		{
			return ((X < -margin.X) || (X > gameInstance.mWidth + margin.X) ||
				(Y < -margin.Y) || (Y > gameInstance.mWidth + margin.Y));
		}

		public bool CirclesIntercect(Entity target)
		{
			if (!enabled || !target.enabled)
				return false;

			float distanceX = target.position.X - X;
			float distanceY = target.position.Y - Y;
			float totalRadius = (radius * scale) + (target.radius * target.scale);

			if((distanceX * distanceX) + (distanceY * distanceY) < totalRadius * totalRadius)
				return true;

			return false;
		}

		public void RandomVelocity(float magnitude)
		{
			velocity = (VelocityFromAngle(gameInstance.RandomDegree(),
				gameInstance.RandomMinMax(magnitude * 0.15f, magnitude)));
		}

        /// <summary>
        /// Returns a Vector2 direction of travel from rotation and set magnitude.
        /// </summary>
        /// <param name="magnitude"></param>
        /// <returns>Vector2</returns>
        public Vector2 VelocityFromAngle(float magnitude)
        {
			float radRotation = DegreeToRadium(rotation);
            return Vector2(Math.Cos(radRotation) * magnitude, Math.Sin(radRotation) * magnitude);
        }

		public Vector2 VelocityFromAngle(float rotation, float magnitude)
		{
			float radRotation = DegreeToRadium(rotation);
		    return Vector2(Math.Cos(radRotation) * magnitude, Math.Sin(radRotation) * magnitude);
		}
		/// <summary>
		/// Aims at target using the position.
		/// Returns float for rotation velocity in degrees.
		/// </summary>
		/// <param name="target">Vector3</param>
		/// <param name="magnitude">float</param>
		/// <returns>float</returns>
		public float PointAtTarget(Vector2 target, float magnitude)
		{
			float turnRotationVelocity = 0;
			float rotationRadium = DegreeToRadium(rotation);
			float targetAngleRadium = DegreeToRadium(AngleFromTargetPosition(target));
			float targetLessFacing = targetAngleRadium - rotationRadium;
			float facingLessTarget = rotationRadium - targetAngleRadium;

			if (Math.Abs(targetLessFacing) > Math.PI_f)
			{
				if (rotationRadium > targetAngleRadium)
				{
					facingLessTarget = ((TWO_PI - rotationRadium) + targetAngleRadium) * -1;
				}
				else
				{
					facingLessTarget = (TWO_PI - targetAngleRadium) + rotationRadium;
				}
			}

			if (facingLessTarget > 0)
			{
				turnRotationVelocity = -magnitude;
			}
			else
			{
				turnRotationVelocity = magnitude;
			}

			return RadiumToDegree(turnRotationVelocity);
		}

		public float AngleFromTargetPosition(Entity target)
		{
			return AngleFromTargetPosition(target.position);
		}

		public float AngleFromTargetPosition(Vector2 target)
		{
			return RadiumToDegree(Math.Atan2(target.Y - Y, target.X - X));
		}

		public float DegreeToRadium(float angle)
		{
			return angle * Math.PI_f / 180;
		}

		public float RadiumToDegree(float angle)
		{
			return angle * (180 / Math.PI_f);
		}

		public void WrapTopBottom()
		{
			if (Y > gameInstance.mHeight)
			   Y = 0;

			if (Y < 0)
				Y = gameInstance.mHeight;
		}

		public bool WentOFFSideBorders()
		{
			if (X > gameInstance.mWidth || X < 0)
			{
				return true;
			}

			return false;
		}

		public void WrapEdge()
		{
			if (X < 0)
				X = gameInstance.mWidth;
			else if (X > gameInstance.mWidth)
				X = 0;

			if (Y < 0)
				Y = gameInstance.mHeight;

			if (Y > gameInstance.mHeight)
				Y = 0;
		}
        #region Spawn
        /// <summary>
        /// If position, rotation, rotation velocity and velocity are used.
        /// </summary>
        /// <param name="position">Position to spawn at.</param>
        /// <param name="rotation">Rotation to spawn at.</param>
        /// <param name="rotationVelocity">Initial Rotation velocity to spawn with.</param>
        /// <param name="velocity">Initial velocity to spawn with.</param>
        public virtual void Spawn(Vector2 position, Vector2 velocity, float rotation, float rotationVelocity)
        {
			this.position = position;
            this.velocity = velocity;
			this.rotation = rotation;
            this.rotationVelocity = rotationVelocity;
			enabled = true;
			hit = false;
        }
        /// <summary>
        /// If position, rotation and velocity are used.
        /// </summary>
        /// <param name="position">Position to spawn at.</param>
        /// <param name="rotation">Rotation to spawn at.</param>
        /// <param name="velocity">Initial velocity to spawn with.</param>
        public virtual void Spawn(Vector2 position, Vector2 velocity, float rotation)
        {
            Spawn(position, velocity, rotation, 0);
        }
        /// <summary>
        /// If only position and rotation are used.
        /// </summary>
        /// <param name="position">Position to spawn at.</param>
        /// <param name="rotation">Rotation to spawn at.</param>
        public virtual void Spawn(Vector2 position, Vector2 velocity)
        {
            Spawn(position, velocity, 0);
        }
        /// <summary>
        /// If only position is used.
        /// </summary>
        /// <param name="position">Position to spawn at.</param>
        public virtual void Spawn(Vector2 position)
        {
			Spawn(position, Vector2.Zero);
        }
        #endregion
	}
}
