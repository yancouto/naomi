package base;

import flixel.FlxG;

class Utils {
	public static function sign(x : Float) : Int
		return x == 0? 0 : x > 0? 1 : -1;

	public static function pause() : Void {
		Reg.paused = !Reg.paused;
		Platform.pause();
	}
}