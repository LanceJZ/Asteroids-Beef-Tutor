namespace AsteroidsTutor
{
	class Program
	{
		public static void Main()
		{
			let gameApp = scope GameApp();
			gameApp.Initialize();
			gameApp.Run();
		}
	}
}