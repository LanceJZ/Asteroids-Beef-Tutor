using System;
using System.Collections;
using SDL2;

namespace AsteroidsTutor
{
	static class Images
	{
		public static Image player;
		public static Image playerFlame;
		public static Image shot;
		public static Image rockOne;

		static List<Image> images = new .() ~ delete _;

		public static Result<Image> Load(StringView fileName)
		{
			Image image = new Image();

			if (image.Load(fileName) case .Err)
			{
				delete image;
				return .Err;
			}

			images.Add(image);

			return image;
		}

		public static void Dispose()
		{
			ClearAndDeleteItems(images);
		}

		public static Result<void> Load()
		{
			player = Try!(Load("images/PlayerShip.png"));
			shot = Try!(Load("images/Shot.png"));
			playerFlame = Try!(Load("images/PlayerFlame.png"));
			rockOne = Try!(Load("images/RockOne.png"));

			return .Ok;
		}
	}
}
