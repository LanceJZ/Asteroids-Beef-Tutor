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
				Initailize();
			}
		}

		public bool visable = true;
		public float scale = 1;

		public void Initailize()
		{
			if (image == null)
			{
				Debug.WriteLine("Unable to make radius of Sprite, image is null.");
				return;
			}

			if (image.mSurface.h > image.mSurface.w)
			{
				radius = (image.mSurface.h / 2) * scale;
			}
			else
			{
				radius = (image.mSurface.w / 2) * scale;
			}
		}

		public override void Draw()
		{
			base.Draw();

			if (image == null || !visable || !enabled)
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
			SDL.Rect destRect = .((int32)(position.X - (image.mSurface.w * 0.5f * scale)),
				 (int32)(position.Y - (image.mSurface.h * 0.5f - scale)), (int32)(image.mSurface.w * scale),
				 (int32)(image.mSurface.h * scale));
			SDL.RenderCopyEx(gameInstance.mRenderer, image.mTexture, &srcRect, &destRect, (float)rotation,
				 null, SDL.RendererFlip.None);
		}
	}
}
