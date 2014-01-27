package;

import base.Enemy;
import flixel.FlxObject;
import flixel.FlxSprite;
import base.Timer;

class Rat extends Enemy {
	public function new(x : Float, y : Float) {
		super(x, y);
		loadGraphic("assets/images/ratfinal.png", true, true, 62, 29);
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

	override private function deadParts() : Void {
		var sizes : Array<Int> = [27, 46, 27];
		var height = 32;
		var img = new FlxSprite().loadGraphic("assets/images/RATPARTS.png", false);
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