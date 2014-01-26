package;

import flixel.FlxSprite;
import base.Enemy;
import base.Circuitry;

class Lever extends base.Interactible implements Circuitry {
	public var state : Bool;

	public function new(x : Float, y : Float, id : String) {
		super(x, y, .2);
		loadGraphic("assets/images/leveranimation.png", true, false, 49, 35);
		animation.add("false", [0]);
		animation.add("true", [1]);
		animation.play("false");

		Reg.circuitryComponents.set(id, this);

		state = false;
	}

	override public function interact(e : Enemy) : Void {
		state = !state;
		animation.play(Std.string(state));
	}
}