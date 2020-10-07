using System;
using Math;
using SDL2;

namespace AsteroidsTutor
{
	class Sprite : Entity
	{
		public Image image;
		public bool visable = true;

		public override void Draw()
		{
			base.Draw();

			if (image == null || !visable || !enabled)
				return;

			gameInstance.Draw(image, position.X - image.mSurface.w * 0.5f, position.Y - image.mSurface.h * 0.5f, rotation);

			//SDLApp has rotation in the draw, basically this code below built in.
			//With a bog, 0 where rot is supposed to go. I fixed the bug.
			//SDL.Rect srcRect = .(0, 0, image.mSurface.w, image.mSurface.h);
			//SDL.Rect destRect = .((int32)position.X, (int32)position.Y, image.mSurface.w, image.mSurface.h);
			//SDL.RenderCopyEx(gameInstance.mRenderer, image.mTexture, &srcRect, &destRect, (float)rotation,
			//	 null, SDL.RendererFlip.None);
		}

	}
}
