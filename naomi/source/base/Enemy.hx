package base;

import flixel.FlxSprite;

class Enemy extends FlxSprite {
	private base_speed : Float;

	override public function new(x : Float, y : Float, ?graph : Dynamic) {
		super.new(x, y, graph);

		this.health = 100;
		this.base_speed = 100;
		this.acceleration.y = -420;
	}

	override public function update() {
		super.update();

		velocity.x = 0;
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