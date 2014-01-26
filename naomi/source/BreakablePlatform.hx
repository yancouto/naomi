package;

import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.FlxObject;

class BreakablePlatform extends FlxSprite {
	public var resistance : Float;

	public function new(obj : base.Object) {
		super(obj.x, obj.y);
		makeGraphic(128, 64, 0xffff0000);
		immovable = true;
		resistance = obj.properties.exists("resistance")? Std.parseFloat(obj.properties.get("resistance"))*1000 : 40*1000;
	}

	public static function manageCollision(b : BreakablePlatform, e : base.Enemy) : Void {
		trace(e.velocity.y + "    " + e.mass);
		if(e.velocity.y * e.mass >= b.resistance) {
			b.destroy();
			e.velocity.y = 0;
		}
		else
			FlxObject.separate(b, e);
	}

	public static var platforms : FlxTypedGroup<BreakablePlatform>;
}