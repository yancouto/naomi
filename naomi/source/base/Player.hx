package base;

import flixel.FlxBasic;
import flixel.FlxSprite;

class Player extends FlxBasic {
	private var ref : FlxSprite;

	override public function new(_ref : FlxSprite) ref = _ref;

	public function getReference() : FlxSprite return ref;

	override public function update() {
		super.update();
		ref.update();
	}
}