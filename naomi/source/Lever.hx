package;

import flixel.FlxSprite;
import base.Enemy;

class Lever extends base.Interactible {
	public var on : Bool;

	public function new(x : Float, y : Float) {
		super(x, y, 1);
		loadGraphic("assets/images/leveranimation.png", true, false, 49, 35);
		animation.add("off", [0]);
		animation.add("on", [1]);
		animation.play("off");
		on = false;
	}

	override public function interact(e : Enemy) : Void {
		if(animation.name == "on") animation.play("off");
		else animation.play("on");
		on = !on;
	}
}