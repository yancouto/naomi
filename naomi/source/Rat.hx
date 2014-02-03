package;

import base.Enemy;
import flixel.FlxObject;
import flixel.FlxSprite;
import base.Timer;

class Rat extends Enemy {
	private static inline var tailSize = 18;

	public function new(x : Float, y : Float) {
		super(x, y);
		loadGraphic("assets/images/rat_animation.png", true, true, 64, 32);

		offset.set(tailSize, 0);
		setSize(64 - tailSize, 31);

		animation.add("idle", [0]);
		animation.add("walking", [0, 1], 4);
		animation.play("idle");
		facing = FlxObject.RIGHT;
		base_speed = 200;
		jumps = 0;

		health = 50;
	
		mass = 1;
		maxVelocity.x = 200;

		healthColor = 0xff999999;
	}

	override public function walkLeft() : Void {
		super.walkLeft();
		offset.set(0, 0);
	}

	override public function walkRight() : Void {
		super.walkRight();
		offset.set(tailSize, 0);
	}

	override private function deadParts() : Void {
		var sizes : Array<Int> = [25, 31, 32];
		var height = 24;
		var img = new FlxSprite().loadGraphic("assets/images/rat_parts.png", false);
		var i = 0;
		for(size in sizes) {
			var temp = new FlxSprite().makeGraphic(size, height, 0x00000000);
			temp.stamp(img, -i, 0);
			temp.velocity.set(Math.random() * 600 - 300, -Math.random() * 600);
			temp.setPosition(x + Math.random()*width, y + Math.random()*height);
			temp.acceleration.y = 420;
			Reg.playState.add(temp);
			i += size;
			Timer.callIn(Math.random()*2 + 3, function() { temp.destroy(); });
		}
	}
}