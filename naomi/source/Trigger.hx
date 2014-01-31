package;

import flixel.FlxObject;
import flixel.FlxG;

class Trigger extends FlxObject implements base.Circuitry {
	public var state : Bool;

	public function new(obj : base.Object) {
		super(obj.x, obj.y, obj.width, obj.height);
		state = false;
		Reg.circuitryComponents.set(obj.properties.get("id"), this);
	}

	private static function handleOverlap(tr : Trigger, en : base.Enemy)
		tr.state = true;

	override public function update() : Void {
		super.update();
		state = false;
		FlxG.overlap(this, Reg.playState.enemies, handleOverlap); // maybe bundle all triggers in a FlxTypedGroup? We'll see.
	}
}