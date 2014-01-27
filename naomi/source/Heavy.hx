package;

import flixel.FlxObject;
import flixel.FlxSprite;
import base.Timer;
import base.Enemy;

class Heavy extends Enemy {
	public function new(x : Float, y : Float) {
		super(x, y);

		loadGraphic("assets/images/heavyanimation.png", true, true, 95, 128);
		animation.add("idle", [0]);
		animation.add("walking", [0,1,2,1], 6);
		animation.play("idle");
		facing = FlxObject.RIGHT;

		health = 200;
	
		jumps = 1;
		jumpSpeed = 300;

		base_speed = 80;

		mass = 100;

		maxVelocity.x = 80;

		healthColor = 0xff881221;
	}

	override private function deadParts() : Void {
		var sizes : Array<Int> = [44, 64, 58, 36, 91];
		var height = 54;
		var img = new FlxSprite().loadGraphic("assets/images/HEAVYPARTS.png", false);
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