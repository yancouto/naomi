package base;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;

class Utils {
	public static function fadeOut(t : FlxSprite, delay : Float, duration : Float, destroyAfter : Bool = false) : FlxSprite {
		var opts = { complete: destroyAfter? function(_) { t.destroy(); } : null, type : FlxTween.ONESHOT };
		if(delay == 0) FlxTween.color(duration, t.color, t.color, 1, 0, opts, t);
		else Timer.callIn(delay, function() { FlxTween.color(duration, t.color, t.color, 1, 0, opts, t); });
		return t; // If you like to chain stuff
	}

	public static function fadeIn(t : FlxSprite, delay : Float, duration : Float) : FlxSprite {
		if(delay == 0) FlxTween.color(duration, t.color, t.color, 0, 1, t);
		else Timer.callIn(delay, function() { FlxTween.color(duration, t.color, t.color, 0, 1, t); });
		return t; // If you like to chain stuff
	}
}