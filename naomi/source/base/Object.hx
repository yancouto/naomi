package base;

import flixel.FlxObject;

class Object extends FlxObject {
	public var properties : Map<String, String>;

	public function new(x : Float, y : Float, width : Float, height : Float, p : Map<String, String>) {
		super(x, y, width, height);
		properties = p;
	}
}