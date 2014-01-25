package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import base.Enemy;

class Button extends FlxSprite {
	public var state : Bool;
	public static var buttons : FlxTypedGroup<Button>;

	static function __init__() : Void {
		buttons = new FlxTypedGroup <Button>();
	}

	public function new(x : Float, y : Float) {
		super(x, y);
		loadGraphic("assets/images/buttonanimation.png", true, false, 50, 10);
		animation.add("false", [0]);
		animation.add("true", [1]);
		animation.play("false");

		state = false;
	}

	private static function press(b : Button, e : Enemy) : Void
		b.state = true;

	private static function filter(b : Button, e : Enemy) : Bool
		return e.mass >= 10;

	override public function update() : Void {
		super.update();
		state = false;
		FlxG.overlap(this, Reg.playState.enemies, press, filter);
		animation.play(Std.string(state));
	}
}