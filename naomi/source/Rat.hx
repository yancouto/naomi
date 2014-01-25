package;

import base.Enemy;
import flixel.FlxObject;

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
	}
}