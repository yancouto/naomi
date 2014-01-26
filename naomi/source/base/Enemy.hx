package base;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;

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
		acceleration.x += drag.x;
		animation.play("walking");
		idle = false;
		facing = FlxObject.RIGHT;
	}
	public function walkLeft() : Void {
		acceleration.x -= drag.x;
		animation.play("walking");
		idle = false;
		facing = FlxObject.LEFT;
	}
	public function jump() : Void {
		if(jumpCount < jumps) {
			jumpCount++;
			y -= 1;
			velocity.y = -jumpSpeed;
		}
	}

	override public function update() : Void {
		super.update();
		acceleration.x = 0;
		if(!idle && velocity.x == 0) {
			idle = true;
			animation.play("idle");
		}
		if(jumps > 0 && jumpCount == 0 && velocity.y != 8)
			jumpCount = 1;
		if(jumps > 0 && jumpCount > 0 && velocity.y == 8 /* MAGIC NUMBER */ 
			&& (overlaps(Reg.floor) || overlaps(Platform.platforms))) 
			jumpCount = 0;
	}

	override public function kill() : Void {
		super.kill();

		if(this == Reg.player.controlled)
			Reg.player.controlled = null;

		FlxG.resetState();
	}
}