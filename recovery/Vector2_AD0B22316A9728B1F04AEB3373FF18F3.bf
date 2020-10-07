using System;

namespace Math
{
	[CRepr]
	public struct Vector2
	{
		public static readonly Vector2 Zero = Vector2(0f, 0f);
		public static readonly Vector2 One = Vector2(1f, 1f);

		public float X;
		public float y;

		public this(float x, float y)
		{
			this.X = x;
			this.y = y;
		}

		public override void ToString(String strBuffer)
		{
			strBuffer.AppendF("({0}, {1})", X, y);
		}

		public static Vector2 operator +(Vector2 lhs, Vector2 rhs)
		{
			return Vector2(lhs.X + rhs.X, lhs.y + rhs.y);
		}

		public static Vector2 operator -(Vector2 lhs, Vector2 rhs)
		{
			return Vector2(lhs.X - rhs.X, lhs.y - rhs.y);
		}

		public static Vector2 operator *(Vector2 lhs, float rhs)
		{
			return Vector2(lhs.X * rhs, lhs.y * rhs);
		}

		public static Vector2 operator *(Vector2 lhs, Vector2 rhs)
		{
			return Vector2(lhs.X * rhs.X, lhs.y * rhs.y);
		}

		public static Vector2 operator /(Vector2 lhs, float rhs)
		{
			return Vector2(lhs.X / rhs, lhs.y / rhs);
		}

		public static Vector2 operator /(Vector2 lhs, Vector2 rhs)
		{
			return Vector2(lhs.X / rhs.X, lhs.y / rhs.y);
		}
	}
}
