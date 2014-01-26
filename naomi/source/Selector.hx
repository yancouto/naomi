package;

import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.effects.FlxTrail;
import flixel.FlxState;
import flixel.FlxG;

class Selector extends FlxSprite {
	private var mover : FlxTween;
	private var trail : FlxTrail;

	public function new(x : Float, y : Float) {
		super(x, y);

		loadGraphic("assets/images/soulAnim2.png", true, false, 32, 32);
		animation.add("def", [for(i in 0...12) i], 24);
		animation.play("def");

		trail = new FlxTrail(this, null, 5, 0, .5, .1);

		mover = FlxTween.linearPath(this, [new FlxPoint(x, y-10),
			new FlxPoint(x, y+10)], 20, false, {type: FlxTween.PINGPONG});
	}

	public function refresh() : Void {
		mover = FlxTween.linearPath(this, [new FlxPoint(x, y-10),
			new FlxPoint(x, y+10)], 20, false, {type: FlxTween.PINGPONG});
	}
}