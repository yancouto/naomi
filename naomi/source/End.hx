package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

import base.Interactible;
import base.Enemy;
import base.Timer;

class End extends Interactible {
	private var next : String;

	public function new(x : Float, y : Float, ?_next : String) {
		super(x, y, 100);

		loadGraphic("assets/images/stairexitanimation.png", true, false, 128, 128);
		animation.add("empty", [0]);
		animation.add("going_up", [1, 2, 3, 4], 8, false);
		animation.play("empty");
	
		next = _next==null?Type.getClassName(Type.getClass(Reg.playState)):_next;
	}

	override public function interact(entity : Enemy) : Void {
		animation.play("going_up");
		Reg.player.controlled = null;
		FlxG.camera.fade(0xff000000, 4.8, false, false);
		Timer.callIn(5, function() { FlxG.switchState(Type.createInstance(Type.resolveClass(next), [])); });
	}
}