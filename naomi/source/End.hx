package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

import base.Interactible;
import base.Enemy;

class End extends Interactible {
	private var next : String;

	public function new(x : Float, y : Float, ?_next : String) {
		super(x, y, .2);

		makeGraphic(64, 128, 0xff000000);
	
		next = _next==null?Type.getClassName(Type.getClass(Reg.playState)):_next;
	}

	override public function interact(entity : Enemy) : Void
		FlxG.switchState(Type.createInstance(Type.resolveClass(next), []));
}