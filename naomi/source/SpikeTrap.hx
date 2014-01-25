package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class SpikeTrap extends Trap {
	public function new(x : Float, y : Float) {
		super(x, y, 999999);

		makeGraphic(10, 150, 0xfff2750e);
	}

	inline private function notify(e1 : FlxObject, e2 : FlxObject) : Void
		trigger(e2);

	override public function update() : Void
		FlxG.overlap(this, Reg.playState.enemies, notify);
}