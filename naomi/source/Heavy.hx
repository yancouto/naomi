package;

import flixel.FlxObject;
import flixel.FlxSprite;
import base.Timer;
import base.Enemy;

class Heavy extends Enemy {
	public function new(obj : base.Object) {
		super(obj.x, obj.y + obj.height - 112);

		loadGraphic("assets/images/heavy_animation_big.png", true, true, 120, 136);
		animation.add("idle", [0]);
		animation.add("walking", [0, 1, 2, 3, 4, 3, 2, 1], 6);
		animation.play("idle");

		setSize(40, 112);
		offset.set(28, 24);
		
		if(obj.properties.get("facing") == "left") {
			facing = FlxObject.LEFT;
			offset.set(120 - 68, 24);
		}
		else
			facing = FlxObject.RIGHT;

		health = 200;
	
		jumps = 1;
		jumpSpeed = 300;

		base_speed = 80;

		mass = 100;

		maxVelocity.x = 80;

		healthColor = 0xff881221;
	}

	override public function walkLeft() : Void {
		super.walkLeft();
		offset.set(120 - 68, 24);
	}

	override public function walkRight() : Void {
		super.walkRight();
		offset.set(28, 24);
	}

	override private function deadParts() : Void {
		var sizes : Array<Int> = [40, 40, 20, 28, 49, 19, 24];
		var height = 54;
		var img = new FlxSprite().loadGraphic("assets/images/heavy_parts.png", false);
		var i = 0;
		for(size in sizes) {
			var temp = new FlxSprite().makeGraphic(size, height, 0x00000000);
			temp.stamp(img, -i, 0);
			temp.velocity.set(Math.random() * 600 - 300, -Math.random() * 600);
			temp.setPosition(x + Math.random() * width, y + Math.random() * height);
			temp.angularVelocity = Math.random() * 200 - 100;
			temp.acceleration.y = 420;
			Reg.playState.add(temp);
			i += size;
			Timer.callIn(Math.random() * 2 + 3, function() { temp.destroy(); });
		}
	}
}