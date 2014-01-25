package base;

import flixel.FlxSprite;
import flixel.FlxObject;

class Enemy extends FlxSprite {
	private var base_speed : Float;
	private var idle : Bool;
	private var jumps : Int;
	private var jumpCount : Int;
	private var jumpSpeed : Float;

	public function new(x : Float, y : Float) {
		super(x, y);

		health = 100;
		base_speed = 100;
		acceleration.y = 500;
		drag.x = 400;
		idle = true;
		jumps = 1;
		jumpCount = 0;
		jumpSpeed = 200;
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
	public function jump() : Void {
		if(jumpCount < jumps) {
			jumpCount++;
			velocity.y = -jumpSpeed;
		}
	}

	override public function update() : Void {
		super.update();
		if(!idle && velocity.x == 0) {
			idle = true;
			animation.play("idle");
		}
		if(jumps > 0 && overlaps(Reg.floor))
			jumpCount = 0;
	}
}