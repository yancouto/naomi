package;

import flixel.FlxSprite;
import base.Enemy;
import base.Circuitry;

class Lever extends base.Interactible implements Circuitry {
	public var state : Bool;

	public function new(obj : base.Object) { // Assumes the object is touching the floor
		super(obj.x, obj.y + obj.height - 50, .2);
		loadGraphic("assets/images/leveranimation.png", true, false, 49, 50);
		animation.add("false", [0]);
		animation.add("true", [1]);
		animation.play("false");

		Reg.circuitryComponents.set(obj.properties.get("id"), this);

		state = false;
	}

	override public function interact(e : Enemy) : Void {
		state = !state;
		animation.play(Std.string(state));
	}
}