package;

import base.Enemy;

class Rat extends Enemy {
	public function new(x : Float, y : Float) {
		super(x, y);
		makeGraphic(32, 16, 0xffff0000);
		base_speed = 200;
	}
}