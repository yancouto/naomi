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
		super(obj.x + Math.random() * obj.width, obj.y + Math.random() * obj.height);
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
		FlxObject.separate(blood, other);
		blood.makeGraphic(5, 5, 0xffee2222); // makes it touch the surfaces
		blood.acceleration.set(0, 0);
		blood.velocity.set(0, 0);
		blood.solid = false;
	}
}