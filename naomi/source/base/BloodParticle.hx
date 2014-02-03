package base;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.group.FlxTypedGroup;

class BloodParticle extends FlxSprite {
	public static var particles : FlxTypedGroup<BloodParticle>;

	private var lifeSpan : Float;
	private var time : Float;

	public function new(obj : FlxObject) {
		super(obj.x + obj.width * (Math.random() * 0.6 + 0.2), obj.y + obj.height * (Math.random() * 0.6 + 0.2));
		makeGraphic(4, 4, 0xffee2222);

		acceleration.y = 420;

		velocity.set(Math.random() * 400 - 200, -Math.random() * 200 - 100);

		lifeSpan = 8 + Math.random() * 4;
		time = 0;
	}

	override public function update() : Void {
		super.update();
		if(exists) {
			time += FlxG.elapsed;
			if(time >= lifeSpan)
				destroy();
		}
	}

	public static function handleOverlap(blood : BloodParticle, other : FlxObject) : Void {
		if(!other.overlaps(blood)) return;
		var sX : Bool = FlxObject.separateX(blood, other);
		var sY : Bool = FlxObject.separateY(blood, other);
		if(sX)
			blood.makeGraphic(4, 6, 0xffee2222);
		else
			blood.makeGraphic(6, 4, 0xffee2222);
		if(blood.isTouching(FlxObject.UP))
			blood.y -= 4;
		if(blood.isTouching(FlxObject.DOWN))
			blood.y += 4;
		if(blood.isTouching(FlxObject.RIGHT))
			blood.x += 4;
		if(blood.isTouching(FlxObject.LEFT))
			blood.x -= 4;
		blood.acceleration.set(0, 0);
		blood.velocity.set(0, 0);
		blood.solid = false;
	}
}