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

		public this ()
		{

		}

		public ~this ()
		{
		}

		public void Initialize()
		{
			rocksList.Add(new Rock());
			rocksList.Back.enabled = true;
			rocksList.Back.Initialize();
			rocksList.Back.Spawn();
		}

		public void Update()
		{

		}

	}
}
