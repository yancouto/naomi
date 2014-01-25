package base;

import flixel.FlxSprite;
import flixel.FlxObject;

class Enemy extends FlxSprite {
	private var base_speed : Float;
	private var idle : Bool;

	public function new(x : Float, y : Float) {
		super(x, y);

		health = 100;
		base_speed = 100;
		acceleration.y = 500;
		drag.x = 400;
		idle = true;
	}

	/* Override the following: */
	public function walkRight() : Void {
		velocity.x = base_speed;
		animation.play("walking");
		idle = false;
		facing = FlxObject.RIGHT;
	}
	public function walkLeft() : Void {
		velocity.x = -base_speed;
		animation.play("walking");
		idle = false;
		facing = FlxObject.LEFT;
	}
	public function jump() {}

	override public function update() : Void {
		super.update();
		if(!idle && velocity.x == 0) {
			idle = true;
			animation.play("idle");
		}
	}
}