package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class SpikeTrap extends Trap {
	public function new(obj : base.Object) {
		super(obj.x, obj.y, 999999);
		if(obj.properties.exists("angle"))
			angle = Std.parseFloat(obj.properties.get("angle"));

		loadGraphic("assets/images/spikes.png", false);
	}

	inline private function notify(e1 : FlxObject, e2 : FlxObject) : Void
		trigger(e2);

	override public function update() : Void {
		super.update();
		FlxG.overlap(this, Reg.playState.enemies, notify);
	}
}