package;

import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;

class Boulder extends FlxSprite {
	public static var boulders : FlxTypedGroup<Boulder>;
	private var source : base.Circuitry;
	private var speedX : Float;

	public function new(obj : base.Object) {
		super(obj.x, obj.y + obj.height - 104);
		loadGraphic("assets/images/boulder.png", false);
		offset.set(0, 2);

		speedX = Std.parseFloat(obj.properties.get("speed"));


		if(obj.properties.exists("source"))
			source = Reg.getTrigger(obj.properties.get("source"));
		else {
			source = null;
			roll();
		}
	}

	override public function update() : Void {
		super.update();
		angularVelocity = velocity.x;
		if(speedX == 0 && angularVelocity == 0 && !immovable) {
			immovable = true;
			acceleration.set(0, 0);
			velocity.set(0, 0);
		}

		if(source != null && source.state) {
			source = null;
			roll();
		}
	}

	private function roll() : Void {
		velocity.set(speedX, 0);
		acceleration.set(0, 400);
		speedX = 0;
	}

	public static function manageCollision(b : Boulder, e : base.Enemy) : Void {
		if(b.immovable) flixel.FlxObject.separate(e, b);
		else if(((e.x - b.x - 52) * (e.x - b.x - 52) + (e.y - b.y - 52) * (e.y - b.y - 52) <= 52 * 52
			|| (e.x + e.width - b.x - 52) * (e.x + e.width - b.x - 52) + (e.y - b.y - 52) * (e.y - b.y - 52) <= 52 * 52))
			e.hurt(100000);
	}
}