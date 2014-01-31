package;

import flixel.FlxG;
import flixel.FlxObject;

class BearTrap extends Trap {
	public function new(obj : base.Object) { // Assumes the object is touching the floor
		super(obj.x, obj.y + obj.height - 10, 50);

		loadGraphic("assets/images/beartrapanimation.png", true, false, 60, 45);
		animation.add("open", [0]);
		animation.add("closing", [1, 2], 15, false);
		animation.play("open");

		offset.set(0, 35);
		setSize(60, 10);
	}

	inline private function notify(e1 : FlxObject, e2 : FlxObject) : Void {
		trigger(e2);
		state = true;
		animation.play("closing");
	}

	override public function update() : Void {
		super.update();
		if(!state) FlxG.overlap(this, Reg.playState.enemies, notify);
	}
}