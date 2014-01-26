package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import base.Timer;

class FireTrap extends Trap {
	private var cooldown : Timer;

	public function new(x : Float, y : Float, ?duration : Float) {
		super(x, y, .1);

		makeGraphic(32, 30, 0xff270ee8);

		var ref = this;
		cooldown = new Timer({timeToSet: duration==null?3:duration, 
			callback: function(self : Timer) {
				state = !state;
				cooldown.reset();
				
				if(state)
					makeGraphic(32, 300, 0xffe80e0e);
				else
					makeGraphic(32, 30, 0xff270ee8);
			}, running: true, repeats: true});

		state = false;
	}

	inline public function notify(e1 : FlxObject, e2 : FlxObject) : Void {
		trigger(e2);
	}

	override public function update() : Void {
		if(state)
			FlxG.overlap(this, Reg.playState.enemies, notify);
	}
}