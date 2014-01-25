package base;

import flixel.FlxSprite;

class Enemy extends FlxSprite {
	private var base_speed : Float;

	override public function new(x : Float, y : Float, ?graph : Dynamic) {
		super(x, y, graph);

		health = 100;
		base_speed = 100;
		acceleration.y = 500;
		drag.x = 400;
	}

	/* Override the following: */
	public function walkRight() {
		velocity.x = base_speed;
	}
	public function walkLeft() {
		velocity.x = -base_speed;
	}
	public function jump() {}
}