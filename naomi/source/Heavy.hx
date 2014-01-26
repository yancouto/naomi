package;

import flixel.FlxObject;
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
		jumpSpeed = 270;

		base_speed = 80;

		mass = 100;

		maxVelocity.x = 80;
	}
}