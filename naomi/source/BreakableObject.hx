package;

import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;

class BreakableObject extends FlxSprite {
	public var resistance : Float;

	override public function new(obj : base.Object) {
		super(obj.x, obj.y);
		
		resistance = obj.properties.exists("resistance")?
			Std.parseFloat(obj.properties.get("resistance"))*1000:40*1000;
	}

	public function checkCollision(?e : base.Enemy) : Void {}
	public function triggerBreaking(?e : base.Enemy) : Void {}

	public static function manageCollision(b : BreakableObject, e : base.Enemy) : Void {
		b.checkCollision(e);
	}

	public static var platforms : FlxTypedGroup<BreakableObject>;
}