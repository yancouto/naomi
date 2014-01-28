package;

import flash.Lib;
import flixel.FlxGame;
import flixel.FlxState;

class GameClass extends FlxGame {
	public static var gameWidth:Int = 800; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	public static var gameHeight:Int = 600; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	public static var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	public static var framerate:Int = 60; // How many frames per second the game should run at.
	public static var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	public static var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	/**
	 * You can pretty much ignore this logic and edit the variables above.
	 */
	public function new() {
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		super(gameWidth, gameHeight, skipSplash? MenuState : SplashState, zoom, framerate, framerate, skipSplash, startFullscreen);
		
		flixel.FlxG.sound.muted = true;
		flixel.FlxG.sound.volume = 1;
	}
}
