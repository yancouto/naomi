package base;

import flixel.FlxState;
import flixel.FlxG;
import flixel.group.FlxTypedGroup;

// More stuff here later, probably.
class State extends FlxState {

	public override function draw() {
		super.draw();
		#if !FLX_NO_DEBUG
			super.drawDebug();
		#end
	}

	public override function update() {
		Timer.updateTimers(FlxG.elapsed);
		super.update();
	}
}