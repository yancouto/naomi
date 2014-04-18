package;

import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.FlxObject;
import base.Timer;

class BreakablePlatform extends BreakableObject {
	public function new(obj : base.Object) {
		super(obj);
		loadGraphic("assets/images/weakblockanimation.png", true, false, 128, 64);
		animation.add("still", [0]);
		animation.add("breaking", [1, 2], 4, false);
		animation.play("still");

		setSize(128, 36);
		immovable = true;
	}

	override public function checkCollision(?e : base.Enemy) : Void {
		if(e.velocity.y * e.mass >= resistance) 
			triggerBreaking(e);
		else 
			FlxObject.separate(this, e);
	}

	override public function triggerBreaking(?e : base.Enemy) : Void {
		animation.play("breaking");
		setSize(0, 0);
		Timer.callIn(.5, function() { destroy(); });
		e.velocity.y = 0;
	}
}