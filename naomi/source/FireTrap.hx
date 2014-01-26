package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import base.Timer;

class FireTrap extends Trap {
	private var cooldown : Timer;

	public function new(obj : base.Object) {
		super(obj.x, obj.y, .1);

		loadGraphic("assets/images/fireanimation.png", true, false, 64, 300);
		animation.add("on", [1, 2, 3], 12);
		animation.add("off", [0]);
		animation.play("off");

		var timeOn = obj.properties.exists("timeOn")? Std.parseFloat(obj.properties.get("timeOn")) : 3;
		var timeOff = obj.properties.exists("timeOff")? Std.parseFloat(obj.properties.get("timeOff")) : 3;
		var delay = obj.properties.exists("delay")? Std.parseFloat(obj.properties.get("delay")) : 0;
		var rWidth = 37, rHeight = 281;
		var side = obj.properties.exists("side")? obj.properties.get("side") : "down";
		origin.set(0, 0);
		if(side == "down") {
			offset.set(12, 18);
		} else if(side == 'up') {
			angle = 180;
			y -= height;
			y += obj.height;
			offset.set(12 - width, -height);
		} else if(side == 'right') {
			angle = -90;
			rWidth = 281; rHeight = 37;
			offset.set(18, 12 - width);
		} else {
			angle = 90;
			rWidth = 281; rHeight = 37;
			x -= height;
			x += obj.width;
			offset.set(-height, 12);
		}
		setSize(0, 0);


		Timer.callIn(delay, function() {
			cooldown = new Timer({timeToSet: timeOff, 
				callback: function(self : Timer) {
					state = !state;
					self.timeToSet = self.timeToSet == timeOn? timeOff : timeOn;
					
					if(state) {
						animation.play("on");
						setSize(rWidth, rHeight);
					}
					else {
						animation.play("off");
						setSize(0, 0);
					}
				}, running: true, repeats: true});
		});

		state = false;
	}

	inline public function notify(e1 : FlxObject, e2 : FlxObject) : Void {
		trigger(e2);
	}

	override public function update() : Void {
		super.update();

		if(state)
			FlxG.overlap(this, Reg.playState.enemies, notify);
	}
}