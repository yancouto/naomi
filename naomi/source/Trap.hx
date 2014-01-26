package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxTypedGroup;
import base.Circuitry;

class Trap extends FlxSprite implements Circuitry {
	private var base_damage : Float;
	public var state : Bool;

	public function new(x : Float, y : Float, damage : Float = 20) {
		super(x, y);

		base_damage = damage;
		immovable = true;
		state = false;
	}

	/* Override this! */
	public function trigger(victim : FlxObject) : Void {
		victim.hurt(base_damage);
		state = true;
	}

	public static var traps : FlxTypedGroup<Trap>;
}