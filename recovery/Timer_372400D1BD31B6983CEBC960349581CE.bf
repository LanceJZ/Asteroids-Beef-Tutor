using System;
using System.Diagnostics;

namespace AsteroidsTutor
{
	class Timer
	{
		Stopwatch lifeSW = new Stopwatch(true) ~ delete _;
		float amount;
		public bool enabled;
		public float seconds;

		public bool Elapsed
		{
			get
			{
				return seconds > amount;
			}
		}

		public float Amount
		{
			get
			{
				return amount;
			}

			set mut
			{
				amount = value;
				Reset();
			}
		}

		public float TimeLeft
		{
			get
			{
				return amount - seconds;
			}
		}

		public this ()
		{
			gameInstance.timers.Add(this);
		}

		public this (float amount)
		{
			this.amount = amount;
			enabled = true;
			gameInstance.timers.Add(this);
		}

		public void Update()
		{
			seconds += (float)lifeSW.Elapsed.TotalSeconds * 0.025f;

			if (Elapsed)
			{
				enabled = false;
			}
		}

		public void Reset()
		{
			lifeSW.Reset();
			lifeSW.Start();
			enabled = true;
			seconds = 0;
		}

		public void Reset(float amount)
		{
			this.amount = amount;
			Reset();
		}
	}
}
