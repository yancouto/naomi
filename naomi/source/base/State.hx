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

	override public function destroy() : Void {
		Timer.destroy();
		super.destroy();
	}

	public override function update() {
		Timer.updateTimers(FlxG.elapsed);

		if(FlxG.keys.justPressed.M)
			Reg.toggleMuted();

		super.update();
	}
}