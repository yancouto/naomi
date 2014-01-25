package;

import flixel.FlxG;
import flixel.FlxObject;
import base.Interactible;
import base.Enemy;

class Button extends Interactible {
	private var state : Bool;

	public function new(x : Float, y : Float) {
		super(x, y, 0);

		makeGraphic(64, 16, 0xff00ff00);

		state = false;
	}

	private function notify(e1 : FlxObject, e2 : Enemy) : Void {
		state = FlxG.overlap(e1, e2);
		
		if(state)
			interact(e2);
	}

	override public function update() : Void {
		FlxG.overlap(this, Reg.playState.enemies, notify);
	}

	override public function interact(entity : Enemy) : Void {}
}