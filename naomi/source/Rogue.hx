package;

import flixel.FlxObject;
import base.Enemy;
import flixel.FlxG;

class Rogue extends Enemy {
	public function new(x : Float, y : Float) {
		super(x, y);
		
		loadGraphic("assets/images/rogueeanimation.png", true, true, 42, 84);
		animation.add("idle", [0]);
		animation.add("walking", [0, 1, 2, 1], 10);
		animation.play("idle");
		facing = FlxObject.RIGHT;

		health = 100;

		jumps = 2;
		jumpSpeed = 370;

		base_speed = 250;
		drag.x = 700;
	
		mass = 10;
	}
}