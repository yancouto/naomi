package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;

import base.Enemy;
import base.Object;

class IdleToken extends FlxObject {
	public function new(obj : Object) {
		super(obj.x, obj.y, obj.width, obj.height);
	}

	private function collide(e : Enemy) {
		if(overlaps(e)) {
			e.velocity.x = -e.velocity.x;			
			FlxObject.separate(e, this);
		}
	}

	public static function manageCollision(token : IdleToken, e : Enemy) {
		token.collide(e);
	}

	public static var tokens : FlxTypedGroup<IdleToken>;
}