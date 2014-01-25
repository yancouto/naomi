package;

import flixel.FlxG;
import flixel.FlxObject;

class BearTrap extends Trap {
	public function new(x : Float, y : Float) {
		super(x, y, 50);

		makeGraphic(56, 16, 0xff006400);
	}

	inline private function notify(e1 : FlxObject, e2 : FlxObject) : Void {
		trigger(e2);
		state = true;
		color = 0xffe80e0e;
	}

	override public function update() : Void
		if(!state) FlxG.overlap(this, Reg.playState.enemies, notify);
}