package;

import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.effects.FlxTrail;
import flixel.FlxState;
import flixel.FlxG;

class Selector extends FlxSprite {
	private var mover : flixel.tweens.motion.LinearMotion;

	public function new(x : Float, y : Float) {
		super(x, y);

		loadGraphic("assets/images/soul_animation.png", true, false, 32, 32);
		animation.add("moving", [for(i in 1...5) i], 8);
		animation.play("moving");

		angularVelocity = -50;

		mover = new flixel.tweens.motion.LinearMotion(null, FlxTween.PINGPONG);
		mover.setObject(this);
		FlxTween.manager.add(mover);
		refresh();
	}

	public function refresh() : Void
		mover.setMotion(x, y, x, y + 20, 20, false);

	override public function destroy() : Void {
		mover.cancel();
		mover.destroy();
		mover = null;
		super.destroy();
	}
}