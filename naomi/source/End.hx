package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

import base.Interactible;
import base.Enemy;
import base.Timer;

import levels.*;

/* End of the level. Stairs with cool animations.
*  Will load the next level ('simple' levels with "next" and 'complex' (with their own State) with "nextState")
*/
class End extends Interactible {
	private var next : String;
	private var nextState : String;

	public function new(obj : base.Object) {
		super(obj.x, obj.y, 100);

		loadGraphic("assets/images/stairexitanimation.png", true, false, 128, 128);
		animation.add("empty", [0]);
		animation.add("going_up", [1, 2, 3, 4, 0], 5, false);
		animation.play("empty");
	
		if(!obj.properties.exists("next") && !obj.properties.exists("nextState"))
			throw "Ends should have field \"next\" or \"nextState\".";
		next = obj.properties.get("next");
		nextState = obj.properties.get("nextState");
	}

	public function activate() : Void {
		if(next == null)
			FlxG.switchState(Type.createInstance(Type.resolveClass(nextState), []));
		else {
			SimpleLevel.levelName = next;
			FlxG.switchState(new SimpleLevel());
		}
	}

	override public function interact(entity : Enemy) : Void {
		animation.play("going_up");
		Reg.player.possess(null);
		FlxG.camera.fade(0xff000000, 1.8, false, false);
		if(next == null)
			Timer.callIn(2, function() { FlxG.switchState(Type.createInstance(Type.resolveClass(nextState), [])); });
		else {
			SimpleLevel.levelName = next;
			Timer.callIn(2, function() { FlxG.switchState(new SimpleLevel()); });	
		}
	}

	public function getNext()
		return next == null ? nextState : next;
}