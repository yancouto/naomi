package;

import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.FlxObject;
import base.Timer;

class BreakablePlatform extends FlxSprite {
	public var resistance : Float;

	public function new(obj : base.Object) {
		super(obj.x, obj.y);
		loadGraphic("assets/images/weakblockanimation.png", true, false, 128, 64);
		animation.add("still", [0]);
		animation.add("breaking", [1, 2], 4, false);
		animation.play("still");

		setSize(128, 36);
		immovable = true;
		resistance = obj.properties.exists("resistance")? Std.parseFloat(obj.properties.get("resistance"))*1000 : 40*1000;
	}

	public static function manageCollision(b : BreakablePlatform, e : base.Enemy) : Void {
		if(e.velocity.y * e.mass >= b.resistance) {
			b.animation.play("breaking");
			b.setSize(0, 0);
			Timer.callIn(.5, function() { b.destroy(); });
			e.velocity.y = 0;
		}
		else
			FlxObject.separate(b, e);
	}

	public static var platforms : FlxTypedGroup<BreakablePlatform>;
}