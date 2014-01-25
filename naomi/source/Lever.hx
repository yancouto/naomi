package;

import flixel.FlxSprite;
import base.Enemy;

class Lever extends base.Interactible {
	public var on : Bool;

	public function new(x : Float, y : Float) {
		super(x, y, .2);
		loadGraphic("assets/images/leveranimation.png", true, false, 49, 35);
		animation.add("false", [0]);
		animation.add("true", [1]);
		animation.play("false");
		on = false;
	}

	override public function interact(e : Enemy) : Void {
		on = !on;
		animation.play(Std.string(on));
	}

	override public function draw() : Void {
		super.draw();
		trace('#yolo');
	}

	override public function update() : Void {
		super.update();
		trace('#swag');
	}
}