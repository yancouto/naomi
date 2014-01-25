package;

impor flixel.FlxSprite;

// DOOR HACKING
class Door extends FlxSprite {
	public function new(x : Float, y : Float) {
		super(x, y);
		loadGraphics("assets/images/door.png", false, false);
	}
}