package;

import flixel.FlxObject;
import base.Enemy;

class Heavy extends Enemy {
	public function new(x : Float, y : Float) {
		super(x, y);

		loadGraphic("assets/images/ratfinal.png", true, true, 62, 29);
		animation.add("idle", [0]);
		animation.add("walking", [0, 1], 4);
		animation.play("idle");
		facing = FlxObject.RIGHT;

		health = 200;
	
		jumps = 1;
		jumpSpeed = 180;

		base_speed = 80;
	}
}