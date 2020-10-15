using System;
using System.Diagnostics;
using Math;
using SDL2;

namespace AsteroidsTutor
{
	class Sprite : Entity
	{
		Image image;

		public Image TheImage
		{
			set mut
			{
				image = value;
				RadiusFromImage();
			}
		}

		public float Scale
		{
			set mut
			{
				scale = value;
				boundingBox.h = (int32)(image.mSurface.h * scale);
				boundingBox.w = (int32)(image.mSurface.w * scale);
			}
		}

		public this() : base()
		{
		}

		public override void Update()
		{
			base.Update();
		}

		public override void Draw()
		{
			base.Draw();

			if (image == null || !visable)
			{
				if (image == null)
					Debug.WriteLine("Image is null for Sprite draw.");

				return;
			}

			//gameInstance.Draw(image, position.X - image.mSurface.w * 0.5f,
			//	 position.Y - image.mSurface.h * 0.5f, rotation);

			//SDLApp has rotation in the draw, basically this code below built in.
			//With a bug, 0 where rot is supposed to go. I fixed the bug.
			//Can't use anymore, need scale.

			SDL.Rect srcRect = .(0, 0, image.mSurface.w, image.mSurface.h);
			SDL.Rect destRect = .((int32)(position.X - ((image.mSurface.w * 0.5f) * scale)),
				 (int32)(position.Y - ((image.mSurface.h * 0.5f) * scale)), (int32)(image.mSurface.w * scale),
				 (int32)(image.mSurface.h * scale));
			SDL.RenderCopyEx(gameInstance.mRenderer, image.mTexture, &srcRect, &destRect, (float)rotation,
				 null, SDL.RendererFlip.None);
		}

		void RadiusFromImage()
		{
			if (image == null)
			{
				Debug.WriteLine("Unable to make radius of Sprite, image is null.");
				return;
			}

			if (image.mSurface.h > image.mSurface.w)
			{
				radius = (image.mSurface.h / 2);
			}
			else
			{
				radius = (image.mSurface.w / 2);
			}

			bbHalfSize.X = image.mSurface.w / 2;
			bbHalfSize.Y = image.mSurface.h / 2;
		}
	}
}
