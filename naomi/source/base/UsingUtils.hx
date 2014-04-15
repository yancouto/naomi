package base;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxPoint;

class UsingUtils {
	public static function fadeOut(t : FlxSprite, delay : Float, duration : Float, destroyAfter : Bool = false) : FlxSprite {
		var opts = { complete: destroyAfter? function(_) { t.destroy(); } : null, type : FlxTween.ONESHOT };
		if(delay == 0) FlxTween.color(t, duration, t.color, t.color, 1, 0, opts);
		else Timer.callIn(delay, function() { FlxTween.color(t, duration, t.color, t.color, 1, 0, opts); });
		return t; // If you like to chain stuff
	}

	public static function fadeIn(t : FlxSprite, delay : Float, duration : Float) : FlxSprite {
		if(delay == 0) FlxTween.color(t, duration, t.color, t.color, 0, 1);
		else Timer.callIn(delay, function() { FlxTween.color(t, duration, t.color, t.color, 0, 1); });
		return t; // If you like to chain stuff
	}

	public static inline function length(p : FlxPoint) : Float
		return Math.sqrt(p.x*p.x + p.y*p.y);

	public static function mult(p : FlxPoint, v : Float) : FlxPoint {
		p.x *= v;
		p.y *= v;
		return p;
	}

	public static function normalize(p : FlxPoint) : FlxPoint
		return mult(p, 1/length(p));
}